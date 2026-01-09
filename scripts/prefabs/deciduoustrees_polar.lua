-- Ultra basic perma-barren version of birchnut trees, from acorns grown in Winterlands

local assets = Prefabs.deciduoustree.assets

local prefabs = Prefabs.deciduoustree.deps

local function makeanims(stage)
	return {
		idle = "idle_"..stage,
		sway1 = "sway1_loop_"..stage,
		sway2 = "sway2_loop_"..stage,
		swayaggropre = "sway_agro_pre",
		swayaggro = "sway_loop_agro",
		swayaggropst = "sway_agro_pst",
		swayaggroloop = "idle_loop_agro",
		swayfx = "swayfx_"..stage,
		chop = "chop_"..stage,
		fallleft = "fallleft_"..stage,
		fallright = "fallright_"..stage,
		stump = "stump_"..stage,
		burning = "burning_loop_"..stage,
		burnt = "burnt_"..stage,
		chop_burnt = "chop_burnt_"..stage,
		idle_chop_burnt = "idle_chop_burnt_"..stage,
		dropleaves = "drop_leaves_"..stage,
		growleaves = "grow_leaves_"..stage,
	}
end

local SHORT = "short"
local NORMAL = "normal"
local TALL = "tall"

local anims = {
	[SHORT] = makeanims(SHORT),
	[TALL] = makeanims(TALL),
	[NORMAL] = makeanims(NORMAL),
}

SetSharedLootTable("deciduoustree_polar_small", {
	{"log", 1},
})

SetSharedLootTable("deciduoustree_polar_normal", {
	{"log", 1},
	{"log", 1},
})

SetSharedLootTable("deciduoustree_polar_tall", {
	{"log", 1},
	{"log", 1},
	{"log", 1},
})

SetSharedLootTable("deciduoustree_polar_burnt", {
	{"charcoal", 1},
})

--	Chop, Chop

