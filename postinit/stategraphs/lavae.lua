local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local states = {
	State{
		name = "polaramuletbuff",
		tags = {"busy", "nointerrupt"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("polarbuff")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/lavae/taunt")
			
			inst.wantstopolarbuff = nil
		end,
		
		timeline = {
			TimeEvent(8 * FRAMES, function(inst)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/lavae/jump")
			end),
			
			TimeEvent(13 * FRAMES, function(inst)
				local scale = inst._polaramuletbuffed and 1.5 or 1
				
				inst.AnimState:SetScale(scale, scale)
				inst.SoundEmitter:PlaySound("dontstarve/creatures/together/lavae/sizzle_snow")
			end),
		},
		
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		},
	}
}

ENV.AddStategraphPostInit("lavae", function(sg)
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	--	Fix spawning in shadow, remove non-polar penguin on spawn
	
	local oldidle_enter = sg.states["idle"].onenter
	sg.states["idle"].onenter = function(inst, ...)
		if inst.wantstopolarbuff then
			inst.sg:GoToState("polaramuletbuff")
			return
		end
		
		oldidle_enter(inst, ...)
	end
end)