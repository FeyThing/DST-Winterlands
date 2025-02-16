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
			imagewidth = 518,
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
				0, 0, 0, 8, 0, 0, 0, 0, 0, 0,
				0, 0, 2, 2, 8, 2, 2, 0, 0, 0,
				0, 2, 2, 2, 8, 2, 2, 2, 0, 0,
				8, 2, 2, 2, 8, 8, 2, 2, 2, 0,
				0, 8, 8, 8, 2, 2, 8, 2, 2, 0,
				0, 2, 2, 8, 2, 2, 8, 8, 8, 0,
				0, 2, 2, 2, 8, 8, 2, 2, 2, 8,
				0, 0, 2, 2, 2, 8, 2, 2, 2, 0,
				0, 0, 0, 2, 2, 8, 2, 2, 0, 0,
				0, 0, 0, 0, 0, 0, 8, 0, 0, 0
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
					type = "firepit",
					shape = "rectangle",
					x = 380,
					y = 380,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 888,
					y = 888,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "log",
					shape = "rectangle",
					x = 386,
					y = 358,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 358,
					y = 301,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "walrus_camp",
					shape = "rectangle",
					x = 160,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "walrus_camp",
					shape = "rectangle",
					x = 480,
					y = 480,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "walrus_camp",
					shape = "rectangle",
					x = 480,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "axe",
					shape = "rectangle",
					x = 188,
					y = 198,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 160,
					y = 358,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 188,
					y = 365,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 160,
					y = 397,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 188,
					y = 416,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 160,
					y = 448,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 884,
					y = 397,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 818,
					y = 435,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 837,
					y = 474,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 198,
					y = 467,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 888,
					y = 480,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "houndbone",
					shape = "rectangle",
					x = 461,
					y = 397,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "boneshard",
					shape = "rectangle",
					x = 435,
					y = 488,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "blowdart_pipe",
					shape = "rectangle",
					x = 489,
					y = 141,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "houndstooth",
					shape = "rectangle",
					x = 416,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 346,
					y = 83,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen",
					shape = "rectangle",
					x = 585,
					y = 843,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
