local assets = {
	Asset("ANIM", "anim/penguin_emperor.zip"),
	Asset("ANIM", "anim/penguin.zip"),
	
	Asset("ANIM", "anim/penguin_emperor_anims.zip"),
	Asset("ANIM", "anim/penguin_polar_anims.zip"),
}

local prefabs = {
	"emperor_egg",
	"pondfish",
}

SetSharedLootTable("emperor_penguin", {
	{"emperor_egg", 			1},
	{"feather_crow", 			1},
	{"feather_crow", 			0.5},
	{"feather_crow", 			0.5},
	{"feather_crow", 			0.5},
	{"feather_crow", 			0.5},
	{"feather_robin_winter", 	1},
	{"feather_robin_winter", 	0.5},
	{"feather_robin_winter", 	0.5},
	{"feather_robin_winter", 	0.5},
	{"feather_robin_winter", 	0.5},
	{"gnarwail_horn", 			0.8},
	{"pondfish", 				1},
})

local brain = require("brains/emperor_penguinbrain")

local function KeepTarget(inst, target)
	if TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated then
		return false
	elseif inst.components.combat.lastwasattackedbytargettime + 5 >= GetTime() then
		return true
	elseif not target:HasTag("character") then
		return false
	end
	
	return true
end

local function RetargetFn(inst)
	if inst:HasTag("hostile") and TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.emperor == inst then
		local targets = {}
		for i, player in ipairs(AllPlayers) do
			if TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(player) then
				table.insert(targets, player)
			end
		end
		
		return #targets > 0 and targets[math.random(#targets)] or nil
	end
end

local function EnterJuggleTrigger(inst)
	inst.wants_to_call_guards = true
	inst.wants_to_juggle = true
end

local function CallGuards(inst)
	inst.wants_to_call_guards = true
end

--	TODO: Change targetting mode to stay hostile as long as entity is awake. Combat starts when a credible source attacked emperor or castle (players, followers, explosives...)

local function GetStatus(inst)
	local target = inst.components.combat and inst.components.combat.target
	
	if target and not target:HasTag("hostile") then
		return "HOSTILE"
	end
end

local function ShouldSleep(inst)
	return false
end

local function ShouldWake(inst)
	return true
end

local function TeleportOverrideFn(inst)
	local ipos = inst:GetPosition()
	local offset = FindWalkableOffset(ipos, TWOPI * math.random(), 8, 8, true, false)
		or FindWalkableOffset(ipos, TWOPI * math.random(), 12, 8, true, false)
	
	return (offset and ipos + offset) or ipos
end

local function MakeDefeated(inst, fromload)
	TheWorld:PushEvent("emperorpenguin_defeated", {emperor = inst})
	
	inst:AddTag("notarget")
	if inst.components.combat then
		inst.components.combat:SetTarget(nil)
	end
	if inst.components.drownable then
		inst.components.drownable.enabled = false
	end
	if inst.components.lootdropper and not fromload then
		inst.components.lootdropper:DropLoot()
	end
	
	local pt = inst:GetPosition()
	for ID, data in pairs(inst.attackerUSERIDs) do
		for i, player in ipairs(AllPlayers) do
			if player.userid == ID and player:GetDistanceSqToPoint(pt:Get()) < TUNING.EMPEROR_PENGUIN_CASTLE_RANGE * 3 then
				player.emperordefeat_task = player:DoTaskInTime(2 + math.random() * 2, function()
					player:PushEvent("defeated_emperorpenguin")
					player.emperordefeat_task = nil
				end)
				
				break
			end
		end
	end
end

