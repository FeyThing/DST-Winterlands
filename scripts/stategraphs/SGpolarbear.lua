require("stategraphs/commonstates")

local actionhandlers = {
	ActionHandler(ACTIONS.ADDFUEL, "pickup"),
	ActionHandler(ACTIONS.DROP, "dropitem"),
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.EQUIP, "pickup"),
	ActionHandler(ACTIONS.GOHOME, "gohome"),
	ActionHandler(ACTIONS.PICKUP, "pickup"),
	ActionHandler(ACTIONS.TAKEITEM, "pickup"),
	ActionHandler(ACTIONS.UNPIN, "pickup"),
}

local events = {
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true, true),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttack(),
	CommonHandlers.OnAttacked(nil, TUNING.PIG_MAX_STUN_LOCKS),
	CommonHandlers.OnDeath(),
	CommonHandlers.OnHop(),
	CommonHandlers.OnSink(),
	CommonHandlers.OnFallInVoid(),
	CommonHandlers.OnIpecacPoop(),
}

local states = {
	State{
		name = "funnyidle",
		tags = {"idle"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.SoundEmitter:PlaySound("dontstarve/pig/oink")
			
			if inst.components.follower:GetLeader() and inst.components.follower:GetLoyaltyPercent() < 0.05 then
				inst.AnimState:PlayAnimation("hungry")
				inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")
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
		name = "death",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			
			RemovePhysicsColliders(inst)
			inst.components.lootdropper:DropLoot(inst:GetPosition())
		end,
	},
	
	State{
		name = "abandon",
		tags = {"busy"},
		
		onenter = function(inst, leader)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("abandon")
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
		name = "attack",
		tags = {"attack", "busy"},
		
		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/pig/attack")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
		end,
		
		timeline = {
			TimeEvent(13 * FRAMES, function(inst)
				inst.components.combat:DoAttack()
				inst.sg:RemoveStateTag("attack")
				inst.sg:RemoveStateTag("busy")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "eat",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat")
		end,
		
		timeline = {
			TimeEvent(10 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
			TimeEvent(2*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/eat") end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") end),
			TimeEvent(21*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/beefalo/chew") end),
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
			inst.SoundEmitter:PlaySound("dontstarve/pig/oink")
			inst.AnimState:PlayAnimation("hit")
			inst.Physics:Stop()
			CommonHandlers.UpdateHitRecoveryDelay(inst)
		end,
		
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
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("pig_pickup")
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
		name = "cheer",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("buff")
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
		TimeEvent(35 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/sleep") end),
	},
})

CommonStates.AddIdle(states, "funnyidle")
CommonStates.AddSimpleState(states, "refuse", "pig_reject", {"busy"})
CommonStates.AddFrozenStates(states)
CommonStates.AddSimpleActionState(states, "pickup", "pig_pickup", 10 * FRAMES, {"busy"})
CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4 * FRAMES, {"busy"})
CommonStates.AddHopStates(states, true, {pre = "boat_jump_pre", loop = "boat_jump_loop", pst = "boat_jump_pst"})
CommonStates.AddSinkAndWashAshoreStates(states)
CommonStates.AddVoidFallStates(states)
CommonStates.AddIpecacPoopState(states)

return StateGraph("polarbear", states, events, "idle", actionhandlers)