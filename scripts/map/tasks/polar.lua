require("map/rooms/polar_rooms")

AddTask("Polar Village", {
	locks = {},
	keys_given = {KEYS.ISLAND_TIERPOLAR},
	region_id = "polarlands",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_Village"] = 1,
		["PolarIsland_BG"] = 1,
	},
	room_bg = WORLD_TILES.POLAR_SNOW,
	background_room = "PolarIsland_Lakes",
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})

AddTask("Polar Lands", {
	locks = {LOCKS.ISLAND_TIERPOLAR},
	keys_given = {LOCKS.ISLAND_TIER2},
	region_id = "polarlands",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_Lakes"] = 2,
		["PolarIsland_Walrus"] = 1,
		["PolarIsland_BG"] = 1,
	},
	room_bg = WORLD_TILES.POLAR_SNOW,
	background_room = "PolarIsland_BG",
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})

AddTask("Polar Caves", {
	locks = {LOCKS.ISLAND_TIERPOLAR},
	keys_given = {LOCKS.ISLAND_TIER3},
	region_id = "polarlands",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_Caves"] = 2,
	},
	room_bg = WORLD_TILES.POLAR_SNOW,
	background_room = "Empty_Cove",
	cove_room_name = "PolarIsland_BG",
	make_loop = true,
	crosslink_factor = 2,
	cove_room_chance = 1,
	cove_room_max_edges = 2,
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})