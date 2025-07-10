return {
	version = "1.1",
	luaversion = "5.1",
	orientation = "orthogonal",
	width = 10,
	height = 10,
	tilewidth = 64,
	tileheight = 64,
	properties = {},
	tilesets = {
		{
			name = "tiles",
			firstgid = 1,
			tilewidth = 64,
			tileheight = 64,
			spacing = 0,
			margin = 0,
			image = "",
			imagewidth = 512,
			imageheight = 384,
			properties = {},
			tiles = {}
		}
	},
	layers = {
		{
			type = "tilelayer",
			name = "BG_TILES",
			x = 0,
			y = 0,
			width = 10,
			height = 10,
			visible = true,
			opacity = 1,
			properties = {},
			encoding = "lua",
			data = {
				0, 0, 2, 2, 2, 2, 2, 2, 0, 0,
				0, 2, 2, 2, 5, 5, 2, 2, 2, 0,
				2, 2, 2, 5, 5, 5, 5, 2, 2, 2,
				2, 2, 5, 5, 5, 5, 5, 5, 2, 2,
				2, 2, 5, 5, 9, 9, 5, 5, 2, 2,
				2, 2, 5, 5, 9, 9, 5, 5, 2, 2,
				2, 2, 5, 5, 5, 5, 5, 5, 2, 2,
				2, 2, 2, 5, 5, 5, 5, 2, 2, 2,
				0, 2, 2, 2, 5, 5, 2, 2, 2, 0,
				0, 0, 2, 2, 2, 2, 2, 2, 0, 0
			}
		},
		{
			type = "objectgroup",
			name = "FG_OBJECTS",
			visible = true,
			opacity = 1,
			properties = {},
			objects = {
				{
					name = "",
					type = "antler_tree_burnt",
					shape = "rectangle",
					x = 320,
					y = 320,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "burnt_marsh_bush",
					shape = "rectangle",
					x = 307,
					y = 336,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "burnt_marsh_bush",
					shape = "rectangle",
					x = 301,
					y = 298,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "burnt_marsh_bush",
					shape = "rectangle",
					x = 342,
					y = 317,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 128,
					y = 499,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 512,
					y = 144,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 96,
					y = 224,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 528,
					y = 416,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 288,
					y = 32,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 352,
					y = 608,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "antler_tree_stump",
					shape = "rectangle",
					x = 96,
					y = 96,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "antler_tree",
					shape = "rectangle",
					x = 496,
					y = 496,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 276,
					y = 243,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 302,
					y = 243,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 334,
					y = 242,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 368,
					y = 243,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 400,
					y = 280,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 399,
					y = 306,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 398,
					y = 337,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 398,
					y = 369,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 369,
					y = 399,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 338,
					y = 400,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 302,
					y = 401,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 272,
					y = 401,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 236,
					y = 368,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 237,
					y = 337,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 238,
					y = 305,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 241,
					y = 270,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_stone",
					shape = "rectangle",
					x = 246,
					y = 250,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.1"
					}
				},
				{
					name = "",
					type = "wall_stone",
					shape = "rectangle",
					x = 390,
					y = 250,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.0"
					}
				},
				{
					name = "",
					type = "wall_stone",
					shape = "rectangle",
					x = 246,
					y = 394,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				},
				{
					name = "",
					type = "wall_stone",
					shape = "rectangle",
					x = 390,
					y = 397,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.1"
					}
				},
				{
					name = "",
					type = "spoiled_fish_small",
					shape = "rectangle",
					x = 268,
					y = 56,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "spoiled_food",
					shape = "rectangle",
					x = 305,
					y = 19,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "spoiled_fish_small",
					shape = "rectangle",
					x = 527,
					y = 184,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "spoiled_fish",
					shape = "rectangle",
					x = 366,
					y = 583,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "boneshard",
					shape = "rectangle",
					x = 111,
					y = 465,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "spoiled_fish_small",
					shape = "rectangle",
					x = 110,
					y = 210,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "marsh_bush",
					shape = "rectangle",
					x = 64,
					y = 256,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "scorchedground",
					shape = "rectangle",
					x = 285,
					y = 326,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "scorchedground",
					shape = "rectangle",
					x = 352,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "scorchedground",
					shape = "rectangle",
					x = 336,
					y = 346,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 454,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 182,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.75"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 166,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.25"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 150,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 470,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 486,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 454,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "1"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 470,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.2"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 486,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 182,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 166,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.2"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 150,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				}
			}
		}
	}
}
