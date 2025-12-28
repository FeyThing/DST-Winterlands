local Bunches = {
	polarfish_shoalspawner_spawner_ice = {
		prefab = function(world, spawnerx, spawnerz)
			local rad = 4
			
			for _z = -rad, rad do
				for _x = -rad, rad do
					local x = spawnerx + _x
					local z = spawnerz + _z
					
					local tile = world:GetTile(x, z)
					if not TileGroupManager:IsInvalidTile(tile) and tile ~= WORLD_TILES.OCEAN_POLAR and tile ~= WORLD_TILES.OCEAN_COASTAL and tile ~= WORLD_TILES.POLAR_ICE then
						return nil
					end
				end
			end
			
			return "polarfish_shoalspawner"
		end,
		range = 20,
		min = 1,
		max = 2,
		min_spacing = 20,
		valid_tile_types = {
			WORLD_TILES.OCEAN_COASTAL,
			WORLD_TILES.OCEAN_POLAR,
			WORLD_TILES.POLAR_ICE,
		},
	},
	rock_ice_spawner_polar = {
		prefab = function(world, spawnerx, spawnerz)
			for _z = 3, -3, -3 do
				for _x = -3, 3 do
					local x = spawnerx + (_x * 4)
					local z = spawnerz + (_z * 4)
					
					local tile = world:GetTile(x, z)
					if tile == WORLD_TILES.POLAR_SNOW or tile == WORLD_TILES.POLAR_ICE or tile == WORLD_TILES.OCEAN_POLAR then
						return math.random() < 0.8 and "rock_ice" or "boat_ice_item_worldgen"
					end
				end
			end
		end,
		range = 20,
		min = 3,
		max = 6,
		min_spacing = 8,
		valid_tile_types = {
			WORLD_TILES.OCEAN_COASTAL,
			WORLD_TILES.OCEAN_POLAR,
			WORLD_TILES.POLAR_ICE,
		},
	},
}

return {
	Bunches = Bunches,
}