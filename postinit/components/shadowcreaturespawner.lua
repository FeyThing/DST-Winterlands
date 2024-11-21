local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("shadowcreaturespawner", function(self)
	local OldSpawnLandShadowCreature = PolarUpvalue(self.SpawnShadowCreature, "SpawnLandShadowCreature")
	local function SpawnLandShadowCreature(player, ...)
		local x, y, z = player.Transform:GetWorldPosition()
		if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil and math.random() <= TUNING.SHADOW_ICICLER_SPAWN_CHANCE then
			return SpawnPrefab("shadow_icicler")
		end
		
		return OldSpawnLandShadowCreature(player, ...)
	end
	
	PolarUpvalue(self.SpawnShadowCreature, "SpawnLandShadowCreature", SpawnLandShadowCreature)
end)