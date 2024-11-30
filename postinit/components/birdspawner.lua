local BirdSpawner = require("components/birdspawner")
local old_BirdSpawner_ctor = BirdSpawner._ctor
BirdSpawner._ctor = function(self, ...)
    old_BirdSpawner_ctor(self, ...)

    local old_BirdSpawner_SpawnBird = self.SpawnBird
    self.SpawnBird = function(self, spawnpoint, ...)
        if GLOBAL.next(GLOBAL.TheSim:FindEntities(spawnpoint.x, 0, spawnpoint.z, GLOBAL.TUNING.SHADE_POLAR_RANGE, { "icecaveshelter" })) ~= nil then
            return
        end
    
        return old_BirdSpawner_SpawnBird(self, spawnpoint, ...)
    end
end