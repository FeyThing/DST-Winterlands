local polar_region = WINTERLANDS_TYPE ~= "mainland" and "polarlands" or nil
local polar_locks = WINTERLANDS_TYPE ~= "mainland" and {} or {LOCKS.TIER1, LOCKS.TIER2, LOCKS.TIER3}

require("map/rooms/polar_rooms")

AddTask("Polar Village", {
	locks = polar_locks,
	keys_given = {KEYS.ISLAND_TIERPOLAR},
	region_id = polar_region,
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_Village"] = 1,
		["PolarIsland_BurntForest"] = function() return math.random() <= 0.1 and 1 or 0 end,
		["PolarIsland_BG"] = 1,
	},
	room_bg = WORLD_TILES.POLAR_SNOW,
	background_room = "PolarIsland_Lakes",
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})

AddTask("Polar Lands", {
	locks = {LOCKS.ISLAND_TIERPOLAR},
	keys_given = {LOCKS.ISLAND_TIER2},
	region_id = polar_region,
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_Lakes"] = 2,
		["PolarIsland_Walrus"] = 1,
		["PolarIsland_BurntForest"] = function() return math.random() <= 0.1 and math.random(1, 2) or 0 end,
		["PolarIsland_BG"] = 1,
	},
	room_bg = WORLD_TILES.POLAR_SNOW,
	background_room = "PolarIsland_BG",
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})

AddTask("Polar Caves", {
	locks = {LOCKS.ISLAND_TIERPOLAR},
	keys_given = {LOCKS.ISLAND_TIER3},
	region_id = polar_region,
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

--	Optional

AddTask("Polar Floe", {
	locks = {LOCKS.ISLAND_TIERPOLAR, LOCKS.ISLAND_TIER3},
	keys_given = {},
	region_id = polar_region,
	level_set_piece_blocker = true,
	entrance_room = "MoonIsland_Blank",
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_FloeField"] = function() return math.random(6, 12) end,
	},
	room_bg = WORLD_TILES.PEBBLEBEACH,
	background_room = "Empty_Cove",
	cove_room_name = "Blank",
	make_loop = true,
	crosslink_factor = 2,
	cove_room_chance = 1,
	cove_room_max_edges = 2,
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})

AddTask("Polar Lake", { -- Unused
	locks = {LOCKS.ISLAND_TIERPOLAR},
	keys_given = {LOCKS.ISLAND_TIER2},
	region_id = polar_region,
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "polararea", "not_mainland"},
	room_choices = {
		["PolarIsland_BigLake"] = 1,
	},
	room_bg = WORLD_TILES.POLAR_SNOW,
	background_room = "PolarIsland_BG",
	colour = {r = 0.1, g = 0.1, b = 1, a = 0.9},
})