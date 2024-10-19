require("map/rooms/winterlands_rooms")

AddTask("Icy Fields", {
	locks={},
	keys_given={KEYS.ISLAND_TIER2},
	region_id = "winterlands",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "not_mainland"},
	room_choices={
		["Icy Fields"] = 2,
		["Tundra"] = 1,			
	},
	room_bg=WORLD_TILES.OCEAN_ICE,
	background_room = "BG Icy Fields",
	cove_room_name = "Empty_Cove",
	make_loop = true,
	crosslink_factor = 2,
	cove_room_chance = 1,
	cove_room_max_edges = 2,
	colour={r=.05,g=.5,b=.05,a=1},
})

AddTask("Tundra", {
	locks={LOCKS.ISLAND_TIER2},
	keys_given={KEYS.ISLAND_TIER3},
	region_id = "winterlands",
	level_set_piece_blocker = true,
	room_tags = {"RoadPoison", "not_mainland"},
	room_choices={
		["Tundra"] = 1,			
	},
	room_bg=WORLD_TILES.DIRT_NOISE,
	background_room = "BG Tundra",
	cove_room_name = "Empty_Cove",
	cove_room_chance = 1,
	cove_room_max_edges = 2,
	colour={r=.05,g=.5,b=.05,a=1},
})
	
AddTask("Icy Pillars", {
		locks={},
		keys_given={KEYS.ISLAND_TIER2},
		region_id = "winterlands",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "not_mainland"},
		room_choices={
			["Icy Pillars"] = 1,			
		},
		room_bg=WORLD_TILES.OCEAN_ICE,
		background_room = "BG Icy Fields",
		colour={r=.05,g=.5,b=.05,a=1},
	})
	
	AddTask("Cold Wastes", {
		locks={LOCKS.ISLAND_TIER2},
		keys_given={KEYS.ISLAND_TIER3},
		region_id = "winterlands",
		level_set_piece_blocker = true,
		room_tags = {"RoadPoison", "not_mainland"},
		room_choices={
			["Cold Wastes"] = 1,			
		},
		room_bg=WORLD_TILES.DIRT_NOISE,
		background_room = "BG Icy Fields",
		colour={r=.05,g=.5,b=.05,a=1},
	})