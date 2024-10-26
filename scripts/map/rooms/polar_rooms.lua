AddRoom("PolarIsland_Village", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	tags = {"Town"},
	contents = {
		countstaticlayouts = {
			["CropCircle"] = 1,
			["TreeFarm"] = 1,
		},
		countprefabs = {
			polarbearhouse = function() return math.random(8, 12) end,
		},
		
		distributepercent = 0.04,
		distributeprefabs = {
			evergreen = 2,
			evergreen_stump = 1,
		},
	}
})

AddRoom("PolarIsland_Caves", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_CAVES_NOISE,
	contents = {
		countstaticlayouts = {
			["PolarCave_Pillar"] = function() return math.random(6, 9) end,
		},
		countprefabs = {
			rock2 = 1,
			pillar_polar = 1,
		},
		
		distributepercent = 0.12,
		distributeprefabs = {
			rock_flintless = 1.5,
			rock_ice = 1,
			ice = 2,
			pillar_polar = 0.5,
		},
	}
})

AddRoom("PolarIsland_Lakes", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_LAKES_NOISE,
	internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	random_node_entrance_weight = 0,
	contents = {
		countprefabs = {
			rocks = 5,
		},
		
		distributepercent = 0.2,
		distributeprefabs = {
			evergreen_sparse = 1,
		},
	}
})

AddRoom("PolarIsland_BG", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_TUNDRA_NOISE,
	tags = {"PolarFleas"},
	contents = {
		countprefabs = {
			flint = function() return math.random(2, 3) end,
			rocks = function() return math.random(3, 6) end,
		},
		
		distributepercent = 0.07,
		distributeprefabs = {
			grass = 1,
			marsh_bush = 1,
			marsh_tree = 1,
			rock_ice = 1,
		},
	}
})