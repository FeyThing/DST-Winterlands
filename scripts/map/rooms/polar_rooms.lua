AddRoom("PolarIsland_Village", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	tags = {"PolarBearTown", "Town"},
	contents = {
		countprefabs = {
			grass_polar_spawner = function() return math.random(0, 1) end,
			polarbearhouse = function() return math.random(4, 5) end,
			winter_tree_sparse = function() return IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and math.random(6, 8) or 0 end,
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

--

local cave_data = {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_CAVES_NOISE,
	contents = {
		countstaticlayouts = {
			["PolarCave_Pillar"] = function(area) return math.max(7, math.floor(area / 40)) end,
			--["PolarCave_SmallPillar"] = function() return math.random(0, 1) end,
		},
		countprefabs = {
			rock_polar = function() return math.random(4, 5) end,
			rock2 = function() return math.random(1, 2) end,
			polar_icicle_rock = function() return math.random(3, 6) end,
		},
		
		distributepercent = 0.14,
		distributeprefabs = {
			ice = 2,
			rock1 = 0.6,
			rock2 = 0.2,
			rock_flintless = 0.55,
			rock_ice = 0.75,
		},
		
		prefabdata = {
			polar_icicle_rock = function() return {workable = {workleft = math.random(3)}} end,
		},
	}
}

local cave_trap_layout = math.random() < 0.5 and "BlueGem_Shards" or "BlueGem_Shards_Ice"
local cave_data_trapped = deepcopy(cave_data)

cave_data_trapped.contents.countstaticlayouts[cave_trap_layout] = 1
cave_data_trapped.required_prefabs = {"polar_icicle_trap"}

AddRoom("PolarIsland_Caves", cave_data)
AddRoom("PolarIsland_TrappedCaves", cave_data_trapped)

--

local leif_scales = {0.7, 1, 1.25}

AddRoom("PolarIsland_Lakes", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	tags = {"PolarThrone"},
	contents = {
		countprefabs = {
			leif_sparse = function() return math.random() < 0.02 and math.random(4) or 0 end,
			skeleton_notplayer_1 = function() return math.random() < 0.01 and 1 or 0 end,
			skeleton_notplayer_2 = function() return math.random() < 0.01 and 1 or 0 end,
			snowwave_itemrespawner = function() return math.random(8, 12) end,
			rock1 = function() return math.random(0, 1) end,
			rocks = 4,
		},
		
		distributepercent = 0.21,
		distributeprefabs = {
			antler_tree = 0.01,
			antler_tree_stump = 0.005,
			evergreen_sparse = 1.2,
			evergreen_stump = 0.1,
			marsh_bush = 0.08,
			twiggytree = 0.1,
		},
		
		prefabdata = {
			leif_sparse = function() return {hibernate = true, sleeping = true, leifscale = leif_scales[math.random(#leif_scales)]} end,
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})

AddRoom("PolarIsland_DeciduousLakes", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	tags = {"PolarThrone"},
	contents = {
		countprefabs = {
			catcoonden = function() return math.random(0, 1) end,
			skeleton_notplayer_1 = function() return math.random() < 0.01 and 1 or 0 end,
			skeleton_notplayer_2 = function() return math.random() < 0.01 and 1 or 0 end,
			snowwave_itemrespawner = function() return math.random(8, 12) end,
			rock1 = function() return math.random(0, 1) end,
			rocks = 4,
		},
		
		distributepercent = 0.4,
		distributeprefabs = {
			carrot_planted = 0.17,
			antler_tree = 0.01,
			antler_tree_stump = 0.005,
			tree = {weight = 1, prefabs = {"evergreen_sparse", "deciduoustree_polar"}},
			stump = {weight = 0.37, prefabs = {"evergreen_stump", "deciduoustree_stump"}},
			marsh_bush = 0.16,
			twiggytree = 0.31,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})

AddRoom("PolarIsland_Walrus", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	tags = {"PolarTusks"},
	--[[required_prefabs = {"blowdart_pipe"},
	contents = {
		countstaticlayouts = {
			["PolarTuskTown"] = 1,
		},
	}]]
})

-- Optionals

AddRoom("PolarIsland_FloeField", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FLOE_NOISE,
	random_node_entrance_weight = 0,
	tags = {"ForceDisconnected"},
	contents = {
		countprefabs = {
			polarfish_shoalspawner_spawner_ice = 1,
			rock_ice_spawner_polar = function() return math.random() < 0.4 and 1 or 0 end,
		},
		
		distributepercent = 0.03,
		distributeprefabs = {
			marsh_bush = 7,
			rock_ice = 0.5,
			
			polarfox = 2,
			
			icelettuce_spawner = 4.6,
			snowwave_itemrespawner = 5.3,
			
			seastack = 0.35,
			wobster_den = 0.05,
		},
		
		prefabdata = {
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
			pond = function() return math.random(1, 2) end,
			snowwave_itemrespawner = function() return math.random(6, 10) end,
			rock1 = 1,
			rock2 = 1,
		},
		
		distributepercent = 0.062,
		distributeprefabs = {
			antler_tree = 0.2,
			evergreen_sparse = 1,
			marsh_bush = 1,
			twiggytree = 0.5,
			rocks = 1,
			flint = 1,
			rock1 = 1.5,
			rock2 = 0.9,
			rock_ice = 0.3,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})

--

AddRoom("PolarIsland_BurntForest", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	tags = {"PolarThrone"},
	contents = {
		countprefabs = {
			leif_sparse = function() return math.random() < 0.01 and math.random(4) or 0 end,
			polarbearhouse = function() return math.random(0, 2) end,
			snowwave_itemrespawner = function() return math.random(14, 22) end,
		},
		
		distributepercent = 0.28,
		distributeprefabs = {
			antler_tree_burnt = 0.01,
			evergreen = 0.5,
			evergreen_sparse = 1,
			evergreen_stump = 0.05,
			twiggytree = 0.05,
		},
		
		prefabdata = {
			evergreen = function() return {burnt = math.random() < 0.8} end, -- Aw that sucks :( even naturally spawned burnt trees decay automatically after 20~ days...
			evergreen_sparse = function() return {burnt = math.random() < 0.8} end,
			leif_sparse = function() return {hibernate = true, sleeping = true, leifscale = leif_scales[math.random(#leif_scales)]} end,
			polarbearhouse = {burnt = true},
			snowwave_itemrespawner = {canspawnsnowitem = true},
			twiggytree = function() return {burnt = math.random() < 0.8} end,
		},
	}
})

AddRoom("PolarIsland_BurntDeciduousForest", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_FOREST_NOISE,
	tags = {"PolarThrone"},
	contents = {
		countprefabs = {
			catcoonden = function() return math.random(0, 1) end,
			snowwave_itemrespawner = function() return math.random(14, 22) end,
		},
		
		distributepercent = 0.4,
		distributeprefabs = {
			antler_tree_burnt = 0.01,
			deciduoustree_polar = 1.25,
			deciduoustree_polar = 0.25,
			deciduoustree_stump = 0.05,
			twiggytree = 0.05,
		},
		
		prefabdata = {
			catcoonden = function() return {burnt = math.random() < 0.8} end,
			deciduoustree_polar = function() return {burnt = true} end,
			snowwave_itemrespawner = {canspawnsnowitem = true},
			twiggytree = function() return {burnt = math.random() < 0.8} end,
		},
	}
})

AddRoom("PolarIsland_BigLake", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	contents = {
		countstaticlayouts = {
			["Polar_Lake"] = 1,
		},
		
		distributepercent = 0.21,
		distributeprefabs = {
			antler_tree = 0.1,
			antler_tree_stump = 0.01,
			evergreen_sparse = 1.2,
			evergreen_stump = 0.04,
			marsh_bush = 0.04,
			twiggytree = 0.08,
		},
	}
})

AddRoom("PolarIsland_Rink", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_SNOW,
	tags = {"ForceDisconnected"},
	type = NODE_TYPE.SeparatedRoom,
	contents = {
		countstaticlayouts = {
			["PolarStaff_Rink"] = 1,
		},
		
		distributepercent = 0.2,
		distributeprefabs = {
			tree = {weight = 1, prefabs = {"evergreen", "evergreen_sparse"}},
			grass_polar_spawner = 0.5,
			marsh_bush = 1.5,
			snowwave_itemrespawner = 0.5,
			icelettuce_spawner = 0.5,
		},
	}
})

--

AddRoom("PolarIsland_GnomeVillage", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_GNOMES_NOISE,
	tags = {"ForceDisconnected", "PolarThrone"},
	type = NODE_TYPE.SeparatedRoom,
	contents = {
		countprefabs = {
			polarbearhouse = function() return math.random() < 0.15 and 1 or 0 end,
			snowwave_itemrespawner = function() return math.random(8, 13) end,
			winter_tree_sparse = function() return IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and 1 or 0 end,
		},
		
		distributepercent = 0.25,
		distributeprefabs = {
			polartrinket_1 = 0.45,
			polartrinket_2 = 0.3,
			trinket_4 = 0.4,
			trinket_13 = 0.25,
			
			antler_tree = 0.35,
			evergreen = 2.5,
			evergreen_sparse = 1.2,
			twiggytree = 0.2,
			marsh_bush = 1.5,
			rock_ice = 0.5,
			rocks = 0.5,
			
			mushtree_medium = 0.15,
			mushtree_small = 0.32,
			mushtree_tall = 0.5,
			
			red_mushroom = 0.3,
			green_mushroom = 0.64,
			blue_mushroom = 1,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
			winter_tree_sparse = function()
				return {growable = {stage = 5}, polar_decorate = true}
			end,
		},
	}
})

-- BG

AddRoom("PolarIsland_BG", {
	colour = {r = 0.1, g = 0.1, b = 0.8, a = 0.9},
	value = WORLD_TILES.POLAR_TUNDRA_NOISE,
	tags = {"PolarFleas", "PolarThrone"},
	contents = {
		countstaticlayouts = {
			["PolarSnowman"] = function() return math.random() < (IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and 0.5 or 0) and math.random(2, 3) or 0 end,
			["PolarSpookman"] = function() return math.random() < (IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and 0.33 or 0) and math.random(2, 3) or 0 end,
		},
		countprefabs = {
			icelettuce_spawner = function(area) return math.max(1, math.floor(area / 50)) end,
			snowwave_itemrespawner = function() return math.random(10, 16) end,
		},
		
		distributepercent = 0.06,
		distributeprefabs = {
			antler_tree = 1.2,
			antler_tree_stump = 0.2,
			grass_polar_spawner = 0.8,
			marsh_bush = 1.6,
			rock1 = 0.4,
			rock_ice = 0.4,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})