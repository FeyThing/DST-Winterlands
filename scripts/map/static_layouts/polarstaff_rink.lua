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
				0, 3, 3, 0, 3, 3, 3, 0,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 0, 0, 3, 3, 0,
				0, 3, 3, 0, 0, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				3, 3, 3, 3, 3, 3, 3, 3,
				0, 3, 3, 3, 0, 3, 3, 0
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
					type = "polarstaff",
					shape = "rectangle",
					x = 256,
					y = 256,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["scenario"] = "staff_polar"
					}
				},
				{
					name = "",
					type = "rock_ice",
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
					type = "rock_polar",
					shape = "rectangle",
					x = 150,
					y = 114,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 102,
					y = 176,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 122,
					y = 291,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 310,
					y = 93,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 390,
					y = 134,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 384,
					y = 237,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 355,
					y = 365,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 285,
					y = 400,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rock_polar",
					shape = "rectangle",
					x = 176,
					y = 394,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
