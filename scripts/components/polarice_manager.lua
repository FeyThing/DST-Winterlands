local WIDTH, HEIGHT

local gradient_configs = {
	[-2] = 0, -- None
	[-1] = 3, -- Less
	[0] = 5,  -- Default
	[1] = 7,  -- More
	[2] = 10  -- Most, that's a LOT of ice
}

local POLAR_ICEGEN_CONFIG = TUNING.POLAR_ICEGEN_CONFIG
local MAX_GRADIENT_DEPTH = gradient_configs[POLAR_ICEGEN_CONFIG]

local MIN_TEMPERATURE = -31
local MAX_TEMPERATURE = 100

local FLOATEROBJECT_TAGS = {"floaterobject"}
local IGNORE_ICE_TAGS = {"activeprojectile", "oceanshoalspawner", "irreplaceable", "flying", "FX", "DECOR", "INLIMBO", "NOCLICK"}
local ICE_CRACK_TAGS = {"ice_crack_fx"}

local TILE_RADIUS_PLUS_OVERHANG = ((TILE_SCALE / 2) + 1) * 1.4142

return Class(function(self, inst)
	assert(inst.ismastersim, "Polar Ice Manager should not exist on the client!")
	
	-- [ Public fields ] --
	
	self.inst = inst
	
	self.IGNORE_ICE_BREAKING_ONREMOVE_TAGS = shallowcopy(IGNORE_ICE_TAGS)
	self.IGNORE_ICE_FORMING_ONREMOVE_TAGS = shallowcopy(IGNORE_ICE_TAGS)
	self.ICE_FORMING_BLOCKER_TAGS = {"shadecanopy", "shadecanopysmall", "crabking", "boat", "oceantrawler"}
	self.ICE_DESTROY_BLOCKER_TAGS = {"icecaveshelter", "polarcave_entrance", "protuberancespawnblocker"}
	
	local breaking_ignore_tags = {"ignorewalkableplatformdrowning"}
	local forming_ignore_tags = {"underwater_salvageable", "walkableplatform"}
	
	for i, v in ipairs(breaking_ignore_tags) do
		table.insert(self.IGNORE_ICE_BREAKING_ONREMOVE_TAGS, v)
	end
	
	for i, v in ipairs(forming_ignore_tags) do
		table.insert(self.IGNORE_ICE_FORMING_ONREMOVE_TAGS, v)
	end
	
	-- [ Private fields ] --
	
	local initial_load = true
	local _map = inst.Map
	
	local _gradient_indeces = {} -- Indeces for the next iteration of the gradient
	local _icegrid -- Stores [0 - 1] values defining the temperature tolerance of ice tiles
	local _icelayers = { -- Caches all tiles' indeces by state & valid distance from the Winterlands border
		blocked = {},
		cracking = {},
		loot = {},
		temporary_ice = {},
		temporary_holes = {},
	}
	
	local _current_layer = 1
	local _next_update
	local _world_temperature = TUNING.STARTING_TEMP
	
	-- [ Functions ] --
	
	local function InitialLoad()
		-- Unfortunately always incorrect at this time due to how long it takes for worldstates to finish setting up, but we can't afford waiting
		local melting_layer = self:GetMeltingLayer()
		
		for i, level in pairs(_icegrid.grid) do
			local tx, ty = _icegrid:GetXYFromIndex(i)
			
			-- Immediately populating all tiles in range by icy tiles / icy water
			if level > 0 and _map:IsOceanTileAtPoint(_map:GetTileCenterPoint(tx, ty)) then
				if level > melting_layer then
					self:CreateIceAtTile(tx, ty)
				else
					_map:SetTile(tx, ty, WORLD_TILES.OCEAN_POLAR)
				end
			end
		end
		
		initial_load = false
	end
	
	local LAUNCH_HEIGHT = 0.1
	local LUNCH_SPEED = 6
	
	local function LaunchAway(item, pos)
		local ix, iy, iz = item.Transform:GetWorldPosition()
		local cosa, sina = 0, 0
		
		item.Physics:Teleport(ix, iy + LAUNCH_HEIGHT, iz)
		
		if pos then
			local px, py, pz = pos:Get()
			local angle = (180 - item:GetAngleToPoint(px, py, pz)) * DEGREES
			
			sina, cosa = math.sin(angle), math.cos(angle)
		end
		
		item.Physics:SetVel(LUNCH_SPEED * cosa, 2 + LUNCH_SPEED, LUNCH_SPEED * sina)
	end
	
	local function RemoveCracks(x, y, z)
		local cracks = TheSim:FindEntities(x, 0, z, 2, ICE_CRACK_TAGS)
		
		for i = #cracks, 1, -1 do
			cracks[i]:Remove()
		end
	end
	
	local function SpawnCracks(x, y, z)
		local crack = SpawnPrefab("fx_ice_crackle")
		crack.Transform:SetPosition(x, y, z)
		crack:AddTag("scarytoprey")
		
		local function SpawnFx(lx, lz, rot)
			local crack = SpawnPrefab("ice_crack_grid_fx")
			crack.Transform:SetPosition(lx, y, lz)
			crack.Transform:SetRotation(rot)
			crack.AnimState:SetScale(1.2, 1.2, 1.2)
		end
		
		SpawnFx(x, z, -40 + math.random() * 80)
		SpawnFx(x, z, 50 + math.random() * 80)
	end
	
	local function SpawnDebris(debris_prefab, x, y, z)
		local debris = SpawnPrefab(debris_prefab)
		
		local debris_angle = math.random() * TWOPI
		local debris_speed = 2.5 + 2 * math.random()
		
		debris.Physics:Teleport(x, y, z)
		debris.Physics:SetVel(debris_speed * math.cos(debris_angle), 10, debris_speed * math.sin(debris_angle))
	end
	
	local function SpawnDegradePiece(x, y, z, degrade_angle)
		local degrade = SpawnPrefab("degrade_fx_ice")
		local degrade_offset = TUNING.OCEAN_ICE_RADIUS * (0.4 + 0.65 * math.sqrt(math.random()))
		
		degrade_angle = degrade_angle or math.random() * TWOPI
		center_x = center_x + (degrade_offset * math.cos(degrade_angle))
		center_z = center_z + (degrade_offset * math.sin(degrade_angle))
		
		degrade.Transform:SetPosition(x, y, z)
	end
	
	local function GenerateIceGradient(depth)
		assert(depth > 0, "Ice gradient depth must be positive!")
		
		local gradient_indeces = {}
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _icegrid:GetXYFromIndex(i)
			
			for x = -1, 1 do
				for y = -1, 1 do
					local nx, ny = ox + x, oy + y
					
					if self:GetDataAtTile(nx, ny) == 0 then
						local index = _icegrid:GetIndex(nx, ny)
						local level = depth / (MAX_GRADIENT_DEPTH + 1) -- Linear falloff based on how far we are from the Winterlands border
						
						self:SetIceLevelAtIndex(index, level)
						table.insert(gradient_indeces, index)
						
						local is_ice = _map:GetTile(nx, ny) == WORLD_TILES.POLAR_ICE
						self:SetIceStateAtIndex(index, level, is_ice)
					end
				end
			end
		end
		
		_gradient_indeces = gradient_indeces
		depth = depth - 1
		
		if depth > 0 and next(_gradient_indeces) then
			GenerateIceGradient(depth)
		end
	end
	
	-- [ Initialization ] --
	
	local function InitializeDataGrids(_, grid)
		if _icegrid then
			return
		end
		
		WIDTH, HEIGHT = _map:GetSize()
		_icegrid = DataGrid(WIDTH, HEIGHT)
		
		for i, ispolar in pairs(grid) do
			local cx, cy, cz = _map:GetTileCenterPoint(_icegrid:GetXYFromIndex(i))
			
			if ispolar then
				local tx, ty = _icegrid:GetXYFromIndex(i)
				
				-- Replacing the temporary icy tiles added during worldgen to some rooms with icy water (generating entities on land was easier than on water...)
				local is_ice = _map:GetTileAtPoint(cx, cy, cz) == WORLD_TILES.POLAR_ICE
				if initial_load and is_ice then
					_map:SetTile(tx, ty, WORLD_TILES.OCEAN_POLAR)
				end
				
				if not (_map:IsOceanTileAtPoint(cx, cy, cz) or is_ice) then
					table.insert(_gradient_indeces, i)
					self:SetIceLevelAtIndex(i, 1)
				end
			end
		end
		
		if self.init_data then
			self:OnLoad(self.init_data)
			self.init_data = nil
		end
		
		if MAX_GRADIENT_DEPTH > 0 then -- Can be 0 on None config
			GenerateIceGradient(MAX_GRADIENT_DEPTH)
		end
		
		if initial_load then
			InitialLoad()
			InitialLoad = nil
		end
		
		self:StartUpdates()
		
		inst:RemoveEventCallback("winterlands_initialized", InitializeDataGrids)
	end
	
	inst:ListenForEvent("winterlands_initialized", InitializeDataGrids)
	inst:ListenForEvent("temperaturetick", function(_, val) _world_temperature = val end)
	
	-- [ Methods ] --
	
	function self:SetIceLevelAtIndex(index, level)
		if index >= 0 and index < WIDTH * HEIGHT then
			_icegrid:SetDataAtIndex(index, level)
		end
	end
	
	function self:SetIceLevelAtTile(tx, ty, level)
		local index = _icegrid:GetIndex(tx, ty)
		self:SetIceLevelAtIndex(index, level)
	end
	
	function self:SetIceStateAtIndex(index, level, value)
		if _icelayers[level] == nil then
			_icelayers[level] = {}
		end
		
		_icelayers[level][index] = value
	end
	
	function self:SetIceStateAtTile(tx, ty, level, value)
		local index = _icegrid:GetIndex(tx, ty)
		self:SetIceStateAtIndex(index, level, value)
	end
	
	function self:IsTileBlockedByEntities(tx, ty, destroying)
		local cx, cy, cz = _map:GetTileCenterPoint(tx, ty)
		local tags = destroying and self.ICE_DESTROY_BLOCKER_TAGS
			or self.ICE_FORMING_BLOCKER_TAGS
		
		local blocker = next(TheSim:FindEntities(cx, cy, cz, TUNING.POLAR_ICEGEN_BLOCKER_DIST, nil, nil, tags))
		if blocker then
			local index = _icegrid:GetIndex(tx, ty)
			self:SetIceStateAtIndex(index, "blocked", TUNING.POLAR_ICEGEN_DEFAULT_BLOCKED_TIME)
		end
		
		return blocker ~= nil
	end
	
	function self:CanCreateIce(tx, ty, ignore_holes)
		if not self:IsTileBlockedByEntities(tx, ty) then
			local tile = _map:GetTile(tx, ty)
			
			if TileGroupManager:IsOceanTile(tile) or tile == WORLD_TILES.POLAR_ICE then
				local index = _icegrid:GetIndex(tx, ty)
				local is_ice, expiry, is_cracking = self:GetTileState(tx, ty)
				
				return not (not is_ice and expiry) or ignore_holes
			end
		end
		
		return false
	end
	
	-- The hand of creation
	
	function self:CreateIceAtTile(tx, ty, ice_duration, ignore_holes)
		if not self:CanCreateIce(tx, ty, ignore_holes) then
			return false
		end
		
		local cx, cy, cz = _map:GetTileCenterPoint(tx, ty)
		local is_ocean = _map:IsOceanTileAtPoint(cx, cy, cz)
		
		local current_tile = nil
		local undertile = inst.components.undertile
		
		if undertile then
			current_tile = _map:GetTile(tx, ty)
		end
		
		if is_ocean then
			_map:SetTile(tx, ty, WORLD_TILES.POLAR_ICE)
			if current_tile then
				undertile:SetTileUnderneath(tx, ty, current_tile)
			end
		end
		
		RemoveCracks(cx, 0, cz)
		
		local entities_near_ice = TheSim:FindEntities(cx, 0, cz, TILE_RADIUS_PLUS_OVERHANG, nil, self.IGNORE_ICE_FORMING_ONREMOVE_TAGS)
		
		for _, ent in ipairs(entities_near_ice) do
			local ex, ey, ez = ent.Transform:GetWorldPosition()
			
			if _map:IsPassableAtPoint(ex, ey, ez) then
				if ent.components.inventoryitem and ent.Physics and is_ocean then
					if not ent.components.inventoryitem.nobounce then
						LaunchAway(ent)
					end
					ent.components.inventoryitem:SetLanded(false, true)
				end
				
				if ent.OnPolarFreeze then
					ent:OnPolarFreeze(true)
				elseif ent.components.oceanfishable then
					local rod = ent.components.oceanfishable:GetRod()
					
					if rod and rod.components.oceanfishingrod then
						rod.components.oceanfishingrod:StopFishing(ent:HasTag("fishinghook") and "badcast" or "linesnapped", false) -- A bit unfair, so we keep the stuff attached on rod
					end
				elseif not ent:HasTag("locomotor") and ent:HasTag("ignorewalkableplatforms") then -- Ocean stuff
					print("Polar Ice (Forming) removed ent:", ent)
					DestroyEntity(ent, inst, true, true)
				end
			end
		end
		
		local floaterobjects = TheSim:FindEntities(cx, 0, cz, TILE_RADIUS_PLUS_OVERHANG, FLOATEROBJECT_TAGS)
		for _, floaterobject in ipairs(floaterobjects) do
			local ex, ey, ez = floaterobject.Transform:GetWorldPosition()
			
			if floaterobject.components.floater and _map:IsPassableAtPoint(ex, ey, ez) then
				local fx, fy, fz = floaterobject.Transform:GetWorldPosition()
				if _map:IsOceanTileAtPoint(fx, fy, fz) then
					floaterobject:PushEvent("on_landed")
				else
					floaterobject:PushEvent("on_no_longer_landed")
				end
			end
		end
		
		local index = _icegrid:GetIndex(tx, ty)
		
		if ice_duration then
			self:SetIceStateAtIndex(index, "temporary_ice", GetTime() + ice_duration)
		else
			local level = self:GetDataAtTile(tx, ty)
			self:SetIceStateAtIndex(index, level, true)
		end
		
		self:SetIceStateAtIndex(index, "cracking", nil)
		self:SetIceStateAtIndex(index, "temporary_holes", nil)
		
		return true
	end
	
	function self:CreateIceAtPoint(x, y, z, ice_duration, ignore_holes)
		local tx, ty = _map:GetTileCoordsAtPoint(x, y, z)
		self:CreateIceAtTile(tx, ty, ice_duration, ignore_holes)
	end
	
	-- The hand of destruction
	
	function self:DestroyIceAtTile(tx, ty, hole_duration, debris)
		local tile = _map:GetTile(tx, ty)
		if tile ~= WORLD_TILES.POLAR_ICE or self:IsTileBlockedByEntities(tx, ty, true) then
			return
		end
		
		local default_tile = TheWorld.worldprefab == "shipwrecked" and WORLD_TILES.OCEAN_DEEP or WORLD_TILES.OCEAN_POLAR
		local old_tile = default_tile
		
		local undertile = inst.components.undertile
		local cx, cy, cz = _map:GetTileCenterPoint(tx, ty)
		
		if undertile then
			old_tile = undertile:GetTileUnderneath(tx, ty)
			
			if old_tile then
				undertile:ClearTileUnderneath(tx, ty)
			else
				old_tile = default_tile
			end
		end
		
		_map:SetTile(tx, ty, old_tile)
		
		local is_ocean_tile = IsOceanTile(old_tile)
		
		if is_ocean_tile then
			local entities_near_ice = TheSim:FindEntities(cx, cy, cz, TILE_RADIUS_PLUS_OVERHANG, nil, self.IGNORE_ICE_BREAKING_ONREMOVE_TAGS)
			
			for _, ent in ipairs(entities_near_ice) do
				local ex, ey, ez = ent.Transform:GetWorldPosition()
				
				if ent:IsValid() and not _map:IsPassableAtPoint(ex, ey, ez) then
					local has_drownable = ent.components.drownable ~= nil
					-- We're testing the overhang, so we need to verify that anything we find isn't
					-- still on some adjacent dock or land tile or other platform after we remove ourself.
					
					local ignore_drown = ent.entity:GetParent() or ent.components.amphibiouscreature or ent:GetCurrentPlatform()
					
					if not ignore_drown then
						if not has_drownable then
							if ent.OnPolarFreeze then
								ent:OnPolarFreeze(false)
							elseif ent.components.submersible then
								ent.components.submersible:Submerge()
							elseif ent.components.inventoryitem and ent.components.health == nil then
								ent.components.inventoryitem:SetLanded(false, true)
							elseif not ent:HasTag("ignorewalkableplatforms") then -- Not ocean stuff
								print("Polar Ice (Breaking) removed ent:", ent)
								DestroyEntity(ent, inst, true, true)
							end
						else
							local shore_point = has_drownable and Vector3(FindRandomPointOnShoreFromOcean(cx, cy, cz)) or nil -- Shouldn't be using this crap, TODO: Force wash ashore on a not-temp-tile
							ent:PushEvent("onsink", {boat = nil, shore_pt = shore_point})
						end
					end
				end
			end
		end
		
		local floaterobjects = TheSim:FindEntities(cx, 0, cz, TILE_RADIUS_PLUS_OVERHANG, FLOATEROBJECT_TAGS)
		for _, floaterobject in ipairs(floaterobjects) do
			local ex, ey, ez = floaterobject.Transform:GetWorldPosition()
			
			if floaterobject.components.floater and not _map:IsPassableAtPoint(ex, ey, ez) then
				local fx, fy, fz = floaterobject.Transform:GetWorldPosition()
				
				if is_ocean_tile or _map:IsOceanTileAtPoint(fx, fy, fz) then
					floaterobject:PushEvent("on_landed")
				else
					floaterobject:PushEvent("on_no_longer_landed")
				end
			end
		end
		
		local index = _icegrid:GetIndex(tx, ty)
		debris = debris or _icelayers.loot[index]
		
		if debris then
			SpawnDebris(debris, cx, 0.1, cz)
			
			-- TODO: Public loot table lookup for chance / quantities ?
			if debris == "ice" and math.random() > 0.1 then
				SpawnDebris(debris, cx, 0.1, cz)
			end
			
			self:SetIceStateAtIndex(index, "loot", nil)
		end
		
		-- Duration is expected when a tile didn't naturally melt !
		if hole_duration then
			-- TODO: Should probably be handled by loot layer and custom event for spawned items to configure the fish
			if TheWorld.components.oceanfish_in_ice_spawner and TheWorld.components.oceanfish_in_ice_spawner:CanSpawnIceCube(cx, 0, cz) then
				TheWorld.components.oceanfish_in_ice_spawner:SpawnIceCubeAt(cx, 0, cz) -- Luck based ? ^
			end
			
			local half_num_debris = math.random(4)
			local angle_per_debris = TWOPI / half_num_debris
			
			for i = 1, half_num_debris do
				SpawnDegradePiece(cx, 0, cz, (i + GetRandomWithVariance(0.5, 0.25)) * angle_per_debris)
				SpawnDegradePiece(cx, 0, cz, (i + GetRandomWithVariance(0.5, 0.25)) * angle_per_debris)
			end
			
			self:SetIceStateAtIndex(index, "temporary_holes", GetTime() + hole_duration)
		else
			local level = self:GetDataAtTile(tx, ty)
			self:SetIceStateAtIndex(index, level, false)
		end
		
		self:SetIceStateAtIndex(index, "cracking", nil)
		self:SetIceStateAtIndex(index, "temporary_ice", nil)
		
		RemoveCracks(cx, 0, cz)
		SpawnPrefab("fx_ice_pop").Transform:SetPosition(cx, 0, cz)
	end
	
	function self:StartDestroyingIceAtTile(tx, ty, hole_duration, delay_override, debris)
		local tile = _map:GetTile(tx, ty)
		if tile ~= WORLD_TILES.POLAR_ICE or self:IsTileBlockedByEntities(tx, ty, true) then
			return
		end
		
		local index = _icegrid:GetIndex(tx, ty)
		if _icelayers.cracking[index] then
			return
		end
		
		local t = GetTime()
		local delay = delay_override or TUNING.POLAR_ICEGEN_CRACKING_TIME
		self:SetIceStateAtIndex(index, "cracking", t + delay)
		
		SpawnCracks(_map:GetTileCenterPoint(tx, ty))
		
		if hole_duration then
			self:SetIceStateAtIndex(index, "temporary_holes", t + hole_duration + delay) -- Marking ahead, it's still ice just yet
		end
		if debris then
			self:SetIceStateAtIndex(index, "loot", debris)
		end
	end
	
	-- DataGrid utils
	
	function self:GetDataAtTile(tx, ty)
		return _icegrid:GetDataAtPoint(tx, ty) or 0
	end
	
	function self:GetDataAtPoint(x, y, z)
		return _icegrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end
	
	function self:GetTileState(tx, ty)
		local level = self:GetDataAtTile(tx, ty)
		local index = _icegrid:GetIndex(tx, ty)
		
		return _icelayers[level] and _icelayers[level][index], _icelayers.temporary_ice[index] or _icelayers.temporary_holes[index], _icelayers.cracking[index]
	end
	
	function self:GetMeltingLayer()
		local temperature = math.clamp(_world_temperature, MIN_TEMPERATURE, MAX_TEMPERATURE)
		local temperature_ratio = (temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE)
		
		local mult = 1 + 3 * temperature_ratio
		local add = -3 * temperature_ratio
		
		return math.clamp(-add / mult, 0, 1)
	end
	
	function self:IsTileInMeltingRange(tx, ty)
		return self:GetDataAtTile(tx, ty) <= self:GetMeltingLayer()
	end
	
	-- Updates
	
	function self:StartUpdates()
		_next_update = GetTime()
		self.inst:StartUpdatingComponent(self)
	end	
	
	function self:StopUpdates()
		-- Processing cracking / temp tiles is essential, so swap to minimal format instead of stopping
		_next_update = math.huge
		--self.inst:StopUpdatingComponent(self)
	end
	
	function self:OnUpdate(dt)
		local t = GetTime()
		local melting_layer = self:GetMeltingLayer()
		
		for index, expiry in pairs(_icelayers.cracking) do
			if t >= expiry then
				_icelayers.cracking[index] = nil
				local tx, ty = _icegrid:GetXYFromIndex(index)
				self:DestroyIceAtTile(tx, ty)
			end
		end
		
		local level_cache = {}
		for index, expiry in pairs(_icelayers.temporary_ice) do
			if t >= expiry then
				_icelayers.temporary_ice[index] = nil
				
				local tx, ty = _icegrid:GetXYFromIndex(index)
				local level = level_cache[index] or self:GetDataAtTile(tx, ty)
				level_cache[index] = level
				
				if melting_layer >= level and not (_icelayers[level] and _icelayers[level][index]) then
					self:DestroyIceAtTile(tx, ty)
				end
			end
		end
		
		for index, expiry in pairs(_icelayers.temporary_holes) do
			if t >= expiry then
				_icelayers.temporary_holes[index] = nil
				
				local tx, ty = _icegrid:GetXYFromIndex(index)
				local level = level_cache[index] or self:GetDataAtTile(tx, ty)
				
				if not (melting_layer >= level) and not (_icelayers[level] and _icelayers[level][index]) then
					self:CreateIceAtTile(tx, ty)
				end
			end
		end
		
		if t < (_next_update or 0) then
			return
		end
		
		local layers = {}
		for level in pairs(_icelayers) do
			if type(level) == "number" then
				layers[#layers + 1] = level
			end
		end
		
		if #layers == 0 then
			return
		else
			table.sort(layers, function(a, b) return a > b end)
		end
		
		local layer = layers[_current_layer]
		local tiles = _icelayers[layer]
		local should_freeze = layer > melting_layer
		
		local updated = 0
		local processed = {}
		
		for index, state in pairs(tiles) do
			if updated >= TUNING.POLAR_ICEGEN_TILES_PER_UPDATE then
				break
			end
			
			local tx, ty = _icegrid:GetXYFromIndex(index)
			local tile = _map:GetTile(tx, ty)
			
			if should_freeze then
				if tile ~= WORLD_TILES.POLAR_ICE and not _icelayers.blocked[index] then
					processed[#processed + 1] = {tx = tx, ty = ty, index = index}
					updated = updated + 1
				end
			else
				if tile == WORLD_TILES.POLAR_ICE and not _icelayers.blocked[index] 
					and not _icelayers.cracking[index] and not _icelayers.temporary_ice[index] then
					
					processed[#processed + 1] = {tx = tx, ty = ty, index = index}
					updated = updated + 1
				end
			end
		end
		
		if should_freeze then
			for _, data in ipairs(processed) do
				self:CreateIceAtTile(data.tx, data.ty)
			end
		else
			for _, data in ipairs(processed) do
				self:StartDestroyingIceAtTile(data.tx, data.ty)
			end
		end
		
		local completed = true
		for index, state in pairs(tiles) do
			local tx, ty = _icegrid:GetXYFromIndex(index)
			local tile = _map:GetTile(tx, ty)
			
			if should_freeze then
				if tile ~= WORLD_TILES.POLAR_ICE and self:CanCreateIce(tx, ty) then
					completed = false
					break
				end
			else
				if tile == WORLD_TILES.POLAR_ICE and not _icelayers.blocked[index] then
					completed = false
					break
				end
			end
		end
		
		if completed then
			_current_layer = should_freeze and math.min(_current_layer + 1, #layers) or math.max(_current_layer - 1, 1)
			
			_next_update = t + TUNING.POLAR_ICEGEN_COOLDOWN
		else
			_next_update = t + TUNING.POLAR_ICEGEN_COOLDOWN_SHORT
		end
	end
	
	-- [ Save / Load ] --
	
	function self:OnSave()
		local t = GetTime()
		
		local blocked_data = {}
		for index, expiry in pairs(_icelayers.blocked) do
			if expiry - t > 0 then
				blocked_data[index] = expiry - t
			end
		end
		
		local cracking_data = {}
		for index, expiry in pairs(_icelayers.cracking) do
			if expiry - t > 0 then
				cracking_data[index] = expiry - t
			end
		end
		
		local loot_data = {}
		for index, debris_prefab in pairs(_icelayers.loot) do
			loot_data[index] = debris_prefab
		end
		
		local temp_ice_data = {}
		for index, expiry in pairs(_icelayers.temporary_ice) do
			if expiry - t > 0 then
				temp_ice_data[index] = expiry - t
			end
		end
		
		local temp_holes_data = {}
		for index, expiry in pairs(_icelayers.temporary_holes) do
			if expiry - t > 0 then
				temp_holes_data[index] = expiry - t
			end
		end
		
		return {
			initial_load = initial_load,
			current_layer = _current_layer,
			blocked = blocked_data,
			cracking = cracking_data,
			loot = loot_data,
			temp_ice = temp_ice_data,
			temp_holes = temp_holes_data,
		}
	end
	
	function self:OnLoad(data)
		if not data then
			return
		end
		
		if data.initial_load ~= nil then
			initial_load = data.initial_load
		end
		if data.current_layer then
			_current_layer = data.current_layer
		end
		
		if _icegrid == nil then -- Can't restore tile states just yet, waiting for grid initialization...
			self.init_data = data
			return
		end
		
		local t = GetTime()
		
		if data.blocked then
			for index, time_remaining in pairs(data.blocked) do
				if time_remaining > 0 then
					_icelayers.blocked[index] = t + time_remaining
				end
			end
		end
		
		if data.cracking then
			for index, time_remaining in pairs(data.cracking) do
				if time_remaining > 0 then
					_icelayers.cracking[index] = t + time_remaining
					
					local tx, ty = _icegrid:GetXYFromIndex(index)
					if tx and ty then
						local cx, cy, cz = _map:GetTileCenterPoint(tx, ty)
						SpawnCracks(cx, cy, cz)
					end
				end
			end
		end
		
		if data.loot then
			for index, debris_prefab in pairs(data.loot) do
				_icelayers.loot[index] = debris_prefab
			end
		end
		
		if data.temp_holes then
			for index, time_remaining in pairs(data.temp_holes) do
				if time_remaining > 0 then
					_icelayers.temporary_holes[index] = t + time_remaining
				end
			end
		end
		
		if data.temp_ice then
			for index, time_remaining in pairs(data.temp_ice) do
				if time_remaining > 0 then
					_icelayers.temporary_ice[index] = t + time_remaining
				end
			end
		end
		
		if not initial_load then
			self:StartUpdates()
		end
	end
	
	function self:LongUpdate(dt)
		for index, expiry in pairs(_icelayers.blocked) do
			_icelayers.blocked[index] = expiry - dt
		end
		
		for index, expiry in pairs(_icelayers.cracking) do
			_icelayers.cracking[index] = expiry - dt
		end
		
		for index, expiry in pairs(_icelayers.temporary_ice) do
			_icelayers.temporary_ice[index] = expiry - dt
		end
		
		for index, expiry in pairs(_icelayers.temporary_holes) do
			_icelayers.temporary_holes[index] = expiry - dt
		end
		
		if _next_update then
			_next_update = _next_update - dt
		end
	end
end)