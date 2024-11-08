local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("shadowcreaturespawner", function(self)
	local OldSpawnLandShadowCreature = PolarUpvalue(self.SpawnShadowCreature, "SpawnLandShadowCreature")
	local function SpawnLandShadowCreature(player, ...)
		if IsInPolar(player, 0) and math.random() <= TUNING.SHADOW_ICICLER_SPAWN_CHANCE then
			return SpawnPrefab("shadow_icicler")
		end
		
		return OldSpawnLandShadowCreature(player, ...)
	end
	
	PolarUpvalue(self.SpawnShadowCreature, "SpawnLandShadowCreature", SpawnLandShadowCreature)
end)