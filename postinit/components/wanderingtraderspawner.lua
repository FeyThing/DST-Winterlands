local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("wanderingtraderspawner", function(self)
	self.inst:ListenForEvent("ms_registerspawnpoint", self.OnRegisterSpawnPoint)
end)