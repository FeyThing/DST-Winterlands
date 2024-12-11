local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function TrySpawnWavesPolar(self, map, x, y, z)
	if map:IsSurroundedByWater(x, y, z, 2) then
		local wave = SpawnPrefab("wave_shimmer")
		wave.Transform:SetPosition(x, y, z)
	end
end

ENV.AddComponentPostInit("wavemanager", function(self)
	if self.shimmer then
		self.shimmer[WORLD_TILES.OCEAN_POLAR] = {per_sec = 60, spawn_rate = 0, tryspawn = TrySpawnWavesPolar}
	end
end)