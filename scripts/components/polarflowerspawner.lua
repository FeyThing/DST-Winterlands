local FLOWER_SPAWNPOINT_IGNORE_TAGS_LESS = {"NOBLOCK", "FX", "INLIMBO", "DECOR", "locomotor"}
local FLOWER_SPAWNPOINT_IGNORE_TAGS = JoinArrays({"flower", "_inventoryitem"}, FLOWER_SPAWNPOINT_IGNORE_TAGS_LESS)

local FLOWER_TWEEN_IN_TARGET = {1, 1, 1, 1}
local FLOWER_TWEEN_OUT_TARGET = {1, 1, 1, 0}

return Class(function(self, inst)
	assert(inst.ismastersim, "Polar Flower Spawner should not exist on the client!")

	self.inst = inst
	self.flower_prefab = "flower_polar"
	
	local _map = inst.Map
	local WIDTH, HEIGHT
	
	local _scheduled_spawn = {}
	local _flowergrid
	
	local function GetTimerName(index)
		return "spawnpolarflower_"..tostring(index)
	end
	
	local function IsValidFlowerTile(tx, ty)
		return _map:GetTile(tx, ty) == WORLD_TILES.POLAR_GRASS
	end
	
	local function GetFlowerOnTile(tx, ty)
		local x, y, z = _map:GetTileCenterPoint(tx, ty)
		
		for i, v in ipairs(_map:GetEntitiesOnTileAtPoint(x, 0, z)) do
			if v.prefab == self.flower_prefab then
				return v
			end
		end
	end
	
	local function FindSpawnPoint(tx, ty)
		local x, y, z = _map:GetTileCenterPoint(tx, ty)
		local theta = math.random() * TWOPI
		
		local offset = FindValidPositionByFan(theta, math.random(TILE_SCALE / 2.05), 12, function(offset)
			local pt = Vector3(x + offset.x, 0, z + offset.z)
			
			return _map:IsDeployPointClear(pt, nil, DEPLOYSPACING_RADIUS[DEPLOYSPACING.MEDIUM], nil, nil, nil, FLOWER_SPAWNPOINT_IGNORE_TAGS)
				and _map:IsDeployPointClear(pt, nil, DEPLOYSPACING_RADIUS[DEPLOYSPACING.LESS] / 2, nil, nil, nil, FLOWER_SPAWNPOINT_IGNORE_TAGS_LESS)
				and _map:GetTileAtPoint(pt:Get()) == WORLD_TILES.POLAR_GRASS
		end)
		
		if offset then
			return Vector3(x + offset.x, 0, z + offset.z)
		end
	end
	
	local function CancelGrowth(index)
		if not _scheduled_spawn[index] then
			return
		end
		
		local timername = GetTimerName(index)
		
		if inst.components.timer and inst.components.timer:TimerExists(timername) then
			inst.components.timer:StopTimer(timername)
		end
		
		_scheduled_spawn[index] = nil
	end

	local function RemoveFlower(tx, ty)
		local flower = GetFlowerOnTile(tx, ty)
		
		if flower then
			flower.persits = false
			
			if flower:IsAsleep() or flower.components.colourtweener == nil then
				flower:Remove()
			else
				flower.components.colourtweener:StartTween(FLOWER_TWEEN_OUT_TARGET, 0.3 + math.random() * 0.3, inst.Remove)
			end
		end
	end

	local function SpawnFlower(tx, ty, from_worldgen)
		local index = _flowergrid:GetIndex(tx, ty)
		
		_scheduled_spawn[index] = nil
		if not IsValidFlowerTile(tx, ty) then
			return
		end
		
		if GetFlowerOnTile(tx, ty) then
			return
		end
		
		local pt = FindSpawnPoint(tx, ty)
		if pt == nil then
			return
		end
		
		local flower = SpawnPrefab(self.flower_prefab)
		if flower then
			flower.Transform:SetPosition(pt:Get())
			
			if not flower:IsAsleep() and flower.components.colourtweener then
				flower.AnimState:SetMultColour(1, 1, 1, 0)
				flower.components.colourtweener:StartTween(FLOWER_TWEEN_IN_TARGET, 0.3 + math.random() * 0.3)
			end
			
			if from_worldgen then
				inst.num_polarflowers = (inst.num_polarflowers or 0) + 1
			end
		end
	end
	
	local function ScheduleFlower(tx, ty, overtime)
		local index = _flowergrid:GetIndex(tx, ty)
		
		if _scheduled_spawn[index] then
			return
		end
		
		if not IsValidFlowerTile(tx, ty) then
			return
		end

		if GetFlowerOnTile(tx, ty) then
			return
		end
		
		-- Tile melted naturally, "reveal" crocus instead of growing
		if not overtime and inst.components.polarsnow_manager and inst.components.polarsnow_manager:IsOriginalSnowTile(tx, ty) then
			SpawnFlower(tx, ty, not overtime)
			return
		end
		
		local timername = GetTimerName(index)
		_scheduled_spawn[index] = true
		
		if inst.components.timer then
			local grow_time = TUNING.FLOWER_POLAR_GROW_TILE.base + math.random(TUNING.FLOWER_POLAR_GROW_TILE.random)
			inst.components.timer:StartTimer(timername, grow_time)
		end
	end
	
	--
	
	local function OnTerraform(_, data)
		if not _flowergrid or data == nil or data.original_tile == data.tile then
			return
		end
		
		local tx = data.x
		local ty = data.y
		local index = _flowergrid:GetIndex(tx, ty)
		
		if data.tile == WORLD_TILES.POLAR_GRASS and (inst.num_polarflowers or 0) < TUNING.MAX_FLOWER_POLAR then
			ScheduleFlower(tx, ty)
			return
		end
		
		CancelGrowth(index)
		RemoveFlower(tx, ty)
	end
	
	local function OnTimerDone(_, data)
		if not (data and data.name) then
			return
		end
		
		if not string.find(data.name, "spawnpolarflower_", 1, true) then
			return
		end
		
		local index = tonumber(string.sub(data.name, 18))
		if not _scheduled_spawn[index] then
			return
		end
		
		local tx, ty = _flowergrid:GetXYFromIndex(index)
		SpawnFlower(tx, ty)
	end
	
	local function OnGrowPolarFlower(_, data)
		if not (data and data.pt) then
			return
		end
		
		local tx, ty = _map:GetTileCoordsAtPoint(data.pt.x, data.pt.y or 0, data.pt.z)
		ScheduleFlower(tx, ty, data.overtime)
	end
	
	local function InitializeDataGrids(_, grid)
		WIDTH, HEIGHT = _map:GetSize()
		_flowergrid = DataGrid(WIDTH, HEIGHT)
		
		inst:RemoveEventCallback("winterlands_initialized", InitializeDataGrids)
	end
	
	inst:ListenForEvent("onterraform", OnTerraform)
	inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("ms_growpolarflower_at", OnGrowPolarFlower)
	inst:ListenForEvent("winterlands_initialized", InitializeDataGrids)
	
	--
	
	function self:OnSave()
		local data = {
			scheduled = {},
		}
		
		for index in pairs(_scheduled_spawn) do
			table.insert(data.scheduled, index)
		end
		
		return data
	end
	
	function self:OnLoad(data)
		if data == nil then
			return
		end
		
		if data.scheduled then
			for i, index in ipairs(data.scheduled) do
				_scheduled_spawn[index] = true
			end
		end
	end
end)