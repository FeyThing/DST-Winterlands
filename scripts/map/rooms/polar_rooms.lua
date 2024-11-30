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
			polarbearhouse = function() return math.random(4, 5) end,
			winter_tree_sparse = function () return IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and math.random(6, 8) or 0 end,
		},
		
		distributepercent = 0.04,
		distributeprefabs = {
			evergreen = 2,
			evergreen_stump = 1,
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
			["PolarCave_Pillar"] = 7,
			["PolarCave_SmallPillar"] = function() return math.random(1, 2) end,
		},
		countprefabs = {
			rock_polar = function() return math.random(6, 8) end,
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
			snowwave_itemrespawner = function() return math.random(6, 9) end,
			rocks = 4,
		},
		
		distributepercent = 0.2,
		distributeprefabs = {
			evergreen_sparse = 1.22,
			evergreen_stump = 0.02,
			antler_tree_stump = 0.01,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
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
			icelettuce_spawner = function(area) return math.max(1, math.floor(area / 42)) end,
			snowwave_itemrespawner = function() return math.random(6, 9) end,
		},
		
		distributepercent = 0.07,
		distributeprefabs = {
			grass_polar_spawner = 1,
			antler_tree = 1.25,
			antler_tree_stump = 0.25,
			marsh_bush = 1,
			rock_ice = 1,
		},
		
		prefabdata = {
			snowwave_itemrespawner = {canspawnsnowitem = true},
		},
	}
})