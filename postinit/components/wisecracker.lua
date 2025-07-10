local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("wisecracker", function(self)
    self.inst:ListenForEvent("defeated_emperorpenguin", function(inst)
		local times_beat = TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.times_beat or 1
		
		inst.components.talker:Say(subfmt(GetString(inst, "ANNOUNCE_EMPEROR_ESCAPE"), {wins = tostring(times_beat)}))
	end)
	
	self.inst:ListenForEvent("removearcticfoolfish", function(inst)
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_ARCTIC_FOOL_FISH_REMOVED"))
	end)
	
	self.inst:ListenForEvent("polarwalking", function(inst)
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_POLAR_SLOW"))
	end)
end)