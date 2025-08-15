require("stategraphs/commonstates")

local actionhandlers = {
	ActionHandler(ACTIONS.ADDFUEL, "pickup"),
	ActionHandler(ACTIONS.ATTACK, "attack_action"),
	ActionHandler(ACTIONS.DROP, "dropitem"),
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.EQUIP, "pickup"),
	ActionHandler(ACTIONS.GIVE, "give"),
	ActionHandler(ACTIONS.GOHOME, "gohome"),
	ActionHandler(ACTIONS.PICKUP, "pickup"),
	ActionHandler(ACTIONS.STICK_ARCTIC_FISH, "give"),
	ActionHandler(ACTIONS.TAKEITEM, "pickup"),
	ActionHandler(ACTIONS.UNPIN, "pickup"),
	ActionHandler(ACTIONS.POLARPLOW, "use_tool"),
}

local events = {
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true, true),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttacked(nil, TUNING.PIG_MAX_STUN_LOCKS),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnHop(),
	CommonHandlers.OnSink(),
	CommonHandlers.OnFallInVoid(),
	CommonHandlers.OnIpecacPoop(),
	CommonHandlers.OnElectrocute(),
	EventHandler("doattack", function(inst)
		if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
			if inst.enraged and not (inst.components.timer and inst.components.timer:TimerExists("chompcooldown")) then
				inst.sg:GoToState("attack_chomp")
			else
				inst.sg:GoToState("attack")
			end
		end
	end),
}

local BITE_TAGS = {"_combat"}
local BITE_NOT_TAGS = {"wall", "structure", "INLIMBO", "flight", "invisible", "notarget", "noattack"}
local BITE_AVOID_TAGS = {"bear", "bearbuddy"}

local DEFAULT_PAINTING = "blue"

local function SetEnragedHead(inst, enable)
	local colour = inst.body_paint ~= DEFAULT_PAINTING and inst.body_paint or nil
	inst.AnimState:OverrideSymbol("pig_head", "polarbear_build", "pig_head"..(colour and "_"..colour or "")..(enable and "_rage" or ""))
end

