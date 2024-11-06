local assets = {
	Asset("ANIM", "anim/shadow_polar_basic.zip"),
}

local sounds = {
	attack = "dontstarve/sanity/creature1/attack",
	attack_grunt = "dontstarve/sanity/creature1/attack_grunt",
	death = "dontstarve/sanity/creature1/die",
	idle = "dontstarve/sanity/creature1/idle",
	taunt = "dontstarve/sanity/creature1/taunt",
	appear = "dontstarve/sanity/creature1/appear",
	disappear = "dontstarve/sanity/creature1/dissappear",
}

local brain = require("brains/shadow_iciclerbrain")

local function NotifyBrainOfTarget(inst, target)
	if inst.brain and inst.brain.SetTarget then
		inst.brain:SetTarget(target)
	end
end

local function RetargetFn(inst)
	local maxrangesq = TUNING.SHADOWCREATURE_TARGET_DIST * TUNING.SHADOWCREATURE_TARGET_DIST
	local rangesq, rangesq1, rangesq2 = maxrangesq, math.huge, math.huge
	local target1, target2 = nil, nil
	
	for i, v in ipairs(AllPlayers) do
		if v.components.sanity:IsCrazy() and not v:HasTag("playerghost") then
			local distsq = v:GetDistanceSqToInst(inst)
			
			if distsq < rangesq then
				if inst.components.shadowsubmissive:TargetHasDominance(v) then
					if distsq < rangesq1 and inst.components.combat:CanTarget(v) then
						target1 = v
						rangesq1 = distsq
						rangesq = math.max(rangesq1, rangesq2)
					end
				elseif distsq < rangesq2 and inst.components.combat:CanTarget(v) then
					target2 = v
					rangesq2 = distsq
					rangesq = math.max(rangesq1, rangesq2)
				end
			end
		end
	end
	
	local forcechange = inst.forceretarget
	inst.forceretarget = nil
	
	if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * .25) then
		return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
	end
	
	return target2, forcechange
end

local function KeepTargetFn(inst, target)
	return true
end

local function OnKilledByOther(inst, attacker)
	if attacker and attacker.components.sanity then
		attacker.components.sanity:DoDelta(inst.sanityreward or TUNING.SANITY_TINY)
	end
end

local function ShareTargetFn(dude)
	return dude:HasTag("shadowcreature") and not dude.components.health:IsDead()
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, 30, ShareTargetFn, 1)
end

local function OnNewCombatTarget(inst, data)
	NotifyBrainOfTarget(inst, data.target)
	
	inst._deaggrotime = nil
end

local function OnDeath(inst, data)
	if data and data.afflicter and data.afflicter:HasTag("crazy") then
		inst.components.lootdropper:SetLoot({"nightmarefuel"})
		inst.components.lootdropper:SetChanceLootTable(nil)
	end
end

local function Disappear(inst)
	if inst.deathtask then
		inst.deathtask:Cancel()
		inst.deathtask = nil
		
		inst.AnimState:PlayAnimation("disappear")
		inst:ListenForEvent("animover", inst.Remove)
	end
end

local function CalcSanityAura(inst, observer)
	return inst.components.combat:HasTarget() and observer.components.sanity:IsCrazy() and -TUNING.SANITYAURA_LARGE or 0
end

local function CLIENT_ShadowSubmissive_HostileToPlayerTest(inst, player)
	if player:HasTag("shadowdominance") then
		return false
	end
	
	if inst.replica.combat and inst.replica.combat:GetTarget() == player then
		return true
	end
	
	if player.replica.sanity and player.replica.sanity:IsCrazy() then
		return true
	end
	
	return false
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 10, 1.5)
	RemovePhysicsColliders(inst)
	inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	inst.Physics:CollidesWith(COLLISION.SANITY)
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("shadowcreaturepolar")
	inst.AnimState:SetBuild("shadow_polar_basic")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetMultColour(1, 1, 1, 0.5)
	
	inst:AddTag("shadowcreature")
	inst:AddTag("gestaltnoloot")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("shadow")
	inst:AddTag("notraptrigger")
	inst:AddTag("shadow_aligned")
	inst:AddTag("shadowsubmissive")
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("transparentonsanity")
		inst.components.transparentonsanity:ForceUpdate()
	end
	
	inst.HostileToPlayerTest = CLIENT_ShadowSubmissive_HostileToPlayerTest
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.sanityreward = TUNING.SANITY_TINY
	inst.sounds = sounds
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.SHADOW_ICICLER_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.SHADOW_ICICLER_ATTACK_PERIOD)
	inst.components.combat:SetRetargetFunction(3, RetargetFn)
	inst.components.combat.onkilledbyother = OnKilledByOther
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.SHADOW_ICICLER_HEALTH)
	inst.components.health.nofadeout = true
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.SHADOW_ICICLER_SPEED
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.pathcaps = {ignorecreep = true}
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("shadow_creature")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura
	
	inst:AddComponent("shadowsubmissive")
	
	inst.ShouldKeepTarget = KeepTargetFn
	
	inst.persists = false
	
	inst:SetStateGraph("SGshadow_icicler")
	inst:SetBrain(brain)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
	inst:ListenForEvent("death", OnDeath)
	
	return inst
end

return Prefab("shadow_icicler", fn, assets)