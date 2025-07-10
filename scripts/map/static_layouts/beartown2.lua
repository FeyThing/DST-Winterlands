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
				0, 1, 10, 1, 0, 0, 1, 1, 0, 0,
				0, 1, 10, 1, 1, 1, 1, 1, 1, 0,
				5, 5, 10, 1, 1, 1, 1, 1, 1, 1,
				5, 10, 10, 10, 10, 10, 10, 10, 1, 1,
				5, 5, 10, 1, 1, 10, 1, 1, 1, 0,
				1, 1, 10, 1, 1, 10, 1, 1, 1, 0,
				1, 1, 10, 1, 1, 10, 1, 1, 1, 1,
				1, 1, 1, 1, 5, 10, 5, 1, 1, 1,
				1, 1, 1, 1, 5, 10, 5, 1, 1, 1,
				0, 1, 1, 0, 5, 5, 5, 0, 1, 1
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
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 106,
					y = 160,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 106,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 416,
					y = 506,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "polarbearhouse_village",
					shape = "rectangle",
					x = 288,
					y = 582,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "rope",
					shape = "rectangle",
					x = 266,
					y = 458,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "meatrack",
					shape = "rectangle",
					x = 106,
					y = 224,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				--[[{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 314,
					y = 442,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "1"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 3104,
					y = 442,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.75"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 410,
					y = 442,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.2"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 3104,
					y = 426,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 314,
					y = 426,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.2"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 2108,
					y = 442,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 314,
					y = 266,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 3104,
					y = 266,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 202,
					y = 266,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				},
				{
					name = "",
					type = "wall_wood",
					shape = "rectangle",
					x = 202,
					y = 186,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				},]]
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 410,
					y = 602,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 426,
					y = 618,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.health.percent"] = "0.2"
					}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 426,
					y = 602,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "wall_polar",
					shape = "rectangle",
					x = 410,
					y = 618,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