local function OnEntitySleep(inst)
	if inst.sg == nil or inst.sg.statemem.exiting_tower then
		return
	end
	
	inst.wants_to_call_guards = nil
	inst.wants_to_juggle = nil
	inst.wants_to_spin = nil
	
	local castle_pos = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.ice_castle_pos
	if castle_pos and TheWorld.components.emperorpenguinspawner.emperor == inst then
		inst.Transform:SetPosition(castle_pos:Get())
		
		if inst._juggle_tower then
			inst.sg:GoToState("emperor_entertower", true)
		end
		inst.sg:GoToState("idle")
	end
	
	if inst.components.combat then
		inst.components.combat:SetTarget(nil)
	end
	
	-- Emperor will regenerate one phase of health when quiting combat, so we repeat the last triggers where fight was abandonned
	if inst.components.health and not inst.healthphase_regenlock then
		local health_percent = inst.components.health and inst.components.health:GetPercent() or 1
		local health_phase = 0
		
		for i = 1, #TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT do
			if health_percent <= TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[i] then
				health_phase = health_phase + 1
			end
		end
		
		inst.healthphase_regenlock = health_phase > 1
		if inst.healthphase_regenlock then
			inst.components.health:SetPercent(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[health_phase - 1])
		end
	end
end

local function WakeUp(inst)
	if inst.brain == nil then -- Idk why but he spawned without the brain once... and sometime he would be idle for life... now I'm scared
		inst:SetBrain(brain)
	end
	if inst.sg and not inst.sg.statemem.exiting_tower then
		inst.sg:GoToState("summon_guards", true)
	end
end

local function OnEntityWake(inst)
	WakeUp(inst)
end

local function OnSave(inst, data)
	data.attackerUSERIDs = inst.attackerUSERIDs or nil
	data.defeated = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated
	data.callguards = inst.wants_to_call_guards
	data.gojuggle = inst.wants_to_juggle
	data.healthphase_regenlock = inst.healthphase_regenlock
end

local function OnLoad(inst, data)
	if data then
		inst.attackerUSERIDs = data.attackerUSERIDs or inst.attackerUSERIDs
		inst.wants_to_call_guards = data.callguards
		inst.wants_to_juggle = data.gojuggle
		inst.healthphase_regenlock = data.healthphase_regenlock
		
		if data.defeated then
			inst:MakeDefeated(true)
		elseif next(inst.attackerUSERIDs) then
			inst:AddTag("hostile")
		end
	end
end

local function PushMusic(inst)
	if ThePlayer == nil or not inst:HasTag("hostile") then
		inst._playingmusic = false
	else
		local is_near = ThePlayer:IsNear(inst, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE * (inst._playingmusic and 2 or 1))
		inst._playingmusic = is_near
		
		if is_near and not (TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated) then
			ThePlayer:PushEvent("triggeredevent", {name = "emperor_penguin"})
		end
	end
end

local function DoExtraEgg(inst)
	local egg = inst.eggprefab and inst.components.lootdropper and inst.components.lootdropper:SpawnLootPrefab(inst.eggprefab)
	inst._extraegg = nil
	
	return egg
end

local function CanShareTarget(dude)
	return dude:HasTag("penguin")
end

local function OnAttacked(inst, data)
	local attacker = data and data.attacker
	
	if attacker then
		if attacker:HasTag("player") then
			inst.attackerUSERIDs[data.attacker.userid] = true
		end
		
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, 16, CanShareTarget, 100)
	end
	
	inst.healthphase_regenlock = nil
end

local function OnCombatTargetChange(inst, data)
	if data and data.target then
		local spawner = TheWorld.components.emperorpenguinspawner
		local t = GetTime()
		
		if data.oldtarget == nil and inst.sg and not inst:HasTag("busy") and (inst._lasttaunt == nil or t - inst._lasttaunt > 8)
			and spawner and spawner.emperor == inst and spawner:IsInstInsideCastle(data.target) then
			
			inst._lasttaunt = t
			inst.sg:GoToState("taunt")
		end
		
		if inst.components.timer and not inst.components.timer:TimerExists("spincooldown") then
			inst.components.timer:StartTimer("spincooldown", TUNING.EMPEROR_PENGUIN_SPIN_COOLDOWN)
		end
		
		inst:AddTag("hostile")
	end
end

local function OnTeleported(inst)
	if inst.entity:GetParent() == inst._juggle_tower and inst._juggle_tower ~= nil then
		inst.entity:SetParent(nil)
		if inst.Follower then
			inst.Follower:StopFollowing()
		end
		
		inst._tower_exit_pos = nil
	end
end

