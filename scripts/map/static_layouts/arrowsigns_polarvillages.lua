return {
	version = "1.1",
	luaversion = "5.1",
	orientation = "orthogonal",
	width = 2,
	height = 2,
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
			width = 2,
			height = 2,
			visible = true,
			opacity = 1,
			properties = {},
			encoding = "lua",
			data = {
				0, 13,
				13, 0
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
					type = "arrowsign_post",
					shape = "rectangle",
					x = 32,
					y = 32,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["scenario"] = "arrowsign_bearvillage"
					}
				},
				{
					name = "",
					type = "arrowsign_post",
					shape = "rectangle",
					x = 32,
					y = 32,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["scenario"] = "arrowsign_walrusvillage"
					}
				}
			}
		}
	}
}
