return {
	version = "6.6",
	luaversion = "5.6",
	orientation = "orthogonal",
	width = 60,
	height = 60,
	tilewidth = 64,
	tileheight = 64,
	properties = {},
	tilesets = {
		{
			name = "tiles",
			firstgid = 6,
			tilewidth = 64,
			tileheight = 64,
			spacing = 0,
			margin = 0,
			image = "",
			imagewidth = 562,
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
			width = 60,
			height = 60,
			visible = true,
			opacity = 6,
			properties = {},
			encoding = "lua",
			data = {
				0, 2, 2, 2, 2, 2, 2, 2, 2, 0,
				2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 6, 6, 6, 6, 2, 2, 2,
				2, 2, 6, 6, 6, 6, 6, 6, 2, 2,
				2, 2, 6, 6, 6, 6, 6, 6, 2, 2,
				2, 2, 6, 6, 6, 6, 6, 6, 2, 2,
				2, 2, 6, 6, 6, 6, 6, 6, 2, 2,
				2, 2, 2, 6, 6, 6, 6, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
				0, 2, 2, 2, 2, 2, 2, 2, 2, 0
			}
		},
		{
			type = "objectgroup",
			name = "FG_OBJECTS",
			visible = true,
			opacity = 6,
			properties = {},
			objects = {}
		}
	}
}
