return {
	version = "1.1",
	luaversion = "5.1",
	orientation = "orthogonal",
	width = 4,
	height = 4,
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
			width = 4,
			height = 4,
			visible = true,
			opacity = 1,
			properties = {},
			encoding = "lua",
			data = {
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0
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
					type = "polar_icicle_trap",
					shape = "rectangle",
					x = 185,
					y = 140,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_icicle_trap",
					shape = "rectangle",
					x = 69,
					y = 102,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_icicle_trap",
					shape = "rectangle",
					x = 147,
					y = 69,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_icicle_trap",
					shape = "rectangle",
					x = 115,
					y = 188,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
