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
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2, 2, 2
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
					type = "pond",
					shape = "rectangle",
					x = 429,
					y = 427,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 80,
					y = 367,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 235,
					y = 433,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 178,
					y = 230,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 83,
					y = 81,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 294,
					y = 76,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 435,
					y = 145,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "pond",
					shape = "rectangle",
					x = 342,
					y = 299,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 139,
					y = 435,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 75,
					y = 462,
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
					x = 169,
					y = 371,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 49,
					y = 142,
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
					x = 13,
					y = 83,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 57,
					y = 27,
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
					x = 123,
					y = 24,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 453,
					y = 55,
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
					x = 393,
					y = 82,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 353,
					y = 139,
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
					x = 277,
					y = 146,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 201,
					y = 105,
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
					x = 403,
					y = 218,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 464,
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
					x = 433,
					y = 339,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 370,
					y = 397,
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
					x = 485,
					y = 477,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 397,
					y = 487,
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
					x = 305,
					y = 431,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 291,
					y = 490,
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
					x = 290,
					y = 337,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 223,
					y = 305,
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
					y = 265,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 341,
					y = 233,
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
					x = 298,
					y = 206,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 138,
					y = 168,
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
					x = 105,
					y = 209,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 19,
					y = 205,
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
					x = 93,
					y = 271,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 19,
					y = 307,
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
					x = 41,
					y = 328,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 17,
					y = 410,
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
					x = 53,
					y = 480,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 203,
					y = 333,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 171,
					y = 291,
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
					x = 235,
					y = 199,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 215,
					y = 172,
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
					x = 237,
					y = 48,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 310,
					y = 21,
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
					x = 364,
					y = 44,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 411,
					y = 21,
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
					x = 494,
					y = 180,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 460,
					y = 243,
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
					x = 430,
					y = 289,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 480,
					y = 367,
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
					x = 492,
					y = 395,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 327,
					y = 349,
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
					x = 203,
					y = 475,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 159,
					y = 489,
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
					y = 421,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
