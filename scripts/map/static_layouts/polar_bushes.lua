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
				0, 2, 2, 2, 2, 0,
				2, 2, 2, 2, 2, 2,
				2, 2, 2, 2, 2, 2,
				0, 2, 2, 2, 2, 0,
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
					type = "berrybush",
					shape = "rectangle",
					x = 192,
					y = 90,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 128,
					y = 109,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 256,
					y = 96,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 192,
					y = 294,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 128,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 256,
					y = 275,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 301,
					y = 237,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush",
					shape = "rectangle",
					x = 83,
					y = 147,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 192,
					y = 90,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 128,
					y = 109,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 256,
					y = 96,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 192,
					y = 294,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 128,
					y = 288,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 256,
					y = 275,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 301,
					y = 237,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "berrybush_juicy",
					shape = "rectangle",
					x = 83,
					y = 147,
					width = 0,
					height = 0,
					visible = true,
					properties = {}
				},
				{
					name = "",
					type = "antler_tree",
					shape = "rectangle",
					x = 288,
					y = 166,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "antler_tree",
					shape = "rectangle",
					x = 96,
					y = 218,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.pickable.picked"] = "true"
					}
				},
				{
					name = "",
					type = "snowwave_itemrespawner",
					shape = "rectangle",
					x = 154,
					y = 179,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.canspawnsnowitem"] = "true"
					}
				},
				{
					name = "",
					type = "snowwave_itemrespawner",
					shape = "rectangle",
					x = 224,
					y = 269,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.canspawnsnowitem"] = "true"
					}
				},
				{
					name = "",
					type = "snowwave_itemrespawner",
					shape = "rectangle",
					x = 262,
					y = 218,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.canspawnsnowitem"] = "true"
					}
				},
				{
					name = "",
					type = "snowwave_itemrespawner",
					shape = "rectangle",
					x = 115,
					y = 243,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.canspawnsnowitem"] = "true"
					}
				},
				{
					name = "",
					type = "snowwave_itemrespawner",
					shape = "rectangle",
					x = 211,
					y = 141,
					width = 0,
					height = 0,
					visible = true,
					properties = {
						["data.canspawnsnowitem"] = "true"
					}
				}
			}
		}
	}
}
