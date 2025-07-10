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
				0, 0, 0, 0, 0, 0,
				0, 0, 2, 2, 0, 0,
				0, 2, 2, 2, 2, 0,
				0, 2, 2, 2, 2, 0,
				0, 0, 2, 2, 0, 0,
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
					type = "polarbearhouse",
					shape = "rectangle",
					x = 191,
					y = 193,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 191,
					y = 95,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 96,
					y = 193,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 289,
					y = 193,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 111,
					y = 238,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 239,
					y = 272,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 144,
					y = 111,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 238,
					y = 110,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 272,
					y = 238,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 273,
					y = 145,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 145,
					y = 273,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 111,
					y = 145,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 192,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.has_flea"] = "true"
					}
				}
			}
		}
	}
}
