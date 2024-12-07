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
				0, 2, 2, 2, 2, 0,
				2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2,
				0, 2, 2, 2, 2, 0,
				0, 0, 2, 2, 0, 0
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
					type = "polaramulet_station",
					shape = "rectangle",
					x = 192,
					y = 192,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 101,
					y = 89,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 180,
					y = 51,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 287,
					y = 103,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 331,
					y = 203,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 271,
					y = 291,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 182,
					y = 341,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 107,
					y = 293,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_sparse",
					shape = "rectangle",
					x = 42,
					y = 185,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
