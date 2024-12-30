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

SetSharedLootTable("antler_tree_burnt", {
	{"charcoal", 1},
})

local tree_sticcs = {"low", "med", "high"}

local function ChopTree(inst, chopper, chops)
	inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("idle", false)
	if not (chopper and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
	
	if inst.components.timer then
		if not inst.components.timer:TimerExists("regenworkleft") then
			inst.components.timer:StartTimer("regenworkleft", TUNING.ANTLER_TREE_CHOPS_REGEN_TIME)
		else
			inst.components.timer:SetTimeLeft("regenworkleft", TUNING.ANTLER_TREE_CHOPS_REGEN_TIME)
		end
	end
	
	if chopper and chopper:HasTag("moose") or chopper:HasTag("weremoose") then
		local valid_sticcs = {}
		for k, v in pairs(inst.sticcs) do
			if v then
				table.insert(valid_sticcs, k)
			end
		end
		
		if #valid_sticcs > 0 then
			local k = valid_sticcs[math.random(#valid_sticcs)]
			
			local sticc = inst.components.lootdropper:SpawnLootPrefab("antler_tree_stick")
			if sticc.DropSticc then
				sticc:DropSticc(inst, k)
			end
			
			inst.sticcs[k] = nil
		end
		
		inst:SetSticcs()
	end
end

local function SetStump(inst)
	inst.sticcs = nil
	
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
	inst.MiniMapEntity:SetIcon("antler_tree_stump.png")
end

local function DigUpStump(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst:Remove()
end

local function ChopDownTree(inst, chopper)
	local he_right = (chopper:GetPosition() - inst:GetPosition()):Dot(TheCamera:GetRightVec()) > 0
	inst.AnimState:PlayAnimation("fall"..(he_right and (inst.face_left and "left" or "right") or (inst.face_left and "right" or "left")))
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
	inst:ListenForEvent("animover", inst.Remove)
end

local function OnBurnt(inst)
	inst.sticcs = nil
	
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("hauntable")
	MakeHauntableWork(inst)
	
	inst.components.lootdropper:SetChanceLootTable("moontree_burnt")
	
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnWorkCallback(nil)
	inst.components.workable:SetOnFinishCallback(ChopDownBurntTree)
	
	inst.AnimState:PlayAnimation("burnt")
	inst:AddTag("burnt")
	inst.MiniMapEntity:SetIcon("antler_tree_burnt.png")
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
	if inst.sticcs then
		data.sticcs = inst.sticcs
	end
end

local function OnLoad(inst, data)
	if data then
		if data.sticcs then
			inst.sticcs = data.sticcs
			inst:SetSticcs()
		end
		if data.stump then
			SetStump(inst)
			
			inst.AnimState:PlayAnimation("stump")
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

local function SetSticcs(inst)
	for i, v in ipairs(tree_sticcs) do
		if inst.sticcs[v] then
			inst.AnimState:Show("antler_"..v)
		else
			inst.AnimState:Hide("antler_"..v)
		end
	end
end

local function OnTimerDone(inst, data)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		return
	end
	
	if data.name == "regensticc" then
		inst.sticcs = {}
		for i, v in ipairs(tree_sticcs) do
			inst.sticcs[v] = true
		end
		inst:SetSticcs()
	elseif data.name == "regenworkleft" then
		inst.components.workable:SetWorkLeft(TUNING.ANTLER_TREE_CHOPS)
	end
end

local function OnSeasonChange(inst, season)
	if season == "winter" then
		if not inst.components.timer:TimerExists("regensticc") then
			local season_time = TheWorld.state[TheWorld.state.season.."length"] * TUNING.TOTAL_DAY_TIME
			inst.components.timer:StartTimer("regensticc", GetRandomMinMax(TUNING.TOTAL_DAY_TIME, season_time))
		end
	elseif inst.components.timer and inst.components.timer:TimerExists("regensticc") then
		inst.components.timer:StopTimer("regensticc")
	end
end

local function MakeHornyTree(data)
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()
		
		MakeObstaclePhysics(inst, 0.25)
		
		inst.MiniMapEntity:SetIcon("antler_tree.png")
		inst.MiniMapEntity:SetPriority(-1)
		
		inst:AddTag("plant")
		inst:AddTag("tree")
		inst:AddTag("antlertree")
		
		inst.AnimState:SetBuild("antler_tree")
		inst.AnimState:SetBank("antler_tree")
		inst.AnimState:PlayAnimation("idle")
		
		inst:SetPrefabName("antler_tree")
		
		MakeSnowCoveredPristine(inst)
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.sticcs = {}
		for i, v in ipairs(tree_sticcs) do
			inst.sticcs[v] = true
		end
		
		MakeLargeBurnable(inst)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
		MakeSmallPropagator(inst)
		
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = GetStatus
		
		inst:AddComponent("lootdropper")
		inst.components.lootdropper:SetChanceLootTable("antler_tree")
		
		inst:AddComponent("timer")
		
		if data ~= "stump" then
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.CHOP)
			inst.components.workable:SetWorkLeft(TUNING.ANTLER_TREE_CHOPS)
			inst.components.workable:SetOnWorkCallback(ChopTree)
			inst.components.workable:SetOnFinishCallback(ChopDownTree)
		end
		
		local color = 0.7 + math.random() * 0.3
		inst.AnimState:SetMultColour(color, color, color, 1)
		
		inst.face_left = math.random() > 0.5
		local scale = inst.face_left and 1.4 or -1.4
		inst.AnimState:SetScale(scale, 1.4)
		
		if data == "stump" then
			inst.AnimState:PlayAnimation("stump")
			SetStump(inst)
			
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(DigUpStump)
			inst.components.workable:SetWorkLeft(1)
		elseif data == "burnt" then
			OnBurnt(inst)
		end
		
		MakeHauntableWorkAndIgnite(inst)
		MakeSnowCovered(inst)
		
		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
		inst.SetSticcs = SetSticcs
		
		inst:ListenForEvent("timerdone", OnTimerDone)
		
		inst:WatchWorldState("season", OnSeasonChange)
		OnSeasonChange(inst, TheWorld.state.season)
		
		return inst
	end
	
	return Prefab("antler_tree"..(data ~= nil and "_"..data or ""), fn, assets, prefabs)
end

return MakeHornyTree(),
	MakeHornyTree("stump"),
	MakeHornyTree("burnt")