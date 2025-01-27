local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Hounded = require("components/hounded")
local OldHounded_ctor = Hounded._ctor

Hounded._ctor = function(self, ...)
	OldHounded_ctor(self, ...)
	
	self._polarify = false
	
	local OldSummonSpawn = PolarUpvalue(self.SummonSpawn, "SummonSpawn")
	local OldGetSpawnPrefab = PolarUpvalue(OldSummonSpawn, "GetSpawnPrefab")
	
	local GetSpawnPoint = PolarUpvalue(OldSummonSpawn, "GetSpawnPoint") -- Keeping these under for simpler mod compat
	local GetSpecialSpawnChance = PolarUpvalue(OldGetSpawnPrefab, "GetSpecialSpawnChance")
	local _spawndata = PolarUpvalue(self.SetSpawnData, "_spawndata")
	
	local function GetSpawnPrefab(upgrade, ...)
		local spawn = OldGetSpawnPrefab(upgrade, ...)
		local spawndata = _spawndata
		local _GetSpecialSpawnChance = GetSpecialSpawnChance
		
		if self._polarify and (spawn == "hound" or spawn == "firehound") then
			spawn = "icehound" -- TODO: Use known winter_prefab instead ? Also disable if ice hounds are removed by world settings
			self._polarify = false
		end
		
		return spawn
	end
	
	PolarUpvalue(OldSummonSpawn, "GetSpawnPrefab", GetSpawnPrefab)
	
	local function SummonSpawn(pt, upgrade, radius_override, ...)
		local in_polar = GetClosestPolarTileToPoint(pt.x, 0, pt.z, 32) ~= nil
		local _GetSpawnPoint = GetSpawnPoint
		local _GetSpawnPrefab = GetSpawnPrefab
		
		if pt then
			self._polarify = in_polar
		end
		
		local hound = OldSummonSpawn(pt, upgrade, radius_override, ...)
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
	
	PolarUpvalue(self.SummonSpawn, "SummonSpawn", SummonSpawn)
end