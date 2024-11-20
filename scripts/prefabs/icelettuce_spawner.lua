local prefabs = {
	"farm_plant_icelettuce",
}

-- TODO: would be cool to, like, replace the soil around the lettuce with snow or ice? Or that can be generalized to all crops standing in snow

local BLOCKER_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker", "character", "structure", "wall"}
local LETTUCE_TAGS = {"farm_plant_icelettuce"}

local function SnowHasSpace(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 4, nil, BLOCKER_TAGS) == 0 and TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z) == WORLD_TILES.POLAR_SNOW
end

local function SpawnLettuce(inst)
	local pt = inst:GetPosition()
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, GetRandomMinMax(4, 12), 8, false, true, SnowHasSpace)
	
	if offset then
		inst.lettuce = SpawnPrefab("farm_plant_icelettuce")
		inst.lettuce.Transform:SetPosition((pt + offset):Get())
	end
end

local function OnSave(inst, data)
	local ents = {}
	
	data.canspawnlettuce = inst.canspawnlettuce
	if inst.lettuce then
		data.lettuce_id = inst.lettuce.GUID
		table.insert(ents, data.lettuce_id)
	end
	
	return ents
end

local function OnLoadPostPass(inst, newents, savedata)
	if savedata then
		if savedata.lettuce_id and newents[savedata.lettuce_id] then
			inst.lettuce = newents[savedata.lettuce_id].entity
			inst.lettuce:LinkToHome(inst)
		end
		
		inst.canspawnlettuce = savedata.canspawnlettuce or inst.canspawnlettuce
	end
end

local function GetWildLettuces(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local lettuces = TheSim:FindEntities(x, y, z, 200, LETTUCE_TAGS)
	
	local num_wild = 0
	for i, v in ipairs(lettuces) do
		if not v.long_life and TheWorld.Map:GetTileAtPoint(v.Transform:GetWorldPosition()) == WORLD_TILES.POLAR_SNOW then
			num_wild = num_wild + 1
		end
	end
	
	return num_wild
end

local function OnTimerDone(inst, data)
	if data.name == "spawnlettuce" then
		local spawn_chance = GetWildLettuces(inst) < TUNING.ICELETTUCE_SPAWNER_MIN and 1 or TUNING.ICELETTUCE_SPAWNER_CHANCE
		
		if spawn_chance >= 1 or math.random() <= spawn_chance then
			inst:SpawnLettuce()
		end
	end
end

local function OnSeasonChange(inst, season)
	if season == "summer" then
		if inst.lettuce == nil and inst.canspawnlettuce then
			if not inst.components.timer:TimerExists("spawnlettuce") then
				inst.components.timer:StartTimer("spawnlettuce", GetRandomMinMax(TUNING.ICELETTUCE_SPAWNER_TIME.min, TUNING.ICELETTUCE_SPAWNER_TIME.max))
				inst.canspawnlettuce = nil
			end
		end
	else
		inst.canspawnlettuce = true
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("icelettucespawner")
	inst:AddTag("CLASSIFIED")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("timer")
	
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SpawnLettuce = SpawnLettuce
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:WatchWorldState("season", OnSeasonChange)
	OnSeasonChange(inst, TheWorld.state.season)
	
	return inst
end

return Prefab("icelettuce_spawner", fn, nil, prefabs)