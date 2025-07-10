return {
	version = "1.1",
	luaversion = "5.1",
	orientation = "orthogonal",
	width = 10,
	height = 10,
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
			width = 10,
			height = 10,
			visible = true,
			opacity = 1,
			properties = {},
			encoding = "lua",
			data = {
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 13, 13, 13, 13, 0, 0,
				0, 0, 2, 2, 0, 0, 2, 2, 13, 0,
				0, 13, 2, 2, 13, 13, 2, 2, 0, 0,
				0, 0, 13, 13, 12, 12, 13, 0, 0, 0,
				0, 0, 0, 13, 12, 12, 13, 13, 0, 0,
				0, 0, 2, 2, 13, 13, 2, 2, 13, 0,
				0, 13, 2, 2, 0, 0, 2, 2, 0, 0,
				0, 0, 13, 13, 13, 13, 0, 0, 0, 0,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0
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
					type = "winterometer",
					shape = "rectangle",
					x = 320,
					y = 320,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 160,
					y = 224,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 160,
					y = 480,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 480,
					y = 416,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 480,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.spawned_brazier"] = "true",
					}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 262,
					y = 262,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 378,
					y = 262,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 378,
					y = 378,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polar_brazier",
					shape = "rectangle",
					x = 262,
					y = 378,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
