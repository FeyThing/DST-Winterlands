local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("hunter", function(self)
	local OldSpawnHuntedBeast = PolarUpvalue(self.OnDirtInvestigated, "SpawnHuntedBeast")
	local OldGetHuntedBeast = PolarUpvalue(OldSpawnHuntedBeast, "GetHuntedBeast")
	local ALTERNATE_BEASTS = PolarUpvalue(OldGetHuntedBeast, "ALTERNATE_BEASTS")
	
	local function GetHuntedBeast(hunt, spawn_pt, ...)
		local beast = OldGetHuntedBeast(self, hunt, spawn_pt, ...)
		
		if not self._overridepolar and spawn_pt and GetClosestPolarTileToPoint(spawn_pt.x, 0, spawn_pt.z, 32) ~= nil then
			return "polarwarg"
		end
		
		return beast
	end
	
	PolarUpvalue(OldSpawnHuntedBeast, "GetHuntedBeast", GetHuntedBeast)
end)