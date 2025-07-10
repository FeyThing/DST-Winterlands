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
				0, 0, 0, 0, 0, 0, 0, 0,
				0, 0, 0, 0, 4, 0, 0, 0,
				0, 0, 4, 0, 0, 4, 0, 0,
				0, 0, 0, 4, 4, 4, 0, 0,
				0, 0, 4, 4, 4, 4, 4, 4,
				0, 4, 0, 4, 4, 4, 4, 0,
				0, 0, 0, 0, 4, 4, 4, 0,
				0, 0, 0, 0, 0, 4, 0, 0
			}
		},
		{
			type = "objectgroup",
			name = "FG_OBJECTS",
			visible = true,
			opacity = 1,
			properties = {},
			objects = {
				--[[{
					name = "",
					type = "skeleton",
					shape = "rectangle",
					x = 350,
					y = 298,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.anim"] = "6"
					}
				},]]
				{
					name = "",
					type = "wysp_skeleton_marker",
					shape = "rectangle",
					x = 350,
					y = 298,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "goldenshovel",
					shape = "rectangle",
					x = 328,
					y = 269,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 256,
					y = 257,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 226,
					y = 292,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 287,
					y = 308,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 237,
					y = 340,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 298,
					y = 369,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 300,
					y = 413,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 353,
					y = 412,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "grass_polar",
					shape = "rectangle",
					x = 344,
					y = 366,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.makealwaysbarren"] = "1"
					}
				},
				{
					name = "",
					type = "twigs",
					shape = "rectangle",
					x = 322,
					y = 278,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 159,
					y = 164,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 482,
					y = 291,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "evergreen_stump",
					shape = "rectangle",
					x = 353,
					y = 482,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				}
			}
		}
	}
}
