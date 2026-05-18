local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local FrogRain = require("components/frograin")

local OldFrogRain_ctor = FrogRain._ctor
FrogRain._ctor = function(self, ...)
	OldFrogRain_ctor(self, ...)
	
	local ToggleUpdate = PolarUpvalue(self.SetSpawnTimes, "ToggleUpdate")
	local ScheduleSpawn = PolarUpvalue(ToggleUpdate, "ScheduleSpawn")
	local SpawnFrogForPlayer = PolarUpvalue(ScheduleSpawn, "SpawnFrogForPlayer")
	
	local OldGetSpawnPoint = PolarUpvalue(SpawnFrogForPlayer, "GetSpawnPoint")
	local function GetSpawnPoint(_pt, ...)
		local pt = OldGetSpawnPoint and OldGetSpawnPoint(_pt, ...)
		
		if pt and GetClosestPolarTileToPoint(pt.x, 0, pt.z, 32) then
			return
		end
		
		return pt
	end
	
	PolarUpvalue(SpawnFrogForPlayer, "GetSpawnPoint", GetSpawnPoint)
end