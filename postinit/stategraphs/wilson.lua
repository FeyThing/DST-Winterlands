local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local states = {
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
	
	--
	
	local oldattack = sg.states["attack"].onenter
	sg.states["attack"].onenter = function(inst, ...)
		oldattack(inst, ...)
		
		local equip = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if equip and equip:HasTag("antlerstick") then
			 inst.SoundEmitter:PlaySound("polarsounds/antler_tree/swoop", nil, nil, true)
		end
	end
end)