local function OnMinHealth(inst)
	if not POPULATING and not (TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated) then
		inst:MakeDefeated()
	end
end

local function OnDefeated(inst, data)
	if inst._extraegg == nil then
		inst._extraegg = inst:DoTaskInTime(2 + math.random() * 6, inst.DoExtraEgg)
	end
end

local function OnTimerDone(inst, data)
	if data then
		if data.name == "spincooldown" then
			inst.wants_to_spin = true
		elseif data.name == "keepspinning" then
			inst.wants_to_spin = nil
		end
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeGiantCharacterPhysics(inst, 500, 0.75)
	
	inst.DynamicShadow:SetSize(2, 1.1)
	
	inst.emperor_scale = 1.4
	inst.Transform:SetScale(inst.emperor_scale, inst.emperor_scale, inst.emperor_scale)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("penguin")
	inst.AnimState:SetBuild("penguin_emperor")
	inst.AnimState:OverrideSymbol("swap_snowball", "snowball", "swap_object")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetFinalOffset(4) -- For towers
	
	inst:AddTag("animal")
	inst:AddTag("epic")
	inst:AddTag("largecreature")
	inst:AddTag("penguin")
	inst:AddTag("penguin_emperor")
	inst:AddTag("scarytoprey")
	
	if not TheNet:IsDedicated() then
		inst._playingmusic = false
		inst:DoPeriodicTask(1, PushMusic, 0)
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.attackerUSERIDs = {}
	inst._soundpath = "dontstarve/creatures/pengull/" -- TEMP
	
	inst:AddComponent("combat")
	inst.components.combat.battlecryenabled = false
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetRetargetFunction(1, RetargetFn)
	inst.components.combat:SetDefaultDamage(TUNING.EMPEROR_PENGUIN_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.EMPEROR_PENGUIN_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.EMPEROR_PENGUIN_ATTACK_DIST)
	
	inst:AddComponent("explosiveresist")
	
	inst:AddComponent("drownable")
	
	inst:AddComponent("health")
	inst.components.health:SetMinHealth(1)
	inst.components.health:SetMaxHealth(TUNING.EMPEROR_PENGUIN_HEALTH)
	
	inst:AddComponent("healthtrigger")
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[2], CallGuards)
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[3], EnterJuggleTrigger)
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[4], CallGuards)
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[5], EnterJuggleTrigger)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.EMPEROR_PENGUIN_WALK_SPEED
	inst.components.locomotor.runspeed = TUNING.EMPEROR_PENGUIN_RUN_SPEED
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("emperor_penguin")
	
	inst:AddComponent("knownlocations")
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(6)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWake)
	inst.components.sleeper.diminishingreturns = true
	
	inst:AddComponent("stuckdetection")
	inst.components.stuckdetection:SetTimeToStuck(2)
	
	inst:AddComponent("teleportedoverride")
	inst.components.teleportedoverride:SetDestPositionFn(TeleportOverrideFn)
	
	inst:AddComponent("timer")
	
	MakeSmallBurnableCharacter(inst, "body")
	
	MakeMediumFreezableCharacter(inst, "body")
	inst.components.freezable:SetResistance(50)
	inst.components.freezable:SetDefaultWearOffTime(1)
	
	inst.eggsLayed = 0
	inst.eggprefab = "emperor_egg"
	inst.MakeDefeated = MakeDefeated
	inst.DoExtraEgg = DoExtraEgg
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst._ondefeated = function(src, data)
		if not inst:IsAsleep() then
			OnDefeated(inst, data)
		end
    end
	
	inst:SetStateGraph("SGpenguin")
	inst:SetBrain(brain)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("emperorpenguin_defeated", inst._ondefeated, TheWorld)
	inst:ListenForEvent("losttarget", OnCombatTargetChange)
	inst:ListenForEvent("minhealth", OnMinHealth)
	inst:ListenForEvent("newcombattarget", OnCombatTargetChange)
	inst:ListenForEvent("teleported", OnTeleported)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	inst:DoTaskInTime(0.1, WakeUp)
	
	return inst
end

return Prefab("emperor_penguin", fn, assets, prefabs)