local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("wisecracker", function(self)
    self.inst:ListenForEvent("polarwalking", function(inst)
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_POLAR_SLOW"))
	end)
end)