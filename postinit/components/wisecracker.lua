local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("wisecracker", function(self)
    self.inst:ListenForEvent("removearcticfoolfish", function(inst)
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED"))
	end)
	
	self.inst:ListenForEvent("polarwalking", function(inst)
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_POLAR_SLOW"))
	end)
end)