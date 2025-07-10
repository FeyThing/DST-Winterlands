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
				0, 0, 0, 0, 13, 13, 13, 13, 0, 0,
				0, 13, 13, 13, 13, 13, 13, 13, 13, 0,
				13, 13, 13, 13, 2, 2, 13, 13, 13, 0,
				13, 13, 13, 2, 2, 2, 2, 13, 13, 0,
				13, 13, 2, 2, 2, 2, 2, 2, 13, 13,
				13, 13, 2, 2, 2, 2, 2, 2, 13, 13,
				0, 13, 13, 2, 2, 2, 2, 13, 13, 13,
				0, 13, 13, 13, 2, 2, 13, 13, 13, 13,
				0, 13, 13, 13, 13, 13, 13, 13, 13, 0,
				0, 0, 13, 13, 13, 13, 0, 0, 0, 0
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
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 157,
					y = 96,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 93,
					y = 480,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 477,
					y = 544,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 608,
					y = 285,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 413,
					y = 32,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 221,
					y = 285,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 342,
					y = 179,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 470,
					y = 298,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 371,
					y = 477,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 269,
					y = 419,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "sapling",
					shape = "rectangle",
					x = 403,
					y = 371,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true",
						["data.pickable.time"] = "4800"
					}
				},
				{
					name = "",
					type = "sapling",
					shape = "rectangle",
					x = 170,
					y = 355,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true",
						["data.pickable.time"] = "4800"
					}
				},
				{
					name = "",
					type = "sapling",
					shape = "rectangle",
					x = 384,
					y = 218,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true",
						["data.pickable.time"] = "4800"
					}
				},
				{
					name = "",
					type = "grass_polar_spawner",
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
					type = "rocks",
					shape = "rectangle",
					x = 45,
					y = 173,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 224,
					y = 563,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 589,
					y = 429,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 493,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rocks",
					shape = "rectangle",
					x = 282,
					y = 58,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
