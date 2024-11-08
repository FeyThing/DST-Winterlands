local assets = {
	Asset("ANIM", "anim/shadow_polar_basic.zip"),
	Asset("ANIM", "anim/shadow_polar_spikes.zip"),
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
	
	if target1 ~= nil and rangesq1 <= math.max(rangesq2, maxrangesq * 0.25) then
		return target1, not inst.components.shadowsubmissive:TargetHasDominance(inst.components.combat.target)
	end
	
	return target2, forcechange
end

local function KeepTargetFn(inst, target)
	if inst.sg.mem.forcedespawn then
		return true
	elseif target.components.sanity == nil then
		if inst.wantstodespawn then
			inst.sg.mem.forcedespawn = true
		end
		
		return true
	elseif target.components.sanity:IsCrazy() then
		inst._deaggrotime = nil
		return true
	end
	
	local t = GetTime()
	if inst._deaggrotime == nil then
		inst._deaggrotime = t
		return true
	end
	
	if inst._deaggrotime + 2.5 >= t or inst.components.combat.lastwasattackedbytargettime + 6 >= t
		or (target.components.combat and target.components.combat:IsRecentTarget(inst) and (target.components.combat.laststartattacktime or 0) + 5 >= t) then
		
		return true
	elseif inst.wantstodespawn then
		inst.sg.mem.forcedespawn = true
		return true
	end
	
	return false
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
	
	MakeFlyingCharacterPhysics(inst, 10, 1)
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
	
	inst.sanityreward = TUNING.SANITY_MEDLARGE
	inst.sounds = sounds
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.SHADOW_ICICLER_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.SHADOW_ICICLER_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.SHADOW_ICICLER_ATTACK_RANGE)
	inst.components.combat:SetRetargetFunction(3, RetargetFn)
	inst.components.combat.onkilledbyother = OnKilledByOther
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(TUNING.SHADOW_ICICLER_HEALTH)
	inst.components.health.nofadeout = true
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.SHADOW_ICICLER_SPEED
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.pathcaps = {allowocean = true, ignorecreep = true}
	
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

local AOE_RANGE = 1
local AOE_RANGE_PADDING = 3
local TARGET_TAGS = {"_combat"}
local TARGET_NOT_TAGS = {"INLIMBO", "flight", "invisible", "notarget", "noattack", "shadow_aligned"}

local function OnHit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, TUNING.SHADOW_ICICLER_SPIKE_RANGE, TARGET_TAGS, TARGET_NOT_TAGS)
	for i, v in ipairs(ents) do
		local attacker = inst.owner and inst.owner:IsValid() and inst.owner or inst
		
		if (attacker.components.shadowsubmissive == nil or not attacker.components.shadowsubmissive:TargetHasDominance(v))
			and (v:HasTag("crazy") or v.components.sanity and v.components.sanity:IsCrazy()) then
			v.components.combat:GetAttacked(attacker, TUNING.SHADOW_ICICLER_DAMAGE)
		end
	end
	
	if inst._shadowtask then
		inst._shadowtask:Cancel()
		inst._shadowtask = nil
	end
	
	inst.shadow:Remove()
	
	inst:ListenForEvent("animover", inst.Remove)
	inst.AnimState:PlayAnimation("spike_pst")
	inst.SoundEmitter:PlaySound("rifts2/thrall_wings/projectile")
end

local function OnLaunch(inst, attacker)
	inst.owner = attacker
end

local function UpdateShadow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local scale = Lerp(2, 0.3, y / 20)
	
	if inst.shadow == nil then
		inst.shadow = SpawnPrefab("warningshadow")
	end
	
	inst.shadow.Transform:SetPosition(x, 0, z)
	inst.shadow.AnimState:SetScale(scale, scale)
end

local function spike()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("shadow_polar_spikes")
	inst.AnimState:SetBuild("shadow_polar_spikes")
	inst.AnimState:PlayAnimation("spike_pre")
	inst.AnimState:PushAnimation("spike_loop", true)
	
	inst:AddTag("FX")
	inst:AddTag("shadow_aligned")
	inst:AddTag("projectile")
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("transparentonsanity")
		inst.components.transparentonsanity:ForceUpdate()
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("complexprojectile")
	inst.components.complexprojectile:SetHorizontalSpeed(15)
	inst.components.complexprojectile:SetGravity(-35)
	inst.components.complexprojectile:SetLaunchOffset(Vector3(0.25, 3, 0))
	inst.components.complexprojectile:SetOnLaunch(OnLaunch)
	inst.components.complexprojectile:SetOnHit(OnHit)
	
	inst.UpdateShadow = UpdateShadow
	
	inst.persists = false
	
	inst._shadowtask = inst:DoPeriodicTask(FRAMES, inst.UpdateShadow)
	
	return inst
end

return Prefab("shadow_icicler", fn, assets),
	Prefab("shadow_icicler_spike", spike, assets)