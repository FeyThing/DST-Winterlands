local prefs = {}

table.insert(prefs, CreatePrefabSkin("ms_polarmoosehat_white", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/polarmoosehat_white.zip"),
		Asset("PKGREF", "anim/dynamic/polarmoosehat_white.dyn"),
	},
	base_prefab = "polarmoosehat",
	type = "item",
	build_name_override = "polarmoosehat_white",
	rarity = "ModMade",
	skin_tags = {"POLAR", "POLARMOOSEHAT", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_treasurechest_polarice", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/treasurechest_polarice.zip"),
		Asset("PKGREF", "anim/dynamic/treasurechest_polarice.dyn"),
	},
	base_prefab = "treasurechest",
	type = "item",
	build_name_override = "treasurechest_polarice",
	rarity = "ModMade",
	skin_tags = {"POLAR", "CHEST", "CRAFTABLE"},
	granted_items = {"ms_treasurechest_upgraded_polarice"},
}))

table.insert(prefs, CreatePrefabSkin("ms_treasurechest_upgraded_polarice", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/treasurechest_upgraded_polarice.zip"),
		Asset("PKGREF", "anim/dynamic/treasurechest_upgraded_polarice.dyn"),
	},
	base_prefab = "treasurechest",
	type = "item",
	build_name_override = "treasurechest_upgraded_polarice",
	rarity = "ModLocked", -- BUGGY NOTE: This shouldn't be different from main skin but idk why it won't hide from crafting wheel
	condition = {no_gift = true},
	skin_tags = {},
}))

table.insert(prefs, CreatePrefabSkin("ms_dragonflychest_polarice", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/dragonflychest_polarice.zip"),
		Asset("PKGREF", "anim/dynamic/dragonflychest_polarice.dyn"),
	},
	base_prefab = "dragonflychest",
	type = "item",
	build_name_override = "dragonflychest_polarice",
	rarity = "ModMade",
	skin_tags = {"POLAR", "DRAGONFLYCHEST", "CRAFTABLE"},
	granted_items = {"ms_dragonflychest_upgraded_polarice"},
}))

table.insert(prefs, CreatePrefabSkin("ms_dragonflychest_upgraded_polarice", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/dragonflychest_upgraded_polarice.zip"),
		Asset("PKGREF", "anim/dynamic/dragonfly_chestupgraded_polarice.dyn"),
	},
	base_prefab = "dragonflychest",
	type = "item",
	build_name_override = "dragonflychest_upgraded_polarice",
	rarity = "ModLocked",
	condition = {no_gift = true},
	skin_tags = {},
}))

table.insert(prefs, CreatePrefabSkin("ms_goldenpickaxe_polar", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/goldenpickaxe_polar.zip"),
		Asset("PKGREF", "anim/dynamic/goldenpickaxe_polar.dyn"),
	},
	base_prefab = "goldenpickaxe",
	type = "item",
	build_name_override = "goldenpickaxe_polar",
	rarity = "ModMade",
	skin_tags = {"POLAR", "GOLDENPICKAXE", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_bushhat_polar", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/ms_bushhat_polar.zip"),
		Asset("PKGREF", "anim/dynamic/ms_bushhat_polar.dyn"),
	},
	base_prefab = "bushhat",
	type = "item",
	build_name_override = "ms_bushhat_polar",
	rarity = "ModMade",
	prefabs = {"polar_snow_bush"},
	skin_tags = {"POLAR", "BUSHHAT", "CRAFTABLE"},
	fx_prefab = {"polar_snow_bush"},
}))

table.insert(prefs, CreatePrefabSkin("ms_goldenshovel_polar", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/goldenshovel_polar.zip"),
		Asset("PKGREF", "anim/dynamic/goldenshovel_polar.dyn"),
	},
	base_prefab = "goldenshovel",
	type = "item",
	build_name_override = "goldenshovel_polar",
	rarity = "ModMade",
	skin_tags = {"POLAR", "GOLDENSHOVEL", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_goldenaxe_polar", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/goldenaxe_polar.zip"),
		Asset("PKGREF", "anim/dynamic/goldenaxe_polar.dyn"),
	},
	base_prefab = "goldenaxe",
	type = "item",
	build_name_override = "goldenaxe_polar",
	rarity = "ModMade",
	skin_tags = {"POLAR", "GOLDENAXE", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_polarheadstick_pig", {
	assets = {},
	base_prefab = "polarheadstick",
	type = "item",
	build_name_override = "pig_head",
	rarity = "ModMade",
	skin_tags = {"POLAR", "POLARHEADSTICK", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_polarheadstick_merm", {
	assets = {},
	base_prefab = "polarheadstick",
	type = "item",
	build_name_override = "merm_head",
	rarity = "ModMade",
	skin_tags = {"POLAR", "POLARHEADSTICK", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_polarheadstick_walrus", {
	assets = {},
	base_prefab = "polarheadstick",
	type = "item",
	build_name_override = "polarwalrus_head",
	rarity = "ModMade",
	skin_tags = {"POLAR", "POLARHEADSTICK", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_minerhat_boreal", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/minerhat_boreal.zip"),
		Asset("PKGREF", "anim/dynamic/minerhat_boreal.dyn"),
	},
	base_prefab = "minerhat",
	type = "item",
	rarity = "ModMade",
	build_name_override = "minerhat_boreal",
	skin_tags = {"POLAR", "MINERHAT", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_antler_tree_stick_holly", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/antler_tree_stick_holly.zip"),
		Asset("PKGREF", "anim/dynamic/antler_tree_stick_holly.dyn"),
	},
	base_prefab = "antler_tree_stick",
	type = "item",
	build_name_override = "antler_tree_stick_holly",
	rarity = "ModLocked",
	condition = {no_gift = true},
	skin_tags = {"POLAR", "ANTLER_TREE_STICK", "CRAFTABLE"},
	skin_sound = {
		["hit"] = "polarsounds/antler_tree/bonk_holly"
	},
}))

table.insert(prefs, CreatePrefabSkin("ms_glasscutter_polar", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/glasscutter_polar.zip"),
		Asset("PKGREF", "anim/dynamic/glasscutter_polar.dyn"),
	},
	base_prefab = "glasscutter",
	type = "item",
	build_name_override = "glasscutter_polar",
	rarity = "ModLocked",
	condition = {no_gift = true},
	skin_tags = {"POLAR", "GLASSCUTTER", "CRAFTABLE"},
}))

table.insert(prefs, CreatePrefabSkin("ms_polarbear_rug_red", {
	assets = {
		Asset("DYNAMIC_ANIM", "anim/dynamic/polarbear_rug_red.zip"),
		Asset("PKGREF", "anim/dynamic/polarbear_rug_red.dyn"),
	},
	base_prefab = "polarbear_rug",
	type = "item",
	build_name_override = "polarbear_rug_red",
	rarity = "ModMade",
	skin_tags = {"POLAR", "POLARBEAR_RUG", "CRAFTABLE"},
}))

return unpack(prefs)