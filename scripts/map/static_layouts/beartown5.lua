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
				0, 0, 0, 2, 2, 2, 2, 2, 2, 0,
				0, 2, 2, 2, 13, 13, 13, 13, 2, 2,
				2, 2, 2, 13, 13, 13, 13, 13, 13, 2,
				13, 13, 2, 13, 13, 2, 2, 13, 13, 2,
				13, 13, 13, 13, 2, 2, 2, 13, 13, 13,
				2, 13, 13, 13, 2, 2, 2, 2, 13, 13,
				2, 2, 2, 13, 13, 2, 2, 2, 2, 2,
				0, 2, 2, 13, 13, 2, 2, 2, 2, 0,
				0, 2, 2, 2, 13, 13, 2, 2, 0, 0,
				0, 0, 2, 2, 13, 13, 2, 0, 0, 0
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
					x = 275,
					y = 275,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 288,
					y = 371,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 160,
					y = 224,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 173,
					y = 531,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 32,
					y = 358,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 403,
					y = 595,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 550,
					y = 403,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.burnt"] = "true",
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 480,
					y = 416,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.burnt"] = "true",
					}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 528,
					y = 477,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.burnt"] = "true",
					}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 470,
					y = 528,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 403,
					y = 493,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 352,
					y = 397,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 422,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 429,
					y = 339,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 336,
					y = 323,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "marsh_bush",
					shape = "rectangle",
					x = 355,
					y = 214,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "marsh_bush",
					shape = "rectangle",
					x = 467,
					y = 358,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "marsh_bush",
					shape = "rectangle",
					x = 214,
					y = 112,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 528,
					y = 109,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 595,
					y = 211,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 230,
					y = 608,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 152,
					y = 624,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 74,
					y = 403,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 109,
					y = 483,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 54,
					y = 144,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 128,
					y = 80,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 330,
					y = 45,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 486,
					y = 16,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "tree",
					shape = "rectangle",
					x = 630,
					y = 157,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 128,
					y = 320,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 320,
					y = 576,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 448,
					y = 128,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
