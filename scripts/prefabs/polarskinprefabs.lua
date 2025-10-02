local prefs = {}

table.insert(prefs, CreatePrefabSkin("ms_polarmoosehat_white",
{
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

return unpack(prefs)