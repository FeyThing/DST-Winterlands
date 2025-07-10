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
				0, 3, 3, 3, 3, 3, 3, 0,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				0, 3, 3, 3, 3, 3, 3, 0
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
					type = "polarfish_shoalspawner",
					shape = "rectangle",
					x = 256,
					y = 256,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "skeleton",
					shape = "rectangle",
					x = 173,
					y = 179,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "fishingitem",
					shape = "rectangle",
					x = 192,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "fishingrecipe",
					shape = "rectangle",
					x = 144,
					y = 166,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
