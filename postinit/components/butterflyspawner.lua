local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local ButterflySpawner = require("components/butterflyspawner")

local OldButterflySpawner_ctor = ButterflySpawner._ctor
ButterflySpawner._ctor = function(self, ...)
	OldButterflySpawner_ctor(self, ...)
	
	local ToggleUpdate = PolarUpvalue(self.OnPostInit, "ToggleUpdate")
	local ScheduleSpawn = PolarUpvalue(ToggleUpdate, "ScheduleSpawn")
	local SpawnButterflyForPlayer = PolarUpvalue(ScheduleSpawn, "SpawnButterflyForPlayer")
	
	local OldGetSpawnPoint = PolarUpvalue(SpawnButterflyForPlayer, "GetSpawnPoint")
	local function GetSpawnPoint(player, ...)
		local spawnflower = OldGetSpawnPoint and OldGetSpawnPoint(player, ...)
		
		if spawnflower then
			local x, y, z = spawnflower.Transform:GetWorldPosition()
			
			if GetClosestPolarTileToPoint(x, y, z, 32) then
				return
			end
		end
		
		return spawnflower
	end
	
	PolarUpvalue(SpawnButterflyForPlayer, "GetSpawnPoint", GetSpawnPoint)
end