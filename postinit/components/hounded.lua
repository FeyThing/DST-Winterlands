local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("hounded", function(self)
	local OldSummonSpawn = PolarUpvalue(self.SummonSpawn, "SummonSpawn")
	local OldGetSpawnPrefab = PolarUpvalue(OldSummonSpawn, "GetSpawnPrefab")
	
	self._polarify = false
	
	local function SummonSpawn(pt, upgrade, radius_override, ...)
		local in_polar = GetClosestPolarTileToPoint(pt.x, 0, pt.z, 32) ~= nil
		
		if pt then
			self._polarify = in_polar
		end
		
		local hound = OldSummonSpawn(pt, upgrade, radius_override, ...)
		print("hound?", hound, hound and hound:IsValid())
		if hound and hound:IsValid() and in_polar then
			local num_fleas = math.random(TUNING.POLARFLEA_HOUNDED_MIN, TUNING.POLARFLEA_HOUNDED_MAX)
			
			for i = 1, num_fleas do
				local flea = SpawnPrefab("polarflea")
				flea.Transform:SetPosition(hound.Transform:GetWorldPosition())
				
				if flea.SetHost then
					flea:SetHost(hound)
				end
			end
		end
		
		return hound
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