local function ChopDownBurnt(inst, chopper)
	inst:RemoveComponent("workable")
	
	inst.components.lootdropper:DropLoot()
	
	RemovePhysicsColliders(inst)
	
	inst.AnimState:PlayAnimation(anims[inst.size].chop_burnt)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	if not (chopper and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
	
	inst:ListenForEvent("animover", inst.Remove)
end

local function BurntChanges(inst)
	if inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("growable")
	inst:RemoveComponent("hauntable")
	MakeHauntableWork(inst)
	
	--inst:RemoveTag("shelter")
	
	inst.components.lootdropper:SetChanceLootTable("deciduoustree_polar_burnt")
	
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(1)
		inst.components.workable:SetOnWorkCallback(nil)
		inst.components.workable:SetOnFinishCallback(ChopDownBurnt)
	end
end

local function TreeBurntImmediateHelper(inst, immediate)
	if immediate then
		BurntChanges(inst)
	else
		inst:DoTaskInTime(0.5, BurntChanges)
	end
	
	inst.AnimState:PlayAnimation(anims[inst.size].burnt, true)
	inst.MiniMapEntity:SetIcon("tree_leaf_burnt.png")
	
	inst.AnimState:SetRayTestOnBB(true)
	inst:AddTag("burnt")
	
	if inst.components.timer and not inst.components.timer:TimerExists("decay") then
		inst.components.timer:StartTimer("decay", GetRandomWithVariance(TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME, TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME * 0.5))
	end
end

local function OnTreeBurnt(inst)
	TreeBurntImmediateHelper(inst, false)
end

local function OnDigUp(inst, digger)
	inst.components.lootdropper:SpawnLootPrefab("log")
	
	inst:Remove()
end

local function MakeStumpBurnable(inst)
	if inst.size == SHORT then
		MakeSmallBurnable(inst)
	elseif inst.size == NORMAL then
		MakeMediumBurnable(inst)
	else
		MakeLargeBurnable(inst)
		inst.components.burnable:SetFXLevel(5)
	end
end

local function MakeStump(inst)
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("workable")
	RemoveLunarHailBuildup(inst)
	inst:RemoveComponent("hauntable")
	--inst:RemoveTag("shelter")
	
	MakeStumpBurnable(inst)
	MakeMediumPropagator(inst)
	MakeHauntableIgnite(inst)
	
	RemovePhysicsColliders(inst)
	
	inst:AddTag("stump")
	inst.MiniMapEntity:SetIcon("tree_leaf_stump.png")
	
	if inst.components.growable then
		inst.components.growable:StopGrowing()
	end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(OnDigUp)
	inst.components.workable:SetWorkLeft(1)
	
	if inst.components.timer and not inst.components.timer:TimerExists("decay") then
		inst.components.timer:StartTimer("decay", GetRandomWithVariance(TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME, TUNING.DECIDUOUS_REGROWTH.DEAD_DECAY_TIME * 0.5))
	end
end

--

local function OnChopTree(inst, chopper, chops_remaining, num_chops)
	if not (chopper and chopper:HasTag("playerghost")) then
		inst.SoundEmitter:PlaySound(chopper and chopper:HasTag("beaver") and "dontstarve/characters/woodie/beaver_chop_tree" or "dontstarve/wilson/use_axe_tree")
	end
	
	local anim_set = anims[inst.size]
	inst.AnimState:PlayAnimation(anim_set.chop)
	inst.AnimState:PushAnimation(anim_set.sway1, true)
end

local function OnChopDrownTree(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	local pt = inst:GetPosition()
	
	local chopper_on_rightside = true
	if chopper then
		local chopper_position = chopper:GetPosition()
		chopper_on_rightside = (chopper_position - pt):Dot(TheCamera:GetRightVec()) > 0
	else
		-- If we got chopped down by something other than a chopper, just pick a random sway to perform.
		if math.random() > 0.5 then
			chopper_on_rightside = false
		end
	end
	
	local anim_set = anims[inst.size]
	if chopper_on_rightside then
		inst.AnimState:PlayAnimation(anim_set.fallleft)
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation(anim_set.fallright)
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	inst:DoTaskInTime(0.4, function (inst)
		ShakeAllCameras( CAMERASHAKE.FULL, .25, 0.03, (inst.size == TALL and 0.5) or 0.25, inst, 6)
	end)

	MakeStump(inst)
	inst.AnimState:PushAnimation(anim_set.stump)
end

local function Sway(inst)
	local anim_to_play = (math.random() > 0.5 and anims[inst.size].sway1) or anims[inst.size].sway2
	inst.AnimState:PlayAnimation(anim_to_play, true)
end

local function PushSway(inst)
	local anim_to_play = (math.random() > 0.5 and anims[inst.size].sway1) or anims[inst.size].sway2
	inst.AnimState:PushAnimation(anim_to_play, true)
end

local function GetStatus(inst)
	return (inst:HasTag("burnt") and "BURNT")
		or (inst:HasTag("stump") and "CHOPPED")
		or nil
end

--	States

local function SetShortBurnable(inst)
	if inst.components.burnable == nil then
		inst:AddComponent("burnable")
		inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
	end
	inst.components.burnable:SetFXLevel(2)
	inst.components.burnable:SetBurnTime(TUNING.TREE_BURN_TIME / 2)
	inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
	inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
	inst.components.burnable:SetOnBurntFn(OnTreeBurnt)
	
	if inst.components.propagator == nil then
		inst:AddComponent("propagator")
	end
	inst.components.propagator.acceptsheat = true
	inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
	inst.components.propagator.flashpoint = 5 + math.random() * 5
	inst.components.propagator.decayrate = 0.5
	inst.components.propagator.propagaterange = 5
	inst.components.propagator.heatoutput = 5
	inst.components.propagator.damagerange = 2
	inst.components.propagator.damages = true
end

local function SetShort(inst)
	inst.size = SHORT
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_SMALL)
	end
	
	SetShortBurnable(inst)
	inst.components.lootdropper:SetChanceLootTable("deciduoustree_polar_small")
	
	--inst:AddTag("shelter")
	Sway(inst)
end

local function GrowShort(inst)
	inst.AnimState:PlayAnimation("grow_tall_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
	
	SetShortBurnable(inst)
	
	PushSway(inst)
end

--

local function SetNormalBurnable(inst)
	if inst.components.burnable == nil then
		inst:AddComponent("burnable")
		inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
	end
	inst.components.burnable:SetBurnTime(TUNING.TREE_BURN_TIME)
	inst.components.burnable:SetFXLevel(3)
	inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
	inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
	inst.components.burnable:SetOnBurntFn(OnTreeBurnt)
	
	if inst.components.propagator == nil then
		inst:AddComponent("propagator")
	end
	inst.components.propagator.acceptsheat = true
	inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
	inst.components.propagator.flashpoint = 5 + math.random() * 5
	inst.components.propagator.decayrate = 0.5
	inst.components.propagator.propagaterange = 5
	inst.components.propagator.heatoutput = 5
	inst.components.propagator.damagerange = 2
	inst.components.propagator.damages = true
end

local function SetNormal(inst)
	inst.size = NORMAL
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_NORMAL)
	end
	
	SetNormalBurnable(inst)
	inst.components.lootdropper:SetChanceLootTable("deciduoustree_polar_normal")
	
	--inst:AddTag("shelter")
	Sway(inst)
end

local function GrowNormal(inst)
	inst.AnimState:PlayAnimation("grow_short_to_normal")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	
	SetNormalBurnable(inst)
	PushSway(inst)
end

--

local function SetTallBurnable(inst)
	if inst.components.burnable == nil then
		inst:AddComponent("burnable")
		inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
	end
	inst.components.burnable:SetFXLevel(5)
	inst.components.burnable:SetBurnTime(TUNING.TREE_BURN_TIME * 1.5)
	inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
	inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
	inst.components.burnable:SetOnBurntFn(OnTreeBurnt)
	
	if inst.components.propagator == nil then
		inst:AddComponent("propagator")
	end
	inst.components.propagator.acceptsheat = true
	inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
	inst.components.propagator.flashpoint = 15 + math.random() * 10
	inst.components.propagator.decayrate = 0.5
	inst.components.propagator.propagaterange = 7
	inst.components.propagator.heatoutput = 8.5
	inst.components.propagator.damagerange = 3
	inst.components.propagator.damages = true
end

local function SetTall(inst)
	inst.size = TALL
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.DECIDUOUS_CHOPS_TALL)
	end
	
	SetTallBurnable(inst)
	inst.components.lootdropper:SetChanceLootTable("deciduoustree_polar_tall")
	
	--inst:AddTag("shelter")
	Sway(inst)
