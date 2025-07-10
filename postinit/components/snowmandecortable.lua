local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local SnowmanDecoratable = require("components/snowmandecoratable")
	
	local ITEM_DATA = PolarUpvalue(SnowmanDecoratable.GetItemData, "ITEM_DATA")
	local POLAR_ITEM_DATA = {
		["antler_tree_stick"] = 			{bank = "polar_snowman_decor", 	build = "polar_snowman_decor", 	anim = "sticc", 	canflip = true},
		["moose_polar_antler"] = 			{bank = "polar_snowman_decor", 	build = "polar_snowman_decor", 	anim = "antler", 	canflip = true},
		["oceanfish_medium_polar1_inv"] = 	{bank = "polar_snowman_decor", 	build = "polar_snowman_decor", 	anim = "fish", 		canflip = true},
		["polarwargstooth"] = 				{bank = "polar_snowman_decor", 	build = "polar_snowman_decor", 	anim = "wargtooth", canflip = true},
	}
	
	if ITEM_DATA then
		for k, v in pairs(POLAR_ITEM_DATA) do
			ITEM_DATA[hash(k)] = v
			v.name = k
		end
	end