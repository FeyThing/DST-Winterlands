local assets = {
	Asset("ANIM", "anim/polar_rocks.zip"),
}

local prefabs = {
	"bluegem",
	"ice",
	"rocks",
}

SetSharedLootTable("rock_polar", {
	{"ice", 		1},
	{"ice", 		1},
	{"ice", 		1},
	{"ice", 		0.5},
	{"bluegem", 	0.75},
	{"bluegem", 	0.5},
	{"rocks", 		0.1},
})

SetSharedLootTable("rock_polar_med", {
	{"ice", 		1},
	{"ice", 		1},
	{"ice", 		1},
	{"bluegem", 	0.5},
	{"bluegem", 	0.25},
	{"rocks", 		0.1},
})

SetSharedLootTable("rock_polar_low", {
	{"ice", 		1},
	{"ice", 		1},
	{"bluegem", 	0.5},
	{"rocks", 		0.1},
})

local NUM_VARIATIONS = 1

local function UpdateVariation(inst, num)
	if num and inst.variation == nil then
		inst.variation = num
	end
	
	local workleft = inst.components.workable.workleft
	inst.AnimState:PlayAnimation(
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 3 and "idle_low") or
		(workleft <= TUNING.POLAR_ROCK_MINE_TALL / 1.5 and "idle_med") or
		"idle_full")
end

local function OnWork(inst, worker, workleft)
	if workleft <= 0 then
		local pt = inst:GetPosition()
		inst.components.lootdropper:DropLoot(pt)
		--SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
		inst:Remove()
	else
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

local function commonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.25)
	
	inst:AddTag("boulder")
	inst:AddTag("icicleimmune")
	
	inst.AnimState:SetBank("polar_rocks")
	inst.AnimState:SetBuild("polar_rocks")
	
	inst.MiniMapEntity:SetIcon("rock_polar.png")
	
	inst:SetPrefabNameOverride("rock_polar")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable.savestate = true
	
	MakeHauntableWork(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	MakeSnowCovered(inst)
	
	local color = 1 - (math.random() * 0.2)
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	local scale = math.random() > 0.5 and 1.75 or -1.75
	inst.AnimState:SetScale(scale, 1.75)
	
	inst:DoTaskInTime(0, function() UpdateVariation(inst, math.random(NUM_VARIATIONS)) end)
	
	return inst
end

local function fn()
	local inst = commonfn()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:SetChanceLootTable("polar_rock")
	
	inst.components.workable:SetWorkLeft(TUNING.POLAR_ROCK_MINE_TALL)
	
	return inst
end

local function medrock()
	local inst = commonfn()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:SetChanceLootTable("polar_rock_med")
	
	inst.components.workable:SetWorkLeft(TUNING.POLAR_ROCK_MINE_TALL / 1.5)
	
	return inst
end

local function lowrock()
	local inst = commonfn()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:SetChanceLootTable("polar_rock_low")
	
	inst.components.workable:SetWorkLeft(TUNING.POLAR_ROCK_MINE_TALL / 3)
	
	return inst
end

return Prefab("rock_polar", fn, assets, prefabs),
	Prefab("rock_polar_med", medrock, assets, prefabs),
	Prefab("rock_polar_low", lowrock, assets, prefabs)