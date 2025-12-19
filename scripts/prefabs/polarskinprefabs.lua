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

if HasPassedCalendarDay(9) then
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
end

if HasPassedCalendarDay(11) then
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
end

if HasPassedCalendarDay(14) then
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
end

if HasPassedCalendarDay(19) then
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
end

return unpack(prefs)