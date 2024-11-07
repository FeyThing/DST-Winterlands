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

return unpack(prefs)