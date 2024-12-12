local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local events = {
	EventHandler("gotpolarflea", function(inst)
		inst.sg:GoToState("hit")
	end),
}

local states = {
	State{
		name = "polarcast",
		tags = {"doing", "busy", "canrotate"},
		
		onenter = function(inst)
			if inst.components.playercontroller then
				inst.components.playercontroller:Enable(false)
			end
			
			inst.AnimState:PlayAnimation("polarcast")
			inst.components.locomotor:Stop()
		end,
		
		timeline = {
			TimeEvent(13 * FRAMES, function(inst)
				inst:PerformBufferedAction()
			end),
			TimeEvent(20 * FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
				if inst.components.playercontroller then
					inst.components.playercontroller:Enable(true)
				end
			end)
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		},
		
		onexit = function(inst)
			if inst.components.playercontroller then
				inst.components.playercontroller:Enable(true)
			end
		end
	},
	
	State{
		name = "start_polarnecklace",
		tags = {"doing", "nodangle"},
		
		onenter = function(inst, resume_item)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("build_pre")
			inst.AnimState:PushAnimation("build_loop")
			inst.SoundEmitter:PlaySound("dontstarve/wilson/make_trap", "make")
		end,
		
		onexit = function(inst)
			inst.SoundEmitter:KillSound("make")
		end,
		
		events = {
			EventHandler("animqueueover", function(inst)
				inst.sg:GoToState("idle")
			end),
			EventHandler("finish_polarnecklace", function(inst)
				inst.AnimState:PlayAnimation("build_pst")
				inst.SoundEmitter:KillSound("make")
			end),
		},
	},
}

ENV.AddStategraphPostInit("wilson", function(sg)
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	for _, event in pairs(events) do
		sg.events[event.name] = event
	end
	
	--	actions
	
	local old_CASTSPELL_fn = sg.actionhandlers[ACTIONS.CASTSPELL].deststate
	sg.actionhandlers[ACTIONS.CASTSPELL].deststate = function(inst, action, ...)
		if action.invobject and action.invobject:HasTag("polarstaff") then
			return "polarcast"
		end
		
		return old_CASTSPELL_fn(inst, action, ...)
	end
	
	--	states
	
	local oldattack = sg.states["attack"].onenter
	sg.states["attack"].onenter = function(inst, ...)
		oldattack(inst, ...)
		
		local equip = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if equip and equip:HasTag("antlerstick") then
			 inst.SoundEmitter:PlaySound("polarsounds/antler_tree/swoop", nil, nil, true)
		end
	end
end)

--

local states_client = {
	State{
		name = "polarcast",
		tags = {"doing", "busy", "canrotate"},
		server_states = {"polarcast"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst.AnimState:PlayAnimation("polarcast")
			
			inst:PerformPreviewBufferedAction()
			inst.sg:SetTimeout(2)
		end,
		
		onupdate = function(inst)
			if inst.sg:ServerStateMatches() then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle")
			end
		end,
		
		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end
	}
}

ENV.AddStategraphPostInit("wilson_client", function(sg)
	for _, state in pairs(states_client) do
		sg.states[state.name] = state
	end
	
	--	actions
	
	local old_CASTSPELL_fn = sg.actionhandlers[ACTIONS.CASTSPELL].deststate
	sg.actionhandlers[ACTIONS.CASTSPELL].deststate = function(inst, action, ...)
		if action.invobject and action.invobject:HasTag("polarstaff") then
			return "polarcast"
		end
		
		return old_CASTSPELL_fn(inst, action, ...)
	end
end)