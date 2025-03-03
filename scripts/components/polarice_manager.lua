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

local STRENGTH_UPDATE_TIME = 16

local ICE_TILE_UPDATE_TIME = 6
local ICE_TILE_UPDATE_VARIANCE = 12 -- Create/melt tiles every 4 - 14 seconds
local ICE_TILE_UPDATE_COOLDOWN = TUNING.TOTAL_DAY_TIME / 2
local ICE_TILE_FORCED_UPDATE_COOLDOWN = TUNING.TOTAL_DAY_TIME

local MIN_TEMPERATURE = -31
local MAX_TEMPERATURE = 100

local FLOATEROBJECT_TAGS = {"floaterobject"}
local IGNORE_ICE_TAGS = {"activeprojectile", "oceanshoalspawner", "irreplaceable", "flying", "FX", "DECOR", "INLIMBO", "NOCLICK"}
local ICE_BLOCKER_DIST = 10

return Class(function(self, inst)
    assert(inst.ismastersim, "Polar Ice Manager should not exist on the client!")

	-- [ Public fields ] --
	self.inst = inst
	
	self.IGNORE_ICE_BREAKING_ONREMOVE_TAGS = deepcopy(IGNORE_ICE_TAGS)
	self.IGNORE_ICE_FORMING_ONREMOVE_TAGS = deepcopy(IGNORE_ICE_TAGS)
	self.ICE_FORMING_BLOCKER_TAGS = {"shadecanopy", "shadecanopysmall", "crabking", "boat"}
	
	local breaking_ignore_tags = {"ignorewalkableplatformdrowning"}
	local forming_ignore_tags = {"underwater_salvageable", "walkableplatform"}
	
	for i, v in ipairs(breaking_ignore_tags) do
		table.insert(self.IGNORE_ICE_BREAKING_ONREMOVE_TAGS, v)
	end
	
	for i, v in ipairs(forming_ignore_tags) do
		table.insert(self.IGNORE_ICE_FORMING_ONREMOVE_TAGS, v)
	end
	
	-- [ Private fields ] --
	local initial_load = true -- The first ever ice load should generate ice instantly to decrease lag

	local _map = inst.Map
	local _icebasestrengthgrid -- Stores [0 - 1] values defining the base strength of ice tiles in the world
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient

	local _icecurrentstrengthgrid -- Stores [0 - 1] values defining the current strength of ice tiles

	local _updating_tiles = {  }
	local _recently_updated_tiles = {  }

	local _world_temperature = TUNING.STARTING_TEMP
	local _update_task

	-- [ Functions ] --
	local function SetBaseIceStrength(index, strength)
		if 0 <= index and index < WIDTH*HEIGHT then
			_icebasestrengthgrid:SetDataAtIndex(index, math.clamp(strength, 0, 1))
		end
	end

	local function SetCurrentIceStrength(index, strength)
		if 0 <= index and index < WIDTH*HEIGHT then
			strength = math.clamp(strength, 0, 1)
			_icecurrentstrengthgrid:SetDataAtIndex(index, strength)

			local tx, ty = _icecurrentstrengthgrid:GetXYFromIndex(index)
			local x, y, z = _map:GetTileCenterPoint(tx, ty)
			if strength >= 0.1 and _map:IsOceanTileAtPoint(x, y, z) then
				self:QueueCreateIceAtTile(tx, ty)
			elseif strength <= 0 and _map:GetTile(tx, ty) == WORLD_TILES.POLAR_ICE then
				self:QueueMeltIceAtTile(tx, ty)
			end
		end
	end

	local function InitialLoad() -- Similar to the normal Update fn but skips the ice tile queueing to reduce lag
		local _temperature = math.clamp(_world_temperature, MIN_TEMPERATURE, MAX_TEMPERATURE)
		
		local mult = Lerp(1, 4, (_temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE))
		local add = Lerp(0, -3, (_temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE))

		for i, basestr in pairs(_icebasestrengthgrid.grid) do
			local current_strength = math.clamp(basestr * mult + add, 0, 1)
			_icecurrentstrengthgrid:SetDataAtIndex(i, current_strength)
			
			local x, y = _icecurrentstrengthgrid:GetXYFromIndex(i)
			local tx, ty, tz = _map:GetTileCenterPoint(x, y)
			if current_strength >= 0.1 and _map:IsOceanTileAtPoint(tx, ty, tz) then
				self:CreateIceAtTile(x, y)
			end
		end

		initial_load = false
	end

	local DoUpdate
	local function Reschedule(time)
		if _update_task then
			_update_task:Cancel()
			_update_task = nil
		end

		_update_task = inst:DoTaskInTime(time, function() DoUpdate(true) end)
	end

	DoUpdate = function(reschedule)
		local _temperature = math.clamp(_world_temperature, MIN_TEMPERATURE, MAX_TEMPERATURE)
		
		local mult = Lerp(1, 4, (_temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE))
		local add = Lerp(0, -3, (_temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE))

		for i, basestr in pairs(_icebasestrengthgrid.grid) do
			SetCurrentIceStrength(i, basestr * mult + add)
		end

		if reschedule then
			Reschedule(STRENGTH_UPDATE_TIME)
		end
	end

	local function RemoveCrackedIceFx(x, y, z)
		local cracks = TheSim:FindEntities(x, 0, z, 2, { "ice_crack_fx" })

		for i = #cracks, 1, -1 do
			cracks[i]:Remove()
		end
	end

	local function SpawnCracks(x, y, z)
		local tx, ty = _map:GetTileCoordsAtPoint(x, 0, z)
		local cx, cy, cz = _map:GetTileCenterPoint(tx, ty)
		local fx = SpawnPrefab("fx_ice_crackle")
		fx.Transform:SetPosition(cx, cy, cz)
		
		fx:AddTag("scarytoprey")
		fx:AddTag("icecrackfx")
		
		local function SpawnFx(lx, lz, rot)
			local fx = SpawnPrefab("ice_crack_grid_fx")
			fx.Transform:SetPosition(lx, 0, lz)
			fx.Transform:SetRotation(rot)
			fx.AnimState:SetScale(1.2, 1.2, 1.2)
		end

		SpawnFx(cx, cz, -40 + math.random() * 80)
		SpawnFx(cx, cz, 50 + math.random() * 80)
	end

	local function TossDebris(debris_prefab, dx, dz)
		local ice_debris = SpawnPrefab(debris_prefab)
		ice_debris.Physics:Teleport(dx, 0.1, dz)

		local debris_angle = TWOPI*math.random()
		local debris_speed = 2.5 + 2*math.random()
		ice_debris.Physics:SetVel(debris_speed * math.cos(debris_angle), 10, debris_speed * math.sin(debris_angle))
	end

	local function SpawnDegradePiece(center_x, center_z, spawn_angle)
		spawn_angle = spawn_angle or TWOPI*math.random()

		local ice_degrade_fx = SpawnPrefab("degrade_fx_ice")
		local spawn_offset = TUNING.OCEAN_ICE_RADIUS * (0.4 + 0.65 * math.sqrt(math.random()))

		center_x = center_x + (spawn_offset * math.cos(spawn_angle))
		center_z = center_z + (spawn_offset * math.sin(spawn_angle))
		ice_degrade_fx.Transform:SetPosition(center_x, 0, center_z)
	end

	local INITIAL_LAUNCH_HEIGHT = 0.1
	local SPEED = 6
	local function LaunchAway(item, position)
		local ix, iy, iz = item.Transform:GetWorldPosition()
		item.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)
	
		local cosa, sina = 0, 0
		if position then
			local px, py, pz = position:Get()
			local angle = (180 - item:GetAngleToPoint(px, py, pz)) * DEGREES
			sina, cosa = math.sin(angle), math.cos(angle)
		end

		item.Physics:SetVel(SPEED * cosa, 2 + SPEED, SPEED * sina)
	end

	local function GenerateIceGradient(depth)
		assert(depth > 0, "Ice gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _icebasestrengthgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local nx, ny = ox + x, oy + y
					local strength = self:GetBaseAtTile(nx, ny)
					if strength == 0 then
						SetBaseIceStrength(_icebasestrengthgrid:GetIndex(nx, ny), depth / (MAX_GRADIENT_DEPTH + 1)) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, _icebasestrengthgrid:GetIndex(nx, ny))
					end
				end
			end
		end

		_gradient_indeces = new_gradient_indeces

		depth = depth - 1
		if depth > 0 and next(_gradient_indeces) ~= nil then
			GenerateIceGradient(depth)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids(_, grid)
		if _icebasestrengthgrid or _icecurrentstrengthgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_icebasestrengthgrid = DataGrid(WIDTH, HEIGHT)
		_icecurrentstrengthgrid = DataGrid(WIDTH, HEIGHT)

		for i, ispolar in pairs(grid) do
			local tx, ty, tz = _map:GetTileCenterPoint(_icebasestrengthgrid:GetXYFromIndex(i))
			if ispolar and not (_map:IsOceanTileAtPoint(tx, ty, tz) or _map:GetTileAtPoint(tx, ty, tz) == WORLD_TILES.POLAR_ICE) then
				table.insert(_gradient_indeces, i)
				SetBaseIceStrength(i, 1) -- Solid winterlands ground tiles have max ice strength that is then expanded from using a gradient
			end
		end

		if MAX_GRADIENT_DEPTH > 0 then -- Can be 0 with None in the configurations
			GenerateIceGradient(MAX_GRADIENT_DEPTH)

			if initial_load then
				InitialLoad()
				InitialLoad = nil
			end

			self:StartUpdatingIceTiles()
		end

		inst:RemoveEventCallback("winterlands_initialized", InitializeDataGrids)
	end

	inst:ListenForEvent("winterlands_initialized", InitializeDataGrids)
	inst:ListenForEvent("temperaturetick", function(inst, val) _world_temperature = val end)

    -- [ Methods ] --
	
	function self:QueueCreateIceAtTile(tx, ty)
		local index = _icebasestrengthgrid:GetIndex(tx, ty)
		
		if _recently_updated_tiles[index] ~= nil then
			return
		end

		if _updating_tiles[index] == nil then
			local create_time = ICE_TILE_UPDATE_TIME + math.random() * ICE_TILE_UPDATE_VARIANCE
			_updating_tiles[index] = inst:DoTaskInTime(create_time, function()
				self:CreateIceAtTile(tx, ty)
				_updating_tiles[index] = nil
			end)
		end
	end

	function self:CreateTemporaryIceAtTile(tx, ty, time)
		if not self:CanCreateIce(tx, ty) then
			return
		end
		
		local index = _icecurrentstrengthgrid:GetIndex(tx, ty)
		local tile = _map:GetTile(tx, ty)
		if tile == WORLD_TILES.POLAR_ICE then
			if _updating_tiles[index] == true then
				_updating_tiles[index] = nil
			end
			
			if _recently_updated_tiles[index] == true then
				_recently_updated_tiles[index] = nil
			end
			
			if _updating_tiles[index] and GetTaskRemaining(_updating_tiles[index]) < time then
				local task_fn = _updating_tiles[index].fn
				_updating_tiles[index]:Cancel()

				_updating_tiles[index] = inst:DoTaskInTime(time, task_fn)
			end

			if _recently_updated_tiles[index] and GetTaskRemaining(_recently_updated_tiles[index]) < time then
				local task_fn = _recently_updated_tiles[index].fn
				_recently_updated_tiles[index]:Cancel()

				_recently_updated_tiles[index] = inst:DoTaskInTime(time, task_fn)
			end
		else
			if _updating_tiles[index] == true then
				_updating_tiles[index] = nil
			end
			
			if _recently_updated_tiles[index] == true then
				_recently_updated_tiles[index] = nil
			end
			
			if _updating_tiles[index] then
				_updating_tiles[index]:Cancel()
				_updating_tiles[index] = nil
			end

			if _recently_updated_tiles[index] then
				_recently_updated_tiles[index]:Cancel()
				_recently_updated_tiles[index] = nil
			end

			self:CreateIceAtTile(tx, ty)

			_recently_updated_tiles[index] = inst:DoTaskInTime(time, function()
				self:DestroyIceAtTile(tx, ty, true)
				_recently_updated_tiles[index] = nil
			end)
		end
	end
	
	function self:CanCreateIce(tx, ty)
		local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(tx, ty)
		
		if next(TheSim:FindEntities(cx, cy, cz, ICE_BLOCKER_DIST, nil, nil, self.ICE_FORMING_BLOCKER_TAGS)) == nil then
			local tile = TheWorld.Map:GetTile(tx, ty)
			
			if TileGroupManager:IsOceanTile(tile) or tile == WORLD_TILES.POLAR_ICE then
				return true
			end
		end
		
		return false
	end
	
	function self:CreateIceAtPoint(x, y, z)
		local tx, ty = _map:GetTileCoordsAtPoint(x, y, z)
		self:CreateIceAtTile(tx, ty)
	end
	
	function self:CreateIceAtTile(tx, ty)
		if not self:CanCreateIce(tx, ty) then
			return
		end
		
		local current_tile = nil
		local undertile = inst.components.undertile
		if undertile then
			current_tile = _map:GetTile(tx, ty)
		end
		
		_map:SetTile(tx, ty, WORLD_TILES.POLAR_ICE)
		
		if undertile and current_tile then
			undertile:SetTileUnderneath(tx, ty, current_tile)
		end

		local x, y, z = _map:GetTileCenterPoint(tx, ty)

		local terraformer = SpawnPrefab("polarice_terraformer")
		terraformer.Transform:SetPosition(x, 0, z)
		
		local tile_radius_plus_overhang = ((TILE_SCALE / 2) + 1) * 1.4142
		local entities_near_ice = TheSim:FindEntities(x, 0, z, tile_radius_plus_overhang, nil, self.IGNORE_ICE_FORMING_ONREMOVE_TAGS)
		for _, ent in ipairs(entities_near_ice) do
			if ent.components.inventoryitem and ent.Physics then
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
					rod.components.oceanfishingrod:StopFishing(ent:HasTag("fishinghook") and "badcast" or "linesnapped", false) -- A bit unfair atm so we keep the things
				end
			elseif not ent:HasTag("locomotor") and ent:HasTag("ignorewalkableplatforms") then -- Ocean stuff
				print("Polar Ice (Forming) removed ent:", ent)
				DestroyEntity(ent, inst, true, true)
			end
		end
		
		local floaterobjects = TheSim:FindEntities(x, 0, z, tile_radius_plus_overhang, FLOATEROBJECT_TAGS)
		for _, floaterobject in ipairs(floaterobjects) do
			if floaterobject.components.floater then
				local fx, fy, fz = floaterobject.Transform:GetWorldPosition()
				if _map:IsOceanTileAtPoint(fx, fy, fz) then
					floaterobject:PushEvent("on_landed")
				else
					floaterobject:PushEvent("on_no_longer_landed")
				end
			end
		end

		local index = _icebasestrengthgrid:GetIndex(tx, ty)
		_recently_updated_tiles[index] = inst:DoTaskInTime(ICE_TILE_UPDATE_COOLDOWN, function()
			_recently_updated_tiles[index] = nil
		end)
	end

	function self:QueueMeltIceAtTile(tx, ty)
		local tile = _map:GetTile(tx, ty)
		local x, y, z = _map:GetTileCenterPoint(tx, ty)
		if tile ~= WORLD_TILES.POLAR_ICE or next(TheSim:FindEntities(x, y, z, 5, { "icecaveshelter" })) ~= nil then
			return
		end
		
		local index = _icebasestrengthgrid:GetIndex(tx, ty)
		if _recently_updated_tiles[index] ~= nil then
			return
		end

		if _updating_tiles[index] == nil then
			_updating_tiles[index] = inst:DoTaskInTime(ICE_TILE_UPDATE_TIME + math.random() * ICE_TILE_UPDATE_VARIANCE, function()
				self:StartDestroyingIceAtTile(tx, ty, true)
			end)
		end
	end

	function self:StartDestroyingIceAtTile(tx, ty, melting, delay_override, no_ice)
		local tile = _map:GetTile(tx, ty)
		local x, y, z = _map:GetTileCenterPoint(tx, ty)
		if tile ~= WORLD_TILES.POLAR_ICE or next(TheSim:FindEntities(x, y, z, 5, { "icecaveshelter" })) ~= nil then
			return
		end
		
		local index = _icebasestrengthgrid:GetIndex(tx, ty)
		if _updating_tiles[index] == nil then
			_updating_tiles[index] = true -- Ensure we have stored the updating tile when calling this method directly from the outside
		end

		SpawnCracks(_map:GetTileCenterPoint(tx, ty))

		inst:DoTaskInTime(delay_override or 3.5, function()
			self:DestroyIceAtTile(tx, ty, melting, no_ice)
			RemoveCrackedIceFx(_map:GetTileCenterPoint(tx, ty))
			_updating_tiles[index] = nil
		end)
	end

	function self:DestroyIceAtTile(tx, ty, melted, no_ice)
		local tile = _map:GetTile(tx, ty)
		if tile ~= WORLD_TILES.POLAR_ICE then
			return
		end
		
		local default_tile = TheWorld.worldprefab == "shipwrecked" and WORLD_TILES.OCEAN_DEEP or WORLD_TILES.OCEAN_POLAR
		
		local old_tile = default_tile
		local undertile = inst.components.undertile
		local dx, dy, dz = _map:GetTileCenterPoint(tx, ty)
		
		if undertile then
			old_tile = undertile:GetTileUnderneath(tx, ty)
			
			if old_tile then
				undertile:ClearTileUnderneath(tx, ty)
				
				if GetClosestPolarTileToPoint(dx, dy, dz, TUNING.OCEAN_POLAR_CONVERT_RANGE) ~= nil and (old_tile == WORLD_TILES.OCEAN_COASTAL_SHORE
					or old_tile == WORLD_TILES.OCEAN_COASTAL) then
					
					old_tile = default_tile
				end
			else
				old_tile = default_tile
			end
		end

		-- THIS IS HACKED IN TO SAVE THE PLAYER FOR NOW!
		local hypotenuseSq = 8 + 1 -- buffer.
		local players = FindPlayersInRangeSq(dx, 0, dz, hypotenuseSq, true)
		if players and #players > 0 then
			for i, player in ipairs(players)do
				local px, py, pz = player.Transform:GetWorldPosition()
				local ptile_x, ptile_y = _map:GetTileCoordsAtPoint(px, py, pz)
				local ptile = _map:GetTile(ptile_x, ptile_y)
				if ptile == tile then
					player.Physics:Teleport(dx, dy, dz)
				end
			end
		end

		_map:SetTile(tx, ty, old_tile)

		local tile_radius_plus_overhang = ((TILE_SCALE / 2) + 1.0) * 1.4142
		local is_ocean_tile = IsOceanTile(old_tile)
		if is_ocean_tile then
			-- Behaviour pulled from walkableplatform's onremove/DestroyObjectsOnPlatform response.
			local entities_near_ice = TheSim:FindEntities(dx, dy, dz, tile_radius_plus_overhang, nil, self.IGNORE_ICE_BREAKING_ONREMOVE_TAGS)
			for _, ent in ipairs(entities_near_ice) do
				if ent:IsValid() then
					local has_drownable = ent.components.drownable ~= nil
					-- We're testing the overhang, so we need to verify that anything we find isn't
					-- still on some adjacent dock or land tile or other platform after we remove ourself.
					
					local ignore_drown = ent.entity:GetParent() or ent.components.amphibiouscreature
						or _map:IsVisualGroundAtPoint(ent.Transform:GetWorldPosition()) or ent:GetCurrentPlatform()
					
					if not has_drownable and not ignore_drown then
						if ent.OnPolarFreeze then
							ent:OnPolarFreeze(false)
						elseif ent.components.submersible then
							ent.components.submersible:Submerge()
						elseif ent.components.inventoryitem then
							ent.components.inventoryitem:SetLanded(false, true)
						elseif not ent:HasTag("ignorewalkableplatforms") then -- Not ocean stuff
							print("Polar Ice (Breaking) removed ent:", ent)
							DestroyEntity(ent, inst, true, true)
						end
					elseif has_drownable and not ignore_drown then
						local shore_point = has_drownable and Vector3(FindRandomPointOnShoreFromOcean(dx, dy, dz)) or nil
						ent:PushEvent("onsink", {boat = nil, shore_pt = shore_point})
					end
				end
			end
		end

		local floaterobjects = TheSim:FindEntities(dx, 0, dz, tile_radius_plus_overhang, FLOATEROBJECT_TAGS)
		for _, floaterobject in ipairs(floaterobjects) do
			if floaterobject.components.floater then
				local fx, fy, fz = floaterobject.Transform:GetWorldPosition()
				if is_ocean_tile or _map:IsOceanTileAtPoint(fx, fy, fz) then
					floaterobject:PushEvent("on_landed")
				else
					floaterobject:PushEvent("on_no_longer_landed")
				end
			end
		end

		if not melted then -- Melting doesn't drop loot nor generate debris
			if not no_ice then
				TossDebris("ice", dx, dz)

				if math.random() > 0.1 then
					TossDebris("ice", dx, dz)
				end
			end
			
			if TheWorld.components.oceanfish_in_ice_spawner and TheWorld.components.oceanfish_in_ice_spawner:CanSpawnIceCube(dx, 0, dz) then
				TheWorld.components.oceanfish_in_ice_spawner:SpawnIceCubeAt(dx, 0, dz)
			end
			
			local half_num_debris = math.random(4)
			local angle_per_debris = TWOPI / half_num_debris
			for i = 1, half_num_debris do
				SpawnDegradePiece(dx, dz, (i + GetRandomWithVariance(0.50, 0.25)) * angle_per_debris)
				SpawnDegradePiece(dx, dz, (i + GetRandomWithVariance(0.50, 0.25)) * angle_per_debris)
			end

			local index = _icebasestrengthgrid:GetIndex(tx, ty)
			_recently_updated_tiles[index] = inst:DoTaskInTime(ICE_TILE_FORCED_UPDATE_COOLDOWN, function()
				_recently_updated_tiles[index] = nil
			end)
		else -- Melted ice refreezes faster
			local index = _icebasestrengthgrid:GetIndex(tx, ty)
			_recently_updated_tiles[index] = inst:DoTaskInTime(ICE_TILE_UPDATE_COOLDOWN, function()
				_recently_updated_tiles[index] = nil
			end)
		end

		SpawnPrefab("fx_ice_pop").Transform:SetPosition(dx, 0, dz)
	end

	function self:GetTemporaryIceTime(tx, ty, tz)
		if tz then
			tx, ty = _map:GetTileCoordsAtPoint(tx, ty, tz)
		end
		
		local index = _icecurrentstrengthgrid:GetIndex(tx, ty)
		local tile = _map:GetTile(tx, ty)
		
		if tile == WORLD_TILES.POLAR_ICE then
			if _recently_updated_tiles[index] then
				return GetTaskRemaining(_recently_updated_tiles[index])
			end
		end
		
		return false
	end

	function self:GetBaseAtPoint(x, y, z)
		return _icebasestrengthgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:GetBaseAtTile(tx, ty)
		return _icebasestrengthgrid:GetDataAtPoint(tx, ty) or 0
	end

	function self:GetCurrentAtPoint(x, y, z)
		return _icecurrentstrengthgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:GetCurrentAtTile(tx, ty)
		return _icecurrentstrengthgrid:GetDataAtPoint(tx, ty) or 0
	end

	function self:StartUpdatingIceTiles()
		if _update_task then
			return
		end

		DoUpdate(true)
	end	

	function self:StopUpdatingIceTiles()
		if _update_task then
			_update_task:Cancel()
			_update_task = nil
		end
	end

	function self:OnSave()
		return {
			initial_load = initial_load
		}
	end

	function self:OnLoad(data)
		if data and data.initial_load ~= nil then
			initial_load = data.initial_load
		end
	end
end)