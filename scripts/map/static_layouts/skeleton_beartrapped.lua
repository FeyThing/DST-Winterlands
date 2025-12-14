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
				0, 0,
				0, 0
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
					type = "skeleton_notplayer_1",
					shape = "rectangle",
					x = 57,
					y = 74,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "walrus_beartrap",
					shape = "rectangle",
					x = 63,
					y = 61,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.finiteuses.percent"] = "0.9"
					}
				},
				{
					name = "",
					type = "boneshard",
					shape = "rectangle",
					x = 77,
					y = 79,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearfur",
					shape = "rectangle",
					x = 44,
					y = 55,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
