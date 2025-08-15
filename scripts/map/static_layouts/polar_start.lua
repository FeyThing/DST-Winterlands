return {
	version = "1.1",
	luaversion = "5.1",
	orientation = "orthogonal",
	width = 8,
	height = 8,
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
			width = 8,
			height = 8,
			visible = true,
			opacity = 1,
			properties = {},
			encoding = "lua",
			data = {
				0, 0, 0, 0, 0, 0, 0, 0,
				0, 12, 12, 2, 2, 2, 0, 0,
				0, 12, 12, 2, 2, 2, 2, 0,
				0, 2, 2, 2, 2, 2, 2, 0,
				0, 2, 2, 2, 2, 2, 2, 0,
				0, 2, 2, 2, 2, 2, 2, 0,
				0, 0, 2, 2, 2, 2, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0
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
					type = "campfire",
					shape = "rectangle",
					x = 256,
					y = 256,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.fueled.currentfuel"] = "54"
					}
				},
				{
					name = "",
					type = "spawnpoint_polar",
					shape = "rectangle",
					x = 224,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "spawnpoint_polar",
					shape = "rectangle",
					x = 272,
					y = 224,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "spawnpoint_polar",
					shape = "rectangle",
					x = 304,
					y = 256,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "axe",
					shape = "rectangle",
					x = 243,
					y = 198,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "log",
					shape = "rectangle",
					x = 214,
					y = 214,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "log",
					shape = "rectangle",
					x = 208,
					y = 224,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "shovel",
					shape = "rectangle",
					x = 288,
					y = 333,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "hat",
					shape = "rectangle",
					x = 272,
					y = 310,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "resurrectionstone",
					shape = "rectangle",
					x = 128,
					y = 128,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pighead",
					shape = "rectangle",
					x = 186,
					y = 70,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.burnt"] = "true"
					}
				},
				{
					name = "",
					type = "welcomitem",
					shape = "rectangle",
					x = 176,
					y = 403,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "welcomitem",
					shape = "rectangle",
					x = 112,
					y = 336,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "welcomitem",
					shape = "rectangle",
					x = 410,
					y = 176,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 346,
					y = 416,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 410,
					y = 368,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 368,
					y = 352,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 400,
					y = 307,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