end

local function GrowTall(inst)
	inst.AnimState:PlayAnimation("grow_normal_to_tall")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	
	SetTallBurnable(inst)
	PushSway(inst)
end

local growth_stages = {
	{
		name = SHORT,
		time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[1].base, TUNING.DECIDUOUS_GROW_TIME[1].random) end,
		fn = SetShort,
		growfn = GrowShort
	},
	{
		name = NORMAL,
		time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[2].base, TUNING.DECIDUOUS_GROW_TIME[2].random) end,
		fn = SetNormal,
		growfn = GrowNormal
	},
	{
		name = TALL,
		time = function(inst) return GetRandomWithVariance(TUNING.DECIDUOUS_GROW_TIME[3].base, TUNING.DECIDUOUS_GROW_TIME[3].random) end,
		fn = SetTall,
		growfn = GrowTall
	},
}

--

local function growfromseed_handler(inst)
	inst.components.growable:SetStage(1)
	
	inst.AnimState:PlayAnimation("grow_seed_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	
	PushSway(inst)
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
	if inst:HasTag("stump") then
		data.stump = true
	end
	
	data.size = inst.size
end

local function OnLoad(inst, data)
	if data == nil then
		return
	end
	
	inst.size = data.size or NORMAL
	
	if inst.size == SHORT then
		SetShort(inst)
	elseif inst.size == NORMAL then
		SetNormal(inst)
	else
		SetTall(inst)
	end
	
	local isburnt = data.burnt or inst:HasTag("burnt")
	if data.stump and isburnt then
		MakeStump(inst)
		
		inst.AnimState:PlayAnimation(anims[inst.size].stump)
		
		DefaultBurntFn(inst)
	elseif data.stump then
		MakeStump(inst)
		
		inst.AnimState:PlayAnimation(anims[inst.size].stump)
	elseif isburnt then
		TreeBurntImmediateHelper(inst, true)
	else
		Sway(inst)
	end
	
	if isburnt then
		RemoveLunarHailBuildup(inst)
	end
end

local function OnEntitySleep(inst)
	local doburnt = inst.components.burnable and inst.components.burnable:IsBurning()
	
	if doburnt and inst:HasTag("stump") then
		DefaultBurntFn(inst)
	else
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
		
		if doburnt then
			inst:RemoveComponent("growable")
			inst:AddTag("burnt")
		end
	end
end

local function OnEntityWake(inst)
	if inst:HasTag("burnt") then
		OnTreeBurnt(inst)
	else
		if not (inst.components.burnable and inst.components.burnable:IsBurning()) then
			if inst:HasTag("stump") then
				if inst.components.burnable == nil then
					MakeStumpBurnable(inst)
				end
				
				if inst.components.propagator == nil then
					MakeMediumPropagator(inst)
				end
			else
				if inst.size == SHORT then
					SetShortBurnable(inst)
				elseif inst.size == NORMAL then
					SetNormalBurnable(inst)
				else
					SetTallBurnable(inst)
				end
			end
		end
	end
end

local function OnTimerDone(inst, data)
	if data.name ~= "decay" then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local entities = TheSim:FindEntities(x, y, z, 6)
	local leftone = false
	
	for k, entity in pairs(entities) do
		if entity.prefab == "log" or entity.prefab == "charcoal" then
			if leftone then
				entity:Remove()
			else
				leftone = true
			end
		end
	end
	
	inst:Remove()
end

local function tree(name, stage, data)
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()
		
		MakeObstaclePhysics(inst, 0.25)
		inst:SetDeploySmartRadius(DEPLOYSPACING_RADIUS[DEPLOYSPACING.DEFAULT] / 2)
		
		inst.MiniMapEntity:SetIcon("tree_leafy_polar.png")
		inst.MiniMapEntity:SetPriority(-1)
		
		inst:AddTag("plant")
		inst:AddTag("tree")
		inst:AddTag("birchnut")
		inst:AddTag("cattoyairborne")
		inst:AddTag("deciduoustree_polar")
		--inst:AddTag("shelter")
		
		inst.build = "barren"
		inst.AnimState:SetBank("tree_leaf")
		inst.AnimState:SetBuild("tree_leaf_trunk_build")
		inst.AnimState:ClearOverrideSymbol("swap_leaves")
		
		inst:SetPrefabName("deciduoustree_polar")
		inst:SetPrefabNameOverride("deciduoustree")
		
		MakeSnowCoveredPristine(inst)
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("cattoy")
		
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = GetStatus
		
		inst:AddComponent("lootdropper")
		
		inst:AddComponent("plantregrowth")
		inst.components.plantregrowth:SetRegrowthRate(TUNING.DECIDUOUS_REGROWTH.OFFSPRING_TIME)
		inst.components.plantregrowth:SetProduct("acorn_sapling")
		inst.components.plantregrowth:SetSearchTag("deciduoustree_polar")
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetOnWorkCallback(OnChopTree)
		inst.components.workable:SetOnFinishCallback(OnChopDrownTree)
		
		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable.loopstages = true
		inst.components.growable.springgrowth = true
		inst.components.growable.magicgrowable = true
		inst.components.growable:SetStage(stage == 0 and math.random(1, 3) or stage)
		inst.components.growable:StartGrowing()
		
		inst:AddComponent("simplemagicgrower")
		inst.components.simplemagicgrower:SetLastStage(#inst.components.growable.stages)
		
		inst:AddComponent("timer")
		inst:ListenForEvent("timerdone", OnTimerDone)
		
		MakeHauntableWorkAndIgnite(inst)
		MakeSnowCovered(inst)
		MakeWaxablePlant(inst)
		
		inst.leaf_state = "barren"
		inst.monster = false
		
		inst.growfromseed = growfromseed_handler
		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake
		
		--TODO: Maybe let tree toggle between each others after a season in other region, still simpler...
		--inst:WatchWorldState("cycles", OnCyclesChanged)
		--inst:WatchWorldState("season", OnSeasonChanged)
		
		inst.color = 0.5 + math.random() * 0.5
		inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
		inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
		
		return inst
	end
	
	return Prefab(name, fn, assets, prefabs)
end

return tree("deciduoustree_polar", 0),
	tree("deciduoustree_polar_short", 1),
	tree("deciduoustree_polar_normal", 2),
	tree("deciduoustree_polar_tall", 3)