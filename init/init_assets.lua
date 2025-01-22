GLOBAL.POLAR_ATLAS = MODROOT.."images/polarimages.xml"

Assets = {
	Asset("IMAGE", "images/polarimages.tex"),
	Asset("ATLAS", "images/polarimages.xml"),
	Asset("ATLAS_BUILD", "images/polarimages.xml", 256),
	
	Asset("IMAGE", "images/polarminimap.tex"),
	Asset("ATLAS", "images/polarminimap.xml"),
	
	-- UI
	Asset("IMAGE", "images/cookbook_polar.tex"),
	Asset("ATLAS", "images/cookbook_polar.xml"),
	
	Asset("IMAGE", "images/scrapbook_polar.tex"),
	Asset("ATLAS", "images/scrapbook_polar.xml"),
	
	Asset("ATLAS", "images/crafting_menu_polar.xml"),
	Asset("IMAGE", "images/crafting_menu_polar.tex"),
	
	Asset("ANIM", "anim/meter_polar_over.zip"),
	
	Asset("ANIM", "anim/polarstorm_over.zip"),
	
	Asset("ANIM", "anim/polar_amulet_ui.zip"),
	
	Asset("IMAGE", "images/rain_polar.tex"), -- Combined Status
	Asset("ATLAS", "images/rain_polar.xml"),

	-- Shaders
	Asset("SHADER", "shaders/snowed.ksh"),
	
	-- Anims / Builds
	Asset("ANIM", "anim/player_polarcast.zip"),
	Asset("ANIM", "anim/polar_snow.zip"),
	
	Asset("IMAGE", "images/polarpillar.tex"),
	
	-- Sounds
	Asset("SOUNDPACKAGE", "sound/polarsounds.fev"),
	Asset("SOUND", "sound/polarsounds.fsb"),
}

AddMinimapAtlas("images/polarminimap.xml")

--	Inventory Images

local ITEMS = {
	"antler_tree_stick",
	"armorpolar",
	"bluegem_overcharged",
	"bluegem_shards",
	"dug_grass_polar",
	"frostwalkeramulet",
	"iceburrito",
	"icelettuce",
	"icelettuce_seeds",
	"iciclestaff",
	"moose_polar_antler",
	"oceanfish_medium_polar1_inv",
	"polar_brazier_item",
	"polar_dryice",
	"polaramulet",
	"polarbearfur",
	"polarbearhat",
	"polarbearhat_red",
	"polarbearhouse",
	"polarcrablegs",
	"polarcrownhat",
	"polarflea",
	"polarglobe",
	"polarice_plow_item",
	"polaricepack",
	"polaricestaff",
	"polarmoosehat",
	"polarsnow_material",
	"polartrinket_1",
	"polartrinket_2",
	"polarwargstooth",
	"trap_polarteeth",
	"turf_polar_caves",
	"turf_polar_dryice",
	"wall_polar_item",
	"winter_ornament_polar_icicle_blue",
	"winter_ornament_polar_icicle_white",
	
	"ms_polarmoosehat_white",
}

--	Scrapbook Stuff

local scrapbook_prefabs = require("scrapbook_prefabs")
local scrapbookdata = require("screens/redux/scrapbookdata")

for i, v in pairs(ITEMS) do
	RegisterInventoryItemAtlas("images/polarimages.xml", v..".tex")
end

POLARAMULET_PARTS = GLOBAL.rawget(GLOBAL, "POLARAMULET_PARTS") or {}

local SCRAPBOOK_POLAR = require("scrapbook_polar")
for k, v in pairs(SCRAPBOOK_POLAR) do
	v.name = v.name or k
	v.prefab = k
	v.tex = k..".tex"
	v.type = v.type or "things"
	
	if not (v.type == "item" or v.type == "food") then
		RegisterScrapbookIconAtlas(GLOBAL.resolvefilepath("images/scrapbook_polar.xml"), v.tex)
	end
	
	if v.subcat == "ornament" then
		local sym = string.gsub(k, "^winter_ornament_", "")
		POLARAMULET_PARTS[k] = {build = v.build, ornament = true, symbol = sym}
	end
	
	scrapbook_prefabs[k] = true
	scrapbookdata[k] = v
end