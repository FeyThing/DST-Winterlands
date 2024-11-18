AddRoom("PolarIsland_Village", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	tags = {"Town"},
	required_prefabs = {"wall_polar"}, -- Present in all villages, added from taskset
	contents = {
		countstaticlayouts = {
			["TreeFarm"] = function() 
				if math.random() > 0.97 then
					return math.random(1,2)
				end
				
				return 0
			end,
		},
		countprefabs = {
			polarbearhouse = function() return math.random(2, 4) end,
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
			["PolarCave_Pillar"] = 7,
			["PolarCave_SmallPillar"] = function() return math.random(1, 2) end,
		},
		countprefabs = {
			rock2 = 1,
			polar_icicle_rock = function() return math.random(3, 10) end,
		},
		
		distributepercent = 0.12,
		distributeprefabs = {
			rock_flintless = 1.5,
			rock_ice = 1,
			ice = 2,
		},
		
		prefabdata = {
			polar_icicle_rock = function() return {workable = {workleft = math.random(3)}} end,
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
			evergreen_sparse = 1.22,
			antler_tree_stump = 0.02,
			antler_tree_stump = 0.01,
		},
	}
})

AddRoom("PolarIsland_Walrus", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_LAKES_NOISE,
	required_prefabs = {"walrus_camp"},
	contents = {
		countstaticlayouts = {
			["PolarTuskTown"] = 1,
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
			antler_tree = 1.25,
			antler_tree_stump = 0.25,
			marsh_bush = 1,
			rock_ice = 1,
		},
	}
})