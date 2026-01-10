local assets = {
	Asset("ANIM", "anim/penguin_emperor.zip"),
	Asset("ANIM", "anim/penguin.zip"),
	
	Asset("ANIM", "anim/penguin_polar_anims.zip"),
}

local prefabs = {
	"compass_polar",
	"emperor_egg",
	"pondfish",
	"winter_ornament_boss_emperor_penguin",
}

SetSharedLootTable("emperor_penguin", {
	{"compass_polar", 			1},
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

local HOSTILE_TAGS = {"hostile", "monster"}
local HOSTILE_NOT_TAGS = {"INLIMBO", "isdead", "player", "penguin_emperor"}

local function RetargetFn(inst)
	local targets = {}
	local target
	
	if inst:HasTag("hostile") and TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.emperor == inst then
		for ID, data in pairs(inst.attackerUSERIDs) do
			for i, player in ipairs(AllPlayers) do
				if player:IsValid() and player.userid == ID and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(player) then
					table.insert(targets, player)
				end
			end
		end
		
		target = #targets > 0 and targets[math.random(#targets)] or nil
		
		if target then
			return target
		else
			target = FindEntity(inst, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE, function(guy)
				return guy.components.combat and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(guy)
			end, nil, HOSTILE_NOT_TAGS, HOSTILE_TAGS)
		end
	end
	
	return target
end

local function ForceQuitTowerState(inst) -- This is to be called when leaving tower unconventionally (when tower state onexit won't run)
	inst:ClearBufferedAction()
	inst:Show()
	if inst.DynamicShadow then
		inst.DynamicShadow:Enable(true)
	end
	
	inst.entity:SetParent(nil)
	if inst.Follower then
		inst.Follower:StopFollowing()
	end
	
	if inst._juggle_tower then
		if inst._juggle_tower.tower_emperor then
			inst._juggle_tower.tower_emperor:set(nil)
		end
		if inst.emperor_tower then
			inst.emperor_tower:set(nil)
		end
		if inst._juggle_tower.components.locomotor then
			inst._juggle_tower:RemoveComponent("locomotor")
		end
		
		if TheWorld.ismastersim then
			if inst._juggle_tower.components.highlightchild then
				inst._juggle_tower.components.highlightchild:SetOwner(nil)
			end
			if inst.components.highlightchild then
				inst.components.highlightchild:SetOwner(nil)
			end
		end
	end
	
	inst._juggle_tower = nil
	inst._tower_exit_pos = nil
	inst.wants_to_juggle = nil
	inst.Physics:SetActive(true)
end

local function CallGuards(inst, phase)
	if inst.healthtrigger_phase and phase and phase <= inst.healthtrigger_phase then
		return
	end
	
	inst.wants_to_call_guards = true
	inst.healthphase_regenlock = nil
	
	inst.healthtrigger_phase = phase or inst.healthtrigger_phase
end

local function EnterJuggleTrigger(inst, phase)
	if inst.healthtrigger_phase and phase and phase <= inst.healthtrigger_phase then
		return
	end
	
	inst.wants_to_call_guards = true
	inst.wants_to_juggle = true
	inst.healthphase_regenlock = nil
	
	inst.healthtrigger_phase = phase or inst.healthtrigger_phase
end

local function GetStatus(inst)
	return inst:HasTag("hostile") and "HOSTILE" or nil
end

local function ShouldSleep(inst)
	return false
end

local function ShouldWake(inst)
	return true
end

local function TeleportOverrideFn(inst)
	local ipos = inst:GetPosition()
	ipos.y = 0
	
	local offset = FindWalkableOffset(ipos, TWOPI * math.random(), 8, 8, true, false)
		or FindWalkableOffset(ipos, TWOPI * math.random(), 12, 8, true, false)
	
	return (offset and ipos + offset) or ipos
end

local function MakeDefeated(inst, fromload, noegg)
	TheWorld:PushEvent("emperorpenguin_defeated", {emperor = inst, noegg = noegg})
	
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

-- There's some weird ***jank that happens with the boss where both brain and components will not properly wake up from unloading, or being removed from scene,
-- this will need some research at some point to figure why it happens at all, but atm we make do...

local function WakeUp(inst)
	if not inst:IsAsleep() and not inst:HasTag("INLIMBO") then
		local wakeup = inst._braindisabled or (inst.components.combat and inst.components.combat.retargettask == nil and inst.components.combat.targetfn)
		
		if wakeup then
			OnEntityWake(inst.GUID)
		end
	end
end

local function OnEntityWake(inst)
	if TheWorld.components.emperorpenguinspawner and not TheWorld.components.emperorpenguinspawner.defeated
		and inst:GetTimeAlive() > 2 then -- First time is called from spawnercomponent
		
		if inst.sg and not inst.sg.statemem.exiting_tower then
			inst.sg:GoToState("summon_guards", true)
		end
	end
end

local function OnEntitySleep(inst)
	local castle_pos = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.ice_castle_pos
	if castle_pos and TheWorld.components.emperorpenguinspawner.emperor == inst then
		inst:ForceQuitTowerState()
		
		inst.sg:GoToState("idle")
		
		inst.Transform:SetPosition(castle_pos:Get())
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

--	NOTE: Save and load mainly occurs from spawner, emperor cannot be saved while parented to a tower, causing it to despawn
--	this here is just for when he's defeated or manually spawned

local function OnSave(inst, data)
	data.attackerUSERIDs = inst.attackerUSERIDs or nil
	data.defeated = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated
	data.callguards = inst.wants_to_call_guards
	data.gojuggle = inst.wants_to_juggle
	data.healthphase_regenlock = inst.healthphase_regenlock
	data.healthtrigger_cutdmg = inst.healthtrigger_cutdmg
	data.healthtrigger_phase = inst.healthtrigger_phase
	data.snd_egg_dropped = inst._extraegg == nil
end

local function OnLoad(inst, data)
	if data then
		inst.attackerUSERIDs = data.attackerUSERIDs or inst.attackerUSERIDs
		inst.wants_to_call_guards = data.callguards
		inst.wants_to_juggle = data.gojuggle
		
		inst.healthphase_regenlock = data.healthphase_regenlock
		inst.healthtrigger_cutdmg = data.healthtrigger_cutdmg
		inst.healthtrigger_phase = data.healthtrigger_phase
		
		if data.defeated then
			inst:MakeDefeated(true, data.snd_egg_dropped)
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

local function TryRipMantle(inst)
	if inst.components.lootdropper and (inst.healthtrigger_cutdmg or 0) >= TUNING.EMPEROR_PENGUIN_HEALTH_CUTDAMAGE then
		local rip = inst.components.lootdropper:SpawnLootPrefab("malbatross_feathered_weave")
		rip.AnimState:SetScale(0.7, 0.7)
		
		inst.SoundEmitter:PlaySound("polarsounds/emperor_penguin/rip_mantle")
		inst.healthtrigger_cutdmg = 0
	end
end

local function DoExtraEgg(inst)
	local egg = inst.eggprefab and inst.components.lootdropper and inst.components.lootdropper:SpawnLootPrefab(inst.eggprefab)
	
	-- OnAttacked event may not be pushed on the last hit
	inst:TryRipMantle()
	
	inst._extraegg = nil
	
	return egg
end

local PENGUIN_GUARDS_TAGS = {"penguin_guard"}
local PENGUIN_GUARDS_NOT_TAGS = {"INLIMBO", "isdead"}

local function CanShareTarget(dude)
	return dude:HasTag("penguin")
end

local function OnAttacked(inst, data)
	local attacker = data and data.attacker
	local damage = data and (data.damageresolved or data.damage)
	local weapon = data and data.weapon
	
	inst:TryRipMantle()
	if damage and damage > 0 and weapon and weapon:HasTag("pointy") and weapon:HasTag("sharp") then
		inst.healthtrigger_cutdmg = (inst.healthtrigger_cutdmg or 0) + damage
	end
	
	if attacker then
		local x, y, z = inst.Transform:GetWorldPosition()
		local num_guards = #TheSim:FindEntities(x, y, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE, PENGUIN_GUARDS_TAGS, PENGUIN_GUARDS_NOT_TAGS)
		
		-- We seed some guard if castle is currently helpless
		local need_support = not attacker:HasTag("penguin") and not TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(attacker)
			and num_guards < 1 and TheWorld.components.emperorpenguinspawner._provoke_support == nil
		
		if need_support then
			TheWorld.components.emperorpenguinspawner._provoke_support = TheWorld:DoTaskInTime(0.2 + math.random() * 0.3, function()
				TheWorld.components.emperorpenguinspawner:SpawnGuards(math.random(1, 2))
			end)
		end
		
		if attacker.userid then
			inst:AddTag("hostile")
			inst.attackerUSERIDs[attacker.userid] = true
		elseif attacker.components.follower then
			local leader = attacker.components.follower:GetLeader()
			
			if leader and leader.userid then
				inst:AddTag("hostile")
				inst.attackerUSERIDs[leader.userid] = true
			end
		end
		
		inst.components.combat:SetTarget(attacker)
		inst.components.combat:ShareTarget(attacker, 16, CanShareTarget, 100)
	end
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
		
		if data.target:HasTag("player") then
			inst:AddTag("hostile")
		end
	end
end

local function OnTeleported(inst)
	if not inst.healthphase_regenlock then
		-- Sometimes, teleportation even around castle can cause entity to turn asleep, we don't want regen to occur in these case
		inst.healthphase_regenlock = true
		
		inst:DoTaskInTime(1, function()
			inst.healthphase_regenlock = nil
		end)
	end
	
	if inst.sg and inst.sg:HasStateTag("towered") then
		inst.sg:GoToState("wake")
	end
	
	if inst.entity:GetParent() == inst._juggle_tower and inst._juggle_tower then
		inst:ForceQuitTowerState()
	end
end

local function OnMinHealth(inst)
	if not POPULATING and TheWorld.components.emperorpenguinspawner and not TheWorld.components.emperorpenguinspawner.defeated then
		TheWorld.components.emperorpenguinspawner:SpawnGuards(math.random(5, 10))
		inst:MakeDefeated()
	end
end

local function OnDefeated(inst, data)
	if inst._extraegg == nil and not (data and data.noegg) then
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

local function ClearRecentlyCharged(inst, other)
	inst.recentlycharged[other] = nil
end

local function OnDestroyOther(inst, other)
	if other:IsValid() and other.components.workable and other.components.workable:CanBeWorked() and other:HasTag("wall") and not inst.recentlycharged[other] then
		
		SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
		other.components.workable:Destroy(inst)
		
		if other:IsValid() and other.components.workable and other.components.workable:CanBeWorked() then
			inst.recentlycharged[other] = true
			inst:DoTaskInTime(3, ClearRecentlyCharged, other)
		end
	end
end

local function OnCollide(inst, other)
	if not (inst.sg and inst.sg:HasStateTag("nointerrupt")) and other:IsValid() and other.components.workable and other.components.workable:CanBeWorked()
		and other:HasAnyTag("heavy", "wall") and (not other:HasTag("icecastlepart") or other:HasTag("heavy")) and not inst.recentlycharged[other] then
		
		inst:DoTaskInTime(2 * FRAMES, OnDestroyOther, other)
	end
end

local function SetEmperorTowerDirty(inst)
	local tower = inst.emperor_tower:value()
	
	inst.components.highlightchild:SetOwner(tower)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeGiantCharacterPhysics(inst, 500, 0.5)
	
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
	
	inst:AddComponent("highlightchild")
	
	inst.emperor_tower = net_entity(inst.GUID, "emperor_penguin._tower", "towerdirty")
	
	if not TheNet:IsDedicated() then
		inst._playingmusic = false
		inst:DoPeriodicTask(1, PushMusic, 0)
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.override_combat_fx_size = "small"
	
	inst.attackerUSERIDs = {}
	inst._soundpath = "dontstarve/creatures/pengull/" -- TEMP
	
	inst.recentlycharged = {}
	inst.Physics:SetCollisionCallback(OnCollide)
	
	inst:AddComponent("combat")
	inst.components.combat.battlecryenabled = false
	inst.components.combat.hiteffectsymbol = "body"
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetRetargetFunction(1, RetargetFn)
	inst.components.combat:SetDefaultDamage(TUNING.EMPEROR_PENGUIN_DAMAGE)
	inst.components.combat:SetAttackPeriod(TUNING.EMPEROR_PENGUIN_ATTACK_PERIOD)
	inst.components.combat:SetRange(TUNING.EMPEROR_PENGUIN_ATTACK_DIST)
	
	inst:AddComponent("drownable")
	
	inst:AddComponent("explosiveresist")
	
	inst:AddComponent("health")
	inst.components.health:SetMinHealth(1)
	inst.components.health:SetMaxHealth(TUNING.EMPEROR_PENGUIN_HEALTH)
	
	inst.healthtrigger_phase = 1
	inst.CallGuards = CallGuards
	inst.EnterJuggleTrigger = EnterJuggleTrigger
	
	inst:AddComponent("healthtrigger")
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[2], function(inst) inst:CallGuards(2) end)
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[3], function(inst) inst:EnterJuggleTrigger(3) end)
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[4], function(inst) inst:CallGuards(4) end)
	inst.components.healthtrigger:AddTrigger(TUNING.EMPEROR_PENGUIN_SUMMONS_HEALTH_PERCENT[5], function(inst) inst:EnterJuggleTrigger(5) end)
	
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
	inst.ForceQuitTowerState = ForceQuitTowerState
	inst.DoExtraEgg = DoExtraEgg
	inst.TryRipMantle = TryRipMantle
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
	
	inst._wakeuptask = inst:DoPeriodicTask(0.5, WakeUp)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("emperorpenguin_defeated", inst._ondefeated, TheWorld)
	inst:ListenForEvent("losttarget", OnCombatTargetChange)
	inst:ListenForEvent("minhealth", OnMinHealth)
	inst:ListenForEvent("newcombattarget", OnCombatTargetChange)
	inst:ListenForEvent("teleported", OnTeleported)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

return Prefab("emperor_penguin", fn, assets, prefabs)