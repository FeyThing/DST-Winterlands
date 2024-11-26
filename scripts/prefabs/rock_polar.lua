local assets = {
	Asset("ANIM", "anim/rock_polar.zip"),
}

local prefabs = {
	"bluegem",
	"ice",
	"rocks",
}

SetSharedLootTable("rock_polar", {
	{"ice", 		1},
	{"ice", 		0.5},
	{"bluegem", 	0.9},
	{"bluegem", 	0.25},
})

local NUM_VARIATIONS = 3

local function UpdateVariation(inst, num)
	if num and inst.variation == nil then
		inst.variation = num
	end
	
	local workleft = inst.components.workable.workleft
	inst.AnimState:PlayAnimation(
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 4.2 and "idle_low") or
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 2.1 and "idle_med") or
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 1.3 and "idle_tall") or
		"idle_full")
	inst.AnimState:OverrideSymbol("rock0", "rock_polar", "rock"..(inst.variation - 1))
end

local function OnWork(inst, worker, workleft, numworks)
	if workleft <= 0 then
		local pt = inst:GetPosition()
		inst.components.lootdropper:DropLoot(pt)
		
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
		
		inst:Remove()
	else
		if numworks and numworks >= 0.8 then
			local ice = inst.components.lootdropper:SpawnLootPrefab("ice")
			if worker and worker.components.inventory then
				LaunchAt(ice, inst, worker, 1, 3, 1, 65)
			end
		end
		UpdateVariation(inst)
	end
end

local function OnSave(inst, data)
	data.variation = inst.variation
end

local function OnLoad(inst, data)
	if data and data.variation then
		UpdateVariation(inst, data.variation)
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
	
	inst.AnimState:SetBank("rock_polar")
	inst.AnimState:SetBuild("rock_polar")
	
	inst.MiniMapEntity:SetIcon("iceboulder.png") -- rock_polar.png
	
	inst:SetPrefabNameOverride("rock_polar")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("rock_polar")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkLeft(TUNING.POLAR_ROCK_MINE_TALL)
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable.savestate = true
	
	MakeHauntableWork(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	MakeSnowCovered(inst)
	
	local color = 1 - (math.random() * 0.2)
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	local scale = math.random() > 0.5 and 1.3 or -1.3
	inst.AnimState:SetScale(scale, 1.3)
	
	inst:DoTaskInTime(0, function() UpdateVariation(inst, math.random(NUM_VARIATIONS)) end)
	
	return inst
end

return Prefab("rock_polar", fn, assets, prefabs)