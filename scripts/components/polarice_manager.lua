local WIDTH, HEIGHT
local MAX_GRADIENT_DEPTH = 4

local STRENGTH_UPDATE_TIME = 8

local ICE_TILE_UPDATE_TIME = 4
local ICE_TILE_UPDATE_VARIANCE = 10 -- Create/destroy tiles every 4 - 14 seconds
local ICE_TILE_UPDATE_COOLDOWN = 120

local MIN_TEMPERATURE = -25
local MAX_TEMPERATURE = 95

return Class(function(self, inst)
    assert(inst.ismastersim, "Polar Ice Manager should not exist on the client!")

	-- [ Public fields ] --
	self.inst = inst

	-- [ Private fields ] --
	local _map = inst.Map
	local _icebasestrengthgrid -- Stores [0 - 1] values defining the base strength of ice tiles in the world
	local _gradient_indeces = {  } -- Indeces for the next iteration of the gradient
	local _world_temperature = TUNING.STARTING_TEMP

	local _icecurrentstrengthgrid -- Stores [0 - 1] values defining the current strength of ice tiles

	local _createicetasks = {  }
	local _destroyicetasks = {  }
	local _recently_updated_tiles = {  }

	local _update_task

	local wasloaded = false

	-- [ Functions ] --
	local function RemoveCrackedIceFx(x, y, z)
		local cracks = TheSim:FindEntities(x, 0, z, 2, { "ice_crack_fx" })

		for i = #cracks, 1, -1 do
			cracks[i]:Remove()
		end
	end

	local function SpawnCracks(x, y, z)
		local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, 0, z)
		local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(tx, ty)
		local fx = SpawnPrefab("fx_ice_crackle")
		fx.Transform:SetPosition(cx, cy, cz)

		local function spawnfx(lx, lz, rot)
			local fx = SpawnPrefab("ice_crack_grid_fx")
			fx.Transform:SetPosition(lx, 0, lz)
			fx.Transform:SetRotation(rot)
			fx.AnimState:SetScale(1.2, 1.2, 1.2)
		end

		spawnfx(cx, cz, -40 + math.random() * 80)
		spawnfx(cx, cz, 50 + math.random() * 80)
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

	local function QueueCreateIceAtTile(tx, ty)
		local index = _icebasestrengthgrid:GetIndex(tx, ty)
		
		if _recently_updated_tiles[index] ~= nil then
			return
		end

		if _createicetasks[index] == nil and _destroyicetasks[index] == nil then
			_createicetasks[index] = inst:DoTaskInTime(ICE_TILE_UPDATE_TIME + math.random() * ICE_TILE_UPDATE_VARIANCE, function()
				self:CreateIceAtTile(tx, ty)
				_createicetasks[index] = nil
			end)
		end
	end

	local function QueueDestroyIceAtTile(tx, ty)
		local index = _icebasestrengthgrid:GetIndex(tx, ty)

		if _recently_updated_tiles[index] ~= nil then
			return
		end

		if _destroyicetasks[index] == nil and _createicetasks[index] == nil then
			_destroyicetasks[index] = inst:DoTaskInTime(ICE_TILE_UPDATE_TIME + math.random() * ICE_TILE_UPDATE_VARIANCE, function()
				SpawnCracks(_map:GetTileCenterPoint(tx, ty))

				inst:DoTaskInTime(3.5, function()
					self:DestroyIceAtTile(tx, ty)
					RemoveCrackedIceFx(_map:GetTileCenterPoint(tx, ty))
					_destroyicetasks[index] = nil
				end)
			end)
		end
	end

	local function SetBaseIceStrength(index, strength)
		if 0 <= index and index < WIDTH*HEIGHT then
			_icebasestrengthgrid:SetDataAtIndex(index, math.clamp(strength, 0, 1))
		end
	end

	local function SetIceCurrentStrength(index, strength)
		if 0 <= index and index < WIDTH*HEIGHT then
			_icecurrentstrengthgrid:SetDataAtIndex(index, math.clamp(strength, 0, 1))

			local tx, ty = _icecurrentstrengthgrid:GetXYFromIndex(index)
			local x, y, z = _map:GetTileCenterPoint(tx, ty)
			if strength >= 0.1 and _map:IsOceanTileAtPoint(x, y, z) then
				QueueCreateIceAtTile(tx, ty)
			elseif strength < 0.1 and _map:GetTile(tx, ty) == WORLD_TILES.POLAR_ICE then
				QueueDestroyIceAtTile(tx, ty)
			end
		end
	end

	local function GenerateIceGradient(depth)
		assert(depth > 0, "Ice gradient depth must be positive!")

		local new_gradient_indeces = {  }
		for _, i in ipairs(_gradient_indeces) do
			local ox, oy = _icebasestrengthgrid:GetXYFromIndex(i)

			for x = -1, 1 do
				for y = -1, 1 do
					local level = _icebasestrengthgrid:GetDataAtPoint(ox + x, oy + y) or 0
					if level == 0 then
						local new_i = _icebasestrengthgrid:GetIndex(ox + x, oy + y)
						SetBaseIceStrength(new_i, depth / (MAX_GRADIENT_DEPTH + 1)) -- Linear falloff based on how far from the main island tile we are
						table.insert(new_gradient_indeces, new_i)
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

	local DoUpdate
	local function Reschedule(time)
		if _update_task then
			_update_task:Cancel()
			_update_task = nil
		end

		_update_task = inst:DoTaskInTime(time, function() DoUpdate(true) end)
	end

	DoUpdate = function(reschedule)
		local mult = Lerp(1, 4, (_world_temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE))
		local add = Lerp(0, -3, (_world_temperature - MIN_TEMPERATURE) / (MAX_TEMPERATURE - MIN_TEMPERATURE))

		for x = 0, WIDTH - 1 do
			for y = 0, HEIGHT - 1 do
				local index = _icebasestrengthgrid:GetIndex(x, y)
				local base = _icebasestrengthgrid:GetDataAtIndex(index) or 0
				self:SetAtTile(x, y, math.sqrt(base) * mult + add) -- a*sqrt(x) + b {0 <= x <= 1}
			end
		end

		if reschedule then
			Reschedule(STRENGTH_UPDATE_TIME)
		end
	end

	-- [ Initialization ] --
	local function InitializeDataGrids()
		if _icebasestrengthgrid then return end

		WIDTH, HEIGHT = _map:GetSize()
		_icebasestrengthgrid = DataGrid(WIDTH, HEIGHT) -- This grid contains the snowstorm information
		_icecurrentstrengthgrid = DataGrid(WIDTH, HEIGHT) -- This grid contains the snowstorm information

		inst:RemoveEventCallback("worldmapsetsize", InitializeDataGrids)
		self:StartUpdatingIceTiles()
	end

	inst:ListenForEvent("worldmapsetsize", InitializeDataGrids)
	inst:ListenForEvent("temperaturetick", function(inst, temp) _world_temperature = temp end)

    -- [ Methods ] --
	local IGNORE_ICE_DROWNING_ONREMOVE_TAGS = {"ignorewalkableplatformdrowning", "activeprojectile", "flying", "FX", "DECOR", "INLIMBO" }
	local FLOATEROBJECT_TAGS = { "floaterobject" }
	function self:DestroyIceAtPoint(x, y, z)
		local tx, ty = _map:GetTileCoordsAtPoint(x, y, z)
		self:DestroyIceAtTile(tx, ty)
	end

	function self:DestroyIceAtTile(tx, ty, spawnloot)
		local tile = _map:GetTile(tx, ty)
		if tile ~= WORLD_TILES.POLAR_ICE then
			return
		end

		local old_tile = WORLD_TILES.OCEAN_SWELL
		local undertile = inst.components.undertile

		if undertile then
			old_tile = undertile:GetTileUnderneath(tx, ty)
			if old_tile then
				undertile:ClearTileUnderneath(tx, ty)
			else
				old_tile = WORLD_TILES.OCEAN_SWELL
			end
		end

		local dx, dy, dz = _map:GetTileCenterPoint(tx, ty)
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
			local entities_near_ice = TheSim:FindEntities(dx, dy, dz, tile_radius_plus_overhang, nil, IGNORE_ICE_DROWNING_ONREMOVE_TAGS)
			for _, ent in ipairs(entities_near_ice) do
				if ent:IsValid() then
					local has_drownable = (ent.components.drownable ~= nil)
					local shore_point = (has_drownable and Vector3(FindRandomPointOnShoreFromOcean(dx, dy, dz))) or nil
					ent:PushEvent("onsink", { boat = nil, shore_pt = shore_point })

					-- We're testing the overhang, so we need to verify that anything we find isn't
					-- still on some adjacent dock or land tile or other platform after we remove ourself.
					if ent:IsValid() and not has_drownable and not ent.entity:GetParent()
						and not ent.components.amphibiouscreature
						and not _map:IsVisualGroundAtPoint(ent.Transform:GetWorldPosition()) and not ent:GetCurrentPlatform() then

						if ent.components.inventoryitem then
							ent.components.inventoryitem:SetLanded(false, true)
						else
							DestroyEntity(ent, inst, true, true)
						end
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

		if spawnloot then -- Aka wasn't melted away but rammed into
			TossDebris("ice", dx, dz)

			if math.random() > 0.40 then
				TossDebris("ice", dx, dz)
			end

			local half_num_debris = 4
			local angle_per_debris = TWOPI / half_num_debris
			for i = 1, half_num_debris do
				SpawnDegradePiece(dx, dz, (i + GetRandomWithVariance(0.50, 0.25)) * angle_per_debris)
				SpawnDegradePiece(dx, dz, (i + GetRandomWithVariance(0.50, 0.25)) * angle_per_debris)
			end
		end

		SpawnPrefab("fx_ice_pop").Transform:SetPosition(dx, 0, dz)

		local index = _icebasestrengthgrid:GetIndex(tx, ty)
		_recently_updated_tiles[index] = inst:DoTaskInTime(ICE_TILE_UPDATE_COOLDOWN, function()
			_recently_updated_tiles[index] = nil
		end)
	end

	function self:CreateIceAtPoint(x, y, z)
		local tx, ty = _map:GetTileCoordsAtPoint(x, y, z)
		self:CreateIceAtTile(tx, ty)
	end

	function self:CreateIceAtTile(tx, ty)
		local current_tile = nil
		local undertile = inst.components.undertile
		if undertile then
			current_tile = _map:GetTile(tx, ty)
		end
		
		_map:SetTile(tx, ty, WORLD_TILES.POLAR_ICE)
		
		-- V2C: Because of a terraforming callback in farming_manager.lua, the undertile gets cleared during SetTile.
		--      We can circumvent this for now by setting the undertile after SetTile.
		if undertile and current_tile then
			undertile:SetTileUnderneath(tx, ty, current_tile)
		end

		local x, y, z = _map:GetTileCenterPoint(tx, ty)

		local terraformer = SpawnPrefab("polarice_terraformer")
		terraformer.Transform:SetPosition(x, 0, z)
		
		local center_position = Vector3(x, 0, z)
		local tile_radius_plus_overhang = ((TILE_SCALE / 2) + 1) * 1.4142
		local entities_near_ice = TheSim:FindEntities(x, 0, z, tile_radius_plus_overhang, nil, IGNORE_ICE_DROWNING_ONREMOVE_TAGS)
		for _, ent in ipairs(entities_near_ice) do
			if ent.components.oceanfishable then
				local projectile = ent.components.oceanfishable:MakeProjectile()
				local projectile_complexprojectile = projectile.components.complexprojectile
				if projectile_complexprojectile then
					projectile_complexprojectile:SetHorizontalSpeed(16)
					projectile_complexprojectile:SetGravity(-30)
					projectile_complexprojectile:SetLaunchOffset(Vector3(0, 0.5, 0))
					projectile_complexprojectile:SetTargetOffset(Vector3(0, 0.5, 0))

					local v_position = ent:GetPosition()
					local launch_position = v_position + (v_position - center_position):Normalize() * SPEED
					projectile_complexprojectile:Launch(launch_position, projectile, projectile_complexprojectile.owningweapon)
				else
					LaunchAway(projectile, center_position)
				end
			elseif ent.prefab == "bullkelp_plant" then
				local entx, enty, entz = ent.Transform:GetWorldPosition()

				if ent.components.pickable and ent.components.pickable:CanBePicked() then
					local product = ent.components.pickable.product
					local loot = SpawnPrefab(product)
					if loot then
						loot.Transform:SetPosition(entx, enty, entz)
						if loot.components.inventoryitem then
							loot.components.inventoryitem:InheritWorldWetnessAtTarget(ent)
						end

						if loot.components.stackable and ent.components.pickable.numtoharvest > 1 then
							loot.components.stackable:SetStackSize(ent.components.pickable.numtoharvest)
						end

						LaunchAway(loot, center_position)
					end
				end

				local uprooted_kelp_plant = SpawnPrefab("bullkelp_root")
				if uprooted_kelp_plant then
					uprooted_kelp_plant.Transform:SetPosition(entx, enty, entz)
					LaunchAway(uprooted_kelp_plant, center_position + Vector3(0.5 * math.random(), 0, 0.5 * math.random()))
				end

				ent:Remove()
			elseif ent.components.workable and ent:GetCurrentPlatform() == nil and not TheWorld.Map:IsVisualGroundAtPoint(ent.Transform:GetWorldPosition()) then
				ent.components.workable:Destroy(terraformer)
			elseif ent.components.inventoryitem and ent.Physics then
				LaunchAway(ent)
				ent.components.inventoryitem:SetLanded(false, true)
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

	function self:GetBaseAtPoint(x, y, z)
		return _icebasestrengthgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:GetAtPoint(x, y, z)
		return _icecurrentstrengthgrid:GetDataAtPoint(_map:GetTileCoordsAtPoint(x, y, z)) or 0
	end

	function self:SetAtPoint(x, y, z, val)
		val = math.clamp(val, 0, 1)
		local i = _icecurrentstrengthgrid:GetIndex(_map:GetTileCoordsAtPoint(x, y, z))
		SetIceCurrentStrength(i, val)
	end

	function self:SetAtTile(x, y, val)
		val = math.clamp(val, 0, 1)
		local i = _icecurrentstrengthgrid:GetIndex(x, y)
		SetIceCurrentStrength(i, val)
	end

	function self:StartUpdatingIceTiles()
		self:StopUpdatingIceTiles()

		_update_task = inst:DoTaskInTime(STRENGTH_UPDATE_TIME, function() DoUpdate(true) end)
	end	
		
	function self:StopUpdatingIceTiles()
		if _update_task then
			_update_task:Cancel()
			_update_task = nil
		end
	end

	-- [ Saving/Loading ] --
	function self:OnSave()
		return {
			basegrid = ZipAndEncodeSaveData(_icebasestrengthgrid:Save()),
			currentgrid = ZipAndEncodeSaveData(_icecurrentstrengthgrid:Save()),
		}
	end

	function self:OnLoad(data)
		if data then
			_icebasestrengthgrid:Load(DecodeAndUnzipSaveData(data.basegrid))
			_icecurrentstrengthgrid:Load(DecodeAndUnzipSaveData(data.currentgrid))
			wasloaded = true
        elseif not wasloaded then -- If no saved data is being loaded, generate the default grid
			for x = 0, WIDTH - 1 do
				for y = 0, HEIGHT - 1 do
					local index = _icebasestrengthgrid:GetIndex(x, y)
					local tx, ty, tz = _map:GetTileCenterPoint(x, y)
	
					if IsInPolarAtPoint(tx, ty, tz, 0) and not _map:IsOceanTileAtPoint(tx, ty, tz) then
                        SetBaseIceStrength(index, 1) -- Solid winterlands ground tiles have max ice strength that is then expanded from using a gradient
						table.insert(_gradient_indeces, index)
					end
				end
			end

			GenerateIceGradient(MAX_GRADIENT_DEPTH)

			DoUpdate(false)
		end
	end
end)
