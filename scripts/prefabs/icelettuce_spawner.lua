local prefabs = {
	"farm_plant_icelettuce",
}

-- TODO: would be cool to, like, replace the soil around the lettuce with snow or ice? Or that can be generalized to all crops standing in snow

local BLOCKER_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker", "character", "structure", "wall"}
local LETTUCE_TAGS = {"farm_plant_icelettuce"}

local function SnowHasSpace(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 16, nil, nil, BLOCKER_TAGS) == 0 and TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true)
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
	
	data.respawnlettuce = inst.respawnlettuce
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
		end
		
		inst.respawnlettuce = savedata.respawnlettuce or inst.respawnlettuce
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
	local curseason = POLARRIFY_MOD_SEASONS[TheWorld.state.season] or "autumn"
	
	if data.name == "spawnlettuce" then
		if table.contains(TUNING.ICELETTUCE_REGROWTH_SEASONS, curseason) then
			local num_lettuces = inst:GetWildLettuces()
			
			local spawn_chance = (num_lettuces < TUNING.ICELETTUCE_REGROWTH_MIN_QUANTITY and 1)
				or (num_lettuces < TUNING.ICELETTUCE_REGROWTH_MAX_QUANTITY and TUNING.ICELETTUCE_REGROWTH_CHANCE)
				or 0
			
			if spawn_chance >= 1 or math.random() <= spawn_chance then
				inst:SpawnLettuce()
			end
		end
		-- TODO: Add cooldown timer until the end of the season so that reloading won't start this again if lettuce was picked
		inst.respawnlettuce = true
	end
end

local function OnSeasonChange(inst, season)
	local curseason = POLARRIFY_MOD_SEASONS[season] or "autumn"
	
	if table.contains(TUNING.ICELETTUCE_REGROWTH_SEASONS, curseason) then
		if inst.lettuce == nil and inst.respawnlettuce then
			if not inst.components.timer:TimerExists("spawnlettuce") then
				inst.components.timer:StartTimer("spawnlettuce", GetRandomMinMax(TUNING.ICELETTUCE_REGROWTH_TIME.min, TUNING.ICELETTUCE_REGROWTH_TIME.max))
				inst.respawnlettuce = false
			end
		end
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
	
	inst.respawnlettuce = true
	
	inst:AddComponent("timer")
	
	inst.GetWildLettuces = GetWildLettuces
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SpawnLettuce = SpawnLettuce
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:WatchWorldState("season", OnSeasonChange)
	OnSeasonChange(inst, TheWorld.state.season)
	
	return inst
end

return Prefab("icelettuce_spawner", fn, nil, prefabs)