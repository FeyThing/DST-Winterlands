local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BirdSpawner = require("components/birdspawner")
local OldBirdSpawner_ctor = BirdSpawner._ctor

local ICECAVE_TAGS = {"icecaveshelter"}

--	NOTE: this is not fully working in Island Adventures maps because they forbid any bird spawn outside of their known tiles :/

BirdSpawner._ctor = function(self, ...)
    OldBirdSpawner_ctor(self, ...)
	
	self.polarise_birds = {"crow", "robin", "toucan", "seagull"}
	
	local OldPickBird = PolarUpvalue(self.SpawnBird, "PickBird")
	local BIRD_TYPES = PolarUpvalue(OldPickBird, "BIRD_TYPES")
	
	local function PickBird(spawnpoint, ...)
		local prefab = OldPickBird(spawnpoint, ...)
		local _BIRD_TYPES = BIRD_TYPES -- Keeping this here for simpler mod compat
		
		if prefab and #TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, TUNING.SHADE_POLAR_RANGE, ICECAVE_TAGS) > 0 then
			return
		end
		
		if GetClosestPolarTileToPoint(spawnpoint.x, 0, spawnpoint.z, 32) ~= nil then
			if TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsPolarStormActive() then
				return
			end
			
			if prefab and table.contains(self.polarise_birds, prefab) then
				local tile = TheWorld.Map:GetTileAtPoint(spawnpoint.x, 0, spawnpoint.z)
				return IsLandTile(tile) and "robin_winter" or "puffin"
			end
		end
		
		return prefab
	end
	
	PolarUpvalue(self.SpawnBird, "PickBird", PickBird)
end