local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("hounded", function(self)
	local OldSummonSpawn = PolarUpvalue(self.SummonSpawn, "SummonSpawn")
	local OldGetSpawnPrefab = PolarUpvalue(OldSummonSpawn, "GetSpawnPrefab")
	
	self._polarify = false
	
	local function SummonSpawn(pt, upgrade, radius_override, ...)
		if pt then
			self._polarify = IsInPolarAtPoint(pt.x, 0, pt.z)
		end
		
		return OldSummonSpawn(pt, upgrade, radius_override, ...)
	end
	
	local function GetSpawnPrefab(upgrade, ...)
		local spawn = OldGetSpawnPrefab(upgrade, ...)
		
		if self._polarify and spawn == "hound" or spawn == "firehound" then
			spawn = "icehound" -- TODO: Use known winter_prefab instead ? Also disable if ice hounds are removed by world settings
			self._polarify = false
		end
		
		return spawn
	end
	
	PolarUpvalue(self.SummonSpawn, "SummonSpawn", SummonSpawn)
	PolarUpvalue(OldSummonSpawn, "GetSpawnPrefab", GetSpawnPrefab)
end)