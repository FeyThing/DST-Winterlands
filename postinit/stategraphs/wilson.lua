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
	
	State{
		name = "polarspawn",
		tags = {"busy", "noattack", "nopredict", "nodangle"},
		
		onenter = function(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
			
			inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
			inst.AnimState:PlayAnimation("frozen")
			
			inst.components.inventory:Hide()
			inst:PushEvent("ms_closepopups")
			if inst.components.playercontroller then
				inst.components.playercontroller:EnableMapControls(false)
			end
		end,
		
		timeline = {
			TimeEvent(3, function(inst)
				inst.AnimState:PlayAnimation("frozen_loop_pst", true)
				inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
			end),
			TimeEvent(5.5, function(inst)
				if inst.components.freezable then
					inst.components.freezable:SpawnShatterFX()
				end
				inst.sg:GoToState("hit", true)
			end)
		},
		
		onexit = function(inst)
			inst.AnimState:ClearOverrideSymbol("swap_frozen")
			inst.SoundEmitter:KillSound("thawing")
			
			inst.components.inventory:Show()
			if inst.components.playercontroller then
				inst.components.playercontroller:EnableMapControls(true)
			end
		end
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
			return (inst.components.rider and inst.components.rider:IsRiding()) and "quickcastspell" or "polarcast"
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
			return (inst.replica.rider and inst.replica.rider:IsRiding()) and "quickcastspell" or "polarcast"
		end
		
		return old_CASTSPELL_fn(inst, action, ...)
	end
end)