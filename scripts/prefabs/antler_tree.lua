local assets = {
	Asset("ANIM", "anim/antler_tree.zip"),
}

local prefabs = {
	"log",
	"twigs",
	"charcoal",
}

SetSharedLootTable("antler_tree", {
	{"log", 	1},
	{"log", 	0.5},
	{"twigs", 	1},
})

local function ChopTree(inst, chopper, chops)
	inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("idle", false)
	if not (chopper and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
end

local function SetStump(inst)
	inst:RemoveComponent("workable")
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("hauntable")
	
	if not inst:HasTag("burnt") then
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		MakeHauntableIgnite(inst)
	end
	
	RemovePhysicsColliders(inst)
	inst:AddTag("stump")
	inst.MiniMapEntity:SetIcon("marshtree_stump.png")
end

local function DigUpStump(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst:Remove()
end

local function ChopDownTree(inst, chopper)
	local he_right = (chopper:GetPosition() - inst:GetPosition()):Dot(TheCamera:GetRightVec()) > 0
	inst.AnimState:PlayAnimation("fall"..(he_right and "right" or "left"))
	inst.AnimState:PushAnimation("stump", false)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	if not (chopper and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
	
	SetStump(inst)
	inst.components.lootdropper:DropLoot()
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUpStump)
	inst.components.workable:SetWorkLeft(1)
end

local function ChopDownBurntTree(inst, chopper)
	inst.AnimState:PlayAnimation("chop_burnt")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	if not (chopper and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
	
	inst.components.lootdropper:DropLoot()
	
	SetStump(inst)
	RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", inst.Remove)
end

local function OnBurnt(inst)
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("hauntable")
	MakeHauntableWork(inst)
	
	inst.components.lootdropper:SetLoot({"charcoal"})
	
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnWorkCallback(nil)
	inst.components.workable:SetOnFinishCallback(ChopDownBurntTree)
	
	inst.AnimState:PlayAnimation("burnt_idle", true)
	inst:AddTag("burnt")
	inst.MiniMapEntity:SetIcon("marshtree_burnt.png")
end

local function GetStatus(inst)
	return (inst:HasTag("burnt") and "BURNT")
		or (inst:HasTag("stump") and "CHOPPED")
		or (inst.components.burnable and inst.components.burnable:IsBurning() and "BURNING")
		or nil
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
	if inst:HasTag("stump") then
		data.stump = true
	end
end

local function OnLoad(inst, data)
	if data then
		if data.stump then
			SetStump(inst)
			
			inst.AnimState:PlayAnimation("stump", false)
			if data.burnt or inst:HasTag("burnt") then
				DefaultBurntFn(inst)
			else
				inst:AddComponent("workable")
				inst.components.workable:SetWorkAction(ACTIONS.DIG)
				inst.components.workable:SetOnFinishCallback(DigUpStump)
				inst.components.workable:SetWorkLeft(1)
			end
		elseif data.burnt and not inst:HasTag("burnt") then
			OnBurnt(inst)
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
	
	MakeObstaclePhysics(inst, 0.25)
	
	inst.MiniMapEntity:SetIcon("marshtree.png")
	inst.MiniMapEntity:SetPriority(-1)
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	
	inst.AnimState:SetBuild("antler_tree")
	inst.AnimState:SetBank("antler_tree")
	inst.AnimState:PlayAnimation("idle")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	MakeLargeBurnable(inst)
	inst.components.burnable:SetOnBurntFn(OnBurnt)
	MakeSmallPropagator(inst)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("antler_tree")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(ChopTree)
	inst.components.workable:SetOnFinishCallback(ChopDownTree)
	
	local color = 0.5 + math.random() * 0.5
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	local scale = math.random() > 0.5 and 1.4 or -1.4
	inst.AnimState:SetScale(scale, 1.4)
	
	MakeHauntableWorkAndIgnite(inst)
	MakeSnowCovered(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("antler_tree", fn, assets, prefabs)