local states = {
	State{
		name = "funnyidle",
		tags = {"idle"},
		
		onenter = function(inst)
			inst.SoundEmitter:PlaySound(inst.sounds.talk)
			inst.Physics:Stop()
			
			if inst.components.follower:GetLeader() and inst.components.follower:GetLoyaltyPercent() < 0.05 then
				inst.AnimState:PlayAnimation("hungry")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")
			elseif inst.components.timer and inst.components.timer:TimerExists("arcticfooled_cooldown") then
				inst.AnimState:PlayAnimation("idle_happy")
			elseif inst.components.combat:HasTarget() then
				inst.AnimState:PlayAnimation("idle_angry")
			elseif inst.components.follower:GetLeader() ~= nil and inst.components.follower:GetLoyaltyPercent() > 0.3 then
				inst.AnimState:PlayAnimation("idle_happy")
			else
				inst.AnimState:PlayAnimation("idle_creepy")
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "abandon",
		tags = {"busy"},
		
		onenter = function(inst, leader)
			inst.AnimState:PlayAnimation("abandon")
			inst.Physics:Stop()
			
			if leader and leader:IsValid() then
				inst:FacePoint(leader:GetPosition())
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "tradetooth",
		tags = {"busy", "toothtrading"},
		
		onenter = function(inst)
			inst:SetEnraged(false)
			if inst.components.timer then
				if inst.components.timer:TimerExists("pause_chatty") then
					inst.components.timer:SetTimeLeft("pause_chatty", 5)
				else
					inst.components.timer:StartTimer("pause_chatty", 5)
				end
			end
			
			inst.AnimState:PlayAnimation("bearadmire")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "attack",
		tags = {"attack", "busy"},
		
		onenter = function(inst, rescue_target)
			SetEnragedHead(inst, false)
			
			inst.AnimState:PlayAnimation("atk")
			inst.SoundEmitter:PlaySound(inst.sounds.attack)
			inst.Physics:Stop()
			
			inst.sg.statemem.rescue_target = rescue_target
			inst.components.combat:StartAttack()
		end,
		
		onexit = function(inst)
			SetEnragedHead(inst, inst.enraged)
		end,
		
		timeline = {
			TimeEvent(4 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
			end),
			TimeEvent(13 * FRAMES, function(inst)
				local rescue_target = inst.sg.statemem.rescue_target
				if rescue_target then
					if rescue_target:IsValid() and rescue_target.components.freezable then
						rescue_target.components.freezable:Unfreeze()
					end
					inst:ClearBufferedAction()
				else
					inst.components.combat:DoAttack()
				end
				inst.sg:RemoveStateTag("attack")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "attack_chomp",
		tags = {"attack", "busy", "canrotate", "chomp"},
		
		onenter = function(inst)
			SetEnragedHead(inst, false)
			
			inst.AnimState:PlayAnimation("bearchomp")
			inst.SoundEmitter:PlaySound(inst.sounds.bite)
			inst.SoundEmitter:KillSound("growl")
			inst.Physics:Stop()
			
			--inst.components.combat:StartAttack()
			if inst.components.timer then
				inst.components.timer:StartTimer("chompcooldown", TUNING.POLARBEAR_BITE_PERIOD)
			end
		end,
		
		onexit = function(inst)
			SetEnragedHead(inst, inst.enraged)
		end,
		
		timeline = {
			TimeEvent(5 * FRAMES, function(inst)
				local target = inst.components.combat.target
				
				if target and target:IsValid() then
					inst.Transform:SetRotation(inst:GetAngleToPoint(target.Transform:GetWorldPosition()))
				end
			end),
			TimeEvent(20 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
				inst.Physics:SetMotorVel(TUNING.POLARBEAR_BITE_VEL, 0, 0)
			end),
			TimeEvent(22 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound(inst.sounds.bite_snap)
				
				inst.sg.statemem.chomptargets = {}
			end),
			TimeEvent(30 * FRAMES, function(inst)
				inst.Physics:Stop()
				inst.sg:RemoveStateTag("attack")
				
				inst.sg.statemem.chomptargets = nil
			end),
		},
		
		onupdate = function(inst)
			if inst.sg.statemem.chomptargets then
				local x, y, z = inst.Transform:GetWorldPosition()
				local angle = inst.Transform:GetRotation()
				
				local theta = angle * DEGREES
				local cos_theta = math.cos(theta)
				local sin_theta = math.sin(theta)
				
				x = x + TUNING.POLARBEAR_BITE_RANGE * cos_theta
				z = z - TUNING.POLARBEAR_BITE_RANGE * sin_theta
				
				local not_tags = deepcopy(BITE_NOT_TAGS)
				local target = inst.components.combat.target
				
				for i, tag in ipairs(BITE_AVOID_TAGS) do
					if target == nil or (target:IsValid() and not target:HasTag(tag)) then
						table.insert(not_tags, tag)
					end
				end
				
				local ents = TheSim:FindEntities(x, y, z, TUNING.POLARBEAR_BITE_RANGE * 0.8, nil, not_tags, BITE_TAGS)
				for i, v in ipairs(ents) do
					if not inst.sg.statemem.chomptargets[v] and v.components.combat and v.components.health and not v.components.health:IsDead() then
						v.components.combat:GetAttacked(inst, TUNING.POLARBEAR_DAMAGE_BITE)
						inst.sg.statemem.chomptargets[v] = true
					end
				end
			end
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "attack_action",
		
		onenter = function(inst)
			local ba = inst:GetBufferedAction()
			local leader = inst.components.follower and inst.components.follower.leader
			local rescue_target = (ba.target and leader and ba.target == leader and leader.components.freezable and leader.components.freezable:IsFrozen()) and leader or nil
			
			inst.sg:GoToState("attack", rescue_target)
		end,
	},
	
	State{
		name = "eat",
		tags = {"busy"},
		
		onenter = function(inst)
			inst:SetEnraged(false) -- yum, calm...
			
			inst.AnimState:PlayAnimation("eat")
			inst.SoundEmitter:PlaySound(inst.sounds.eat)
			inst.Physics:Stop()
		end,
		
		onexit = function(inst)
			inst.SoundEmitter:KillSound("chewing")
		end,
		
		timeline = {
			TimeEvent(2 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.chew, "chewing") end),
			TimeEvent(10 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "hit",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("hit")
			inst.SoundEmitter:PlaySoundWithParams(inst.sounds.hit, {health = inst.components.health and inst.components.health:GetPercent() or 1})
			inst.SoundEmitter:KillSound("growl")
			inst.Physics:Stop()
			
			CommonHandlers.UpdateHitRecoveryDelay(inst)
		end,
		
		events = {
			EventHandler("animover", function(inst)
				if inst._arctic_fooling_around then
					inst.sg:GoToState("disapproval")
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},
	
	State{
		name = "death",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("death")
			inst.SoundEmitter:PlaySound(inst.sounds.death)
			inst.SoundEmitter:KillSound("growl")
			inst.Physics:Stop()
			
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(inst:GetPosition())
		end,
	},
	
	State{
		name = "give",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("pig_take")
			inst.Physics:Stop()
		end,
		
		timeline = {
			TimeEvent(13 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "dropitem",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("pig_pickup")
			inst.Physics:Stop()
		end,
		
		timeline = {
			TimeEvent(10 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "use_tool",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("work")
			inst.Physics:Stop()
		end,
		
		timeline = {
			TimeEvent(14 * FRAMES, function(inst)
				local act = inst:GetBufferedAction()
				local target = act.target
				local tool = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
				
				if tool and target and target:IsValid() and target.components.workable and target.components.workable:CanBeWorked() then
					target.components.workable:WorkedBy(inst, tool.components.tool:GetEffectiveness(act.action))
					tool:OnUsedAsItem(act.action, inst, target)
				end
				
				if target and act.action == ACTIONS.MINE then
					PlayMiningFX(inst, target)
				elseif act.action == ACTIONS.DIG or act.action == ACTIONS.TILL or act.action == ACTIONS.POLARPLOW then
					inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
				end
				
				inst:PerformBufferedAction()
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "cheer",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("buff")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "disapproval",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle_scared")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
}

CommonStates.AddWalkStates(states, {
	walktimeline = {
		TimeEvent(0, PlayFootstep),
		TimeEvent(12 * FRAMES, PlayFootstep),
	},
})

CommonStates.AddRunStates(states, {
	runtimeline = {
		TimeEvent(0, PlayFootstep),
		TimeEvent(10 * FRAMES, PlayFootstep),
	},
})

CommonStates.AddSleepStates(states, {
	sleeptimeline = {
		TimeEvent(4 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.growl, nil, 0.15) end),
	},
	waketimeline = {
		TimeEvent(3 * FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.talk) end),
	},
})

CommonStates.AddIdle(states, "funnyidle", nil, {
	TimeEvent(0, function(inst)
		SetEnragedHead(inst, inst.enraged)
	end),
})
CommonStates.AddSimpleState(states, "refuse", "pig_reject", {"busy"})
CommonStates.AddFrozenStates(states)
CommonStates.AddSimpleActionState(states, "pickup", "pig_pickup", 10 * FRAMES, {"busy"})
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4 * FRAMES, {"busy"})
CommonStates.AddHopStates(states, true, {pre = "boat_jump_pre", loop = "boat_jump_loop", pst = "boat_jump_pst"})
CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)
CommonStates.AddIpecacPoopState(states)
CommonStates.AddElectrocuteStates(states)

return StateGraph("polarbear", states, events, "idle", actionhandlers)