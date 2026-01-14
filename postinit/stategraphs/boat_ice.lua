local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddStategraphPostInit("boat_ice", function(sg)
	local healthdeltaevent = sg.states["idle"] and sg.states["idle"].events["healthdelta"]
	local oldhealthdelta = healthdeltaevent and healthdeltaevent.fn
	
	if oldhealthdelta then
		sg.states["idle"].events["healthdelta"].fn = function(inst, ...)
			oldhealthdelta(inst, ...)
			
			if inst.AnimState:IsCurrentAnimation("cracked0") then
				local idle_level = (inst.GetIdleLevel and inst:GetIdleLevel()) or 1
				inst.AnimState:PlayAnimation("idle"..idle_level)
			end
		end
	end
end)
