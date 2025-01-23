return {
	version = "1.1",
	luaversion = "5.1",
	orientation = "orthogonal",
	width = 6,
	height = 6,
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
			width = 6,
			height = 6,
			visible = true,
			opacity = 1,
			properties = {},
			encoding = "lua",
			data = {
				0, 0, 2, 2, 0, 0,
				0, 2, 2, 0, 0, 0,
				0, 0, 2, 2, 0, 2,
				2, 2, 2, 2, 2, 2,
				0, 2, 0, 0, 2, 0,
				0, 0, 0, 0, 0, 0
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
					type = "treasurechest",
					shape = "rectangle",
					x = 160,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["scenario"] = "chest_polar_start"
					}
				},
				{
					name = "",
					type = "skeleton",
					shape = "rectangle",
					x = 179,
					y = 179,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 237,
					y = 237,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 38,
					y = 218,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 192,
					y = 32,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 230,
					y = 147,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 102,
					y = 294,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
