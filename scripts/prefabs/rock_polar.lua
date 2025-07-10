local assets = {
	Asset("ANIM", "anim/rock_polar.zip"),
}

local prefabs = {
	"bluegem",
	"bluegem_shards",
	"ice",
}

SetSharedLootTable("rock_polar", {
	{"ice", 			1},
	{"ice", 			0.5},
	{"bluegem_shards", 	0.7},
	{"bluegem_shards", 	0.7},
	{"bluegem_shards", 	0.3},
	{"bluegem", 		0.2},
})

local ROCK_POLAR_LOOTS = {
	ice = 0.85,
	bluegem_shards = 0.14,
	bluegem = 0.01,
}

local NUM_VARIATIONS = 3

local function UpdateVariation(inst, num)
	if num and inst.variation == nil then
		inst.variation = num
	end
	
	local workleft = inst.components.workable.workleft
	if inst.components.worldmigrator and workleft <= 0 then
		return
	end
	
	inst.AnimState:PlayAnimation(
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 4.2 and "idle_low") or
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 2.1 and "idle_med") or
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 1.3 and "idle_tall") or
		"idle_full")
	inst.AnimState:OverrideSymbol("rock0", "rock_polar", "rock"..(inst.variation - 1))
end

local function SetAsCave(inst) -- TEMP, but we have the whole update to do first lol
	inst:AddComponent("named")
	inst.components.named:SetName(STRINGS.NAMES.CAVE_ENTRANCE_POLAR)
	if inst.components.inspectable then
		inst.components.inspectable:SetNameOverride("cave_entrance_polar")
	end
	
	inst.AnimState:SetBank("cave_entrance")
	inst.AnimState:SetBuild("cave_entrance")
	inst.AnimState:PlayAnimation("no_access", true)
	inst.AnimState:SetMultColour(0.6, 0.8, 1, 1)
	inst.AnimState:SetScale(1, 1)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.MiniMapEntity:SetEnabled(false)
	inst.Physics:SetActive(false)
end

local function OnWork(inst, worker, workleft, numworks)
	if workleft <= 0 then
		local pt = inst:GetPosition()
		inst.components.lootdropper:DropLoot(pt)
		
		if worker and worker.SoundEmitter then
			worker.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
		end
		
		if inst.components.worldmigrator then
			SetAsCave(inst)
		else
			inst:Remove()
		end
	else
		if numworks and numworks >= 0.5 then
			local prefab = weighted_random_choice(inst.mine_loots)
			local loot = inst.components.lootdropper:SpawnLootPrefab(prefab)
			
			if worker and worker.components.inventory then
				LaunchAt(loot, inst, worker, 1, 3, 1, 65)
			end
		end
		UpdateVariation(inst)
	end
end

local function ActivateByOther(inst)
	OnWork(inst, nil, 0)
end

local function MakeCaveEntrance(inst)
	inst:AddTag("polarcave_entrance")
	
	inst:AddComponent("worldmigrator")
	inst.components.worldmigrator.id = TUNING.POLARCAVES_MIGRATION_ID
	inst.components.worldmigrator.receivedPortal = TUNING.POLARCAVES_MIGRATION_ID
	inst.components.worldmigrator:SetEnabled(false)
	
	if inst.components.workable and inst.components.workable.workleft <= 0 then
		SetAsCave(inst)
	end
	
	inst:ListenForEvent("migration_activate_other", ActivateByOther)
	
	local pt = inst:GetPosition()
	for i, v in ipairs(AllPlayers) do
		SendModRPCToClient(GetClientModRPC("Winterlands", "PolarCaveEntrance_SetPos"), v.userid, v, pt.x, pt.z)
	end
end

local function OnSave(inst, data)
	if inst.components.worldmigrator then
		data.iscave_temp = true
	end
	data.variation = inst.variation
end

local function OnLoad(inst, data)
	if data then
		if data.iscave_temp then -- NOTE: Temporary saved data, restore protuberance later if this is here, for when we add 'the effect' (wink wink)
			inst:MakeCaveEntrance()
		elseif data.variation then
			UpdateVariation(inst, data.variation)
		end
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("boulder")
	inst:AddTag("frozen")
	inst:AddTag("icicleimmune")
	inst:AddTag("protuberancespawnblocker")
	
	inst.AnimState:SetBank("rock_polar")
	inst.AnimState:SetBuild("rock_polar")
	
	inst.MiniMapEntity:SetIcon("rock_polar.png")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.mine_loots = ROCK_POLAR_LOOTS
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("rock_polar")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkLeft(TUNING.POLAR_ROCK_MINE_TALL)
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable.savestate = true
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst)
	
	inst.MakeCaveEntrance = MakeCaveEntrance
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	local color = 1 - (math.random() * 0.2)
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	local scale = math.random() > 0.5 and 1.3 or -1.3
	inst.AnimState:SetScale(scale, 1.3)
	
	inst:DoTaskInTime(0, function() UpdateVariation(inst, math.random(NUM_VARIATIONS)) end)
	
	return inst
end

local function OnPolarFreeze(inst, forming)
	if forming and IsInPolar(inst) then
		local rock = SpawnPrefab("rock_polar")
		rock.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if TheSim:FindFirstEntityWithTag("polarcave_entrance") == nil then
			inst:MakeCaveEntrance() -- Only useful in case players broke all their protuberances before update, so no reload is necessary
		end
	end
	
	inst:Remove()
end

local function spawner()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("protuberancespawnblocker")
	
	inst.OnPolarFreeze = OnPolarFreeze
	
	return inst
end

return Prefab("rock_polar", fn, assets, prefabs),
	Prefab("rock_polar_spawner", spawner)