local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local states = {
	State{
		name = "attack_throne",
		tags = {"attack", "weapontoss"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("steal_pre")
			inst.AnimState:PushAnimation("steal", false)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growllong")
			inst.Physics:Stop()
			
			inst.sg.statemem.hitrange = inst.components.combat.hitrange
			inst.components.combat.hitrange = inst.sg.statemem.hitrange * TUNING.THRONE_KRAMPUS_RANGE_MULT
			inst.components.combat:StartAttack()
		end,
		
		timeline = {
			TimeEvent(18 * FRAMES, function(inst)
				inst:PerformBufferedAction()
				
				inst.components.combat:DoAttack()
				inst.components.combat.hitrange = inst.sg.statemem.hitrange
			end),
			TimeEvent(14 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_swing")
			end),
		},
		
		events = {
			EventHandler("animqueueover", function(inst)
				if inst.components.teamattacker and inst.components.teamattacker.inteam then
					inst.components.teamattacker.orders = ORDERS.HOLD
				end
				
				inst.sg:GoToState("idle")
			end),
		},
	},
	
	State{
		name = "throne_gift_exit",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("throne_gift_exit")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/bag_dissappear")
			inst.Transform:SetRotation(math.random() * 360)
		end,
		
		timeline = {
			TimeEvent(15 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growllong")
				inst.Physics:Stop()
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState(math.random() <= 0.5 and "taunt" or "idle")
			end),
		},
	}
}

ENV.AddStategraphPostInit("krampus", function(sg)
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	--
	
	local olddoattack_event = sg.events["doattack"].fn
	sg.events["doattack"].fn = function(inst, data)
		if inst:HasTag("thronekrampus") and not (inst.components.health and inst.components.health:IsDead())
			and (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then
			
			inst.sg:GoToState("attack_throne")
		elseif olddoattack_event then
			olddoattack_event(inst, data)
		end
	end
	
	local oldidle_enter = sg.states["idle"].onenter
	sg.states["idle"].onenter = function(inst, data)
		if inst:HasTag("thronekrampus") and inst.wants_to_exit_throne then
			inst.sg:GoToState("exit")
		else
			oldidle_enter(inst, data)
		end
	end
end)