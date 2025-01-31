AddRoom("PolarIsland_Village", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	tags = {"Town"},
	required_prefabs = {"wall_polar"}, -- Present in all villages, added from taskset
	contents = {
		countprefabs = {
			polarbearhouse = function() return math.random(4, 5) end,
			winter_tree_sparse = function () return IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and math.random(6, 8) or 0 end,
		},
		
		distributepercent = 0.055,
		distributeprefabs = {
			evergreen = 2.25,
			evergreen_stump = 1.25,
			grass_polar = 1.3,
			twiggytree = 0.2,
		},
		
		prefabdata = {
			winter_tree_sparse = function()
				return {growable = {stage = 5}, polar_decorate = true}
			end,
		},
	}
})

AddRoom("PolarIsland_Caves", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_CAVES_NOISE,
	contents = {
		countstaticlayouts = {
			["PolarCave_Pillar"] = function(area) return math.max(7, math.floor(area / 40)) end,
			["PolarCave_SmallPillar"] = function() return math.random(1, 2) end,
		},
		countprefabs = {
			rock_polar = function() return math.random(6, 8) end,
			rock2 = function() return math.random(1, 2) end,
			polar_icicle_rock = function() return math.random(3, 10) end,
		},
		
		distributepercent = 0.14,
		distributeprefabs = {
			rock1 = 0.75,
			rock_flintless = 0.75,
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
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	random_node_entrance_weight = 0,
	contents = {
		countprefabs = {
			skeleton_notplayer_1 = function() return math.random() < 0.01 and 1 or 0 end,
			skeleton_notplayer_2 = function() return math.random() < 0.01 and 1 or 0 end,
			snowwave_itemrespawner = function() return math.random(8, 12) end,
			rocks = 4,
		},
		
		distributepercent = 0.21,
		distributeprefabs = {
			evergreen_sparse = 1.2,
			evergreen_stump = 0.02,
			antler_tree_stump = 0.01,
			twiggytree = 0.05,
			marsh_bush = 0.025,
			rock1 = 0.015,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})

AddRoom("PolarIsland_Walrus", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	required_prefabs = {"blowdart_pipe"},
	contents = {
		countstaticlayouts = {
			["PolarTuskTown"] = 1,
		},
	}
})

-- Optionals

AddRoom("PolarIsland_BurntForest", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	contents = {
		countprefabs = {
			polarbearhouse = function() return math.random(0, 2) end,
			snowwave_itemrespawner = function() return math.random(14, 22) end,
		},
		
		distributepercent = 0.28,
		distributeprefabs = {
			evergreen = 0.5,
			evergreen_sparse = 1,
			evergreen_stump = 0.05,
			antler_tree_burnt = 0.01,
			twiggytree = 0.05,
		},
		
		prefabdata = {
			polarbearhouse = {burnt = true},
			evergreen = function() return {burnt = math.random() < 0.8} end,
			evergreen_sparse = function() return {burnt = math.random() < 0.8} end,
			snowwave_itemrespawner = {canspawnsnowitem = true},
			twiggytree = function() return {burnt = math.random() < 0.8} end,
		},
	}
})

AddRoom("PolarIsland_FloeField", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FLOE_NOISE,
	random_node_entrance_weight = 0,
	contents = {
		countprefabs = {
			icelettuce_spawner = 2,
			snowwave_itemrespawner = 6,
		},
		
		distributepercent = 0.1,
		distributeprefabs = {
			marsh_bush = 1,
			rock_ice = 2,
		},
		
		prefabdata = {
			evergreen = function() return {burnt = math.random() < 0.8} end,
			evergreen_sparse = function() return {burnt = math.random() < 0.8} end,
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})

AddRoom("PolarIsland_IceQuarry", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_QUARRY_NOISE,
	tags = {"PolarFleas"},
	contents = {
		countprefabs = {
			grass_polar = 6,
			grass_polar_spawner = function() return math.random() < 0.33 and 1 or 0 end,
			pond = function() return math.random(2, 4) end,
			snowwave_itemrespawner = function() return math.random(6, 10) end,
		},
		
		distributepercent = 0.08,
		distributeprefabs = {
			antler_tree = 0.2,
			evergreen = 1,
			twiggytree = 0.5,
			marsh_bush = 1,
			
			rocks = 1,
			flint = 1,
			
			rock1 = 1.5,
			rock2 = 0.9,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})

AddRoom("PolarIsland_BigLake", { -- Unused
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	contents = {
		countstaticlayouts = {
			["PolarLake"] = 1,
		},
		
		distributepercent = 0.1,
		distributeprefabs = {
			antler_tree = 1,
			grass_polar_spawner = 0.5,
			marsh_bush = 1.5,
			rock_ice = 1,
		},
	}
})

-- BG

AddRoom("PolarIsland_BG", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_TUNDRA_NOISE,
	tags = {"PolarFleas"},
	random_node_entrance_weight = 0,
	contents = {
		countprefabs = {
			icelettuce_spawner = function(area) return math.max(1, math.floor(area / 42)) end,
			snowwave_itemrespawner = function() return math.random(10, 16) end,
		},
		
		distributepercent = 0.062,
		distributeprefabs = {
			grass_polar_spawner = 0.8,
			antler_tree = 1.25,
			antler_tree_stump = 0.25,
			marsh_bush = 1.6,
			rock1 = 0.4,
			rock_ice = 0.4,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})