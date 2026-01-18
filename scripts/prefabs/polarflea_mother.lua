local assets = {
	Asset("ANIM", "anim/polarflea_mother.zip"),
}

local brain = require("brains/polarflea_motherbrain")

SetSharedLootTable("polarflea_mother", {
	{"boneshard", 			1},
	{"boneshard", 			1},
	{"monstermeat", 		1},
	{"monstermeat", 		0.5},
	{"monstermeat", 		0.5},
	{"polarbearfur", 		1},
	{"polarbearfur", 		0.5},
	{"polarfleaeggsack", 	1},
	{"polarfleaeggsack", 	1},
	{"polarfleaeggsack", 	0.5},
	{"polarfleaeggsack", 	0.1},
})

local spew_prefabs = {
	polarflea = 1,
	winter_ornament_boss_polarflea = IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and 0.06 or 0,
}

local function KeepTargetFn(inst, target)
	return target and inst:IsNear(target, 20)
end

local RETARGET_MUST_TAGS = {"_combat"}
local RETARGET_CANT_TAGS = {"flea", "bearbuddy"}
local RETARGET_ONEOF_TAGS = {"player", "monster", "plant"}

local function Retarget(inst)
	local target = FindEntity(inst, TUNING.POLARFLEA_CHASE_RANGE, nil, RETARGET_MUST_TAGS, RETARGET_CANT_TAGS, RETARGET_ONEOF_TAGS)
	
	return target
end

--

local function DoFleaSpawnTimer(inst, stop)
	if inst.components.timer then
		if inst.components.timer:TimerExists("spawnfleas") then
			inst.components.timer:StopTimer("spawnfleas")
		end
		if not stop then
			inst.components.timer:StartTimer("spawnfleas", TUNING.POLARFLEA_MOTHER_FLEAS_SPAWN_COOLDOWN + math.random())
		end
	end
end

local function OnEntitySleep(inst)
	DoFleaSpawnTimer(inst, true)
end

local function OnEntityWake(inst)
	DoFleaSpawnTimer(inst)
end

local function OnAttacked(inst, data)
	if data and data.attacker then
		inst.components.combat:SetTarget(data.attacker)
		inst.components.combat:ShareTarget(data.attacker, TUNING.POLARFLEA_CHASE_RANGE, function(dude)
			return dude:HasTag("flea") and not dude.components.health:IsDead()
		end, 10)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "spawnfleas" then
		inst._wantstospawnfleas = true
		
		DoFleaSpawnTimer(inst)
	end
end

local function OnInit(inst)
	DoFleaSpawnTimer(inst)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 600, 1)
	
	inst.Transform:SetSixFaced()
	
	inst.DynamicShadow:SetSize(3, 1.25)
	
	inst.AnimState:SetBank("polarflea_mother")
	inst.AnimState:SetBuild("polarflea_mother")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetScale(1.3, 1.3)
	
	inst:AddTag("epic")
	inst:AddTag("smallepic")
	inst:AddTag("flea")
	inst:AddTag("insect")
	inst:AddTag("hostile")
	inst:AddTag("monster")
	inst:AddTag("smallcreature")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.spew_prefabs = spew_prefabs
	
	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "body_upper"
	inst.components.combat:SetDefaultDamage(TUNING.POLARFLEA_MOTHER_DAMAGE)
	inst.components.combat:SetRange(TUNING.POLARFLEA_MOTHER_ATTACK_RANGE)
	inst.components.combat:SetAttackPeriod(TUNING.POLARFLEA_MOTHER_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.POLARFLEA_MOTHER_HEALTH)
	
	inst:AddComponent("inventory")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("leader")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.POLARFLEA_MOTHER_RUN_SPEED
	inst.components.locomotor.walkspeed = TUNING.POLARFLEA_MOTHER_WALK_SPEED
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("polarflea_mother")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(2)
	
	inst:AddComponent("timer")
	
	MakeMediumBurnableCharacter(inst, "body_upper")
	MakeMediumFreezableCharacter(inst, "body_upper")
	
	MakeHauntablePanic(inst)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	inst:SetStateGraph("SGpolarflea_mother")
	inst:SetBrain(brain)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:DoTaskInTime(1, OnInit)
	
	return inst
end

return Prefab("polarflea_mother", fn, assets)