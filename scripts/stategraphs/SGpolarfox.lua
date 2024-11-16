require("stategraphs/commonstates")

local actionhandlers = {
	
}

local events = {
	
}

local states = {
	State{
		name = "idle",
		tags = {"idle"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle")
			inst.Physics:Stop()
		end,
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end),
		},
	},
}

return StateGraph("polarfox", states, events, "idle", actionhandlers)