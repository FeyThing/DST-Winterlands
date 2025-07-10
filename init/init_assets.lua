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
	
	Asset("ANIM", "anim/ui_polarfleasack_2x5.zip"),
	
	Asset("IMAGE", "images/rain_polar.tex"), -- Combined Status worldtemp compat
	Asset("ATLAS", "images/rain_polar.xml"),
	
	Asset("ANIM", "anim/polarstatus_wx.zip"),
	Asset("ANIM", "anim/wx_polarchips.zip"),
	
	-- Shaders / Shades
	Asset("SHADER", "shaders/snowed.ksh"),
	Asset("IMAGE", "images/polarpillar.tex"),
	
	-- Anims / Builds
	Asset("ANIM", "anim/player_flea_itchy.zip"),
	Asset("ANIM", "anim/player_polarcast.zip"),
	Asset("ANIM", "anim/player_winterfists.zip"),
	
	Asset("ANIM", "anim/rain_meter_polar_anims.zip"),
	Asset("ANIM", "anim/winter_meter_polar_anims.zip"),
	
	Asset("ANIM", "anim/polar_snow.zip"),
	Asset("ANIM", "anim/polar_snowman_decor.zip"),
	
	-- Sounds
	Asset("SOUNDPACKAGE", "sound/polarsounds.fev"),
	Asset("SOUND", "sound/polarsounds.fsb"),
}

AddMinimapAtlas("images/polarminimap.xml")

--	Inventory Images

local ITEMS = {
	"antler_tree_stick",
	"arctic_fool_fish",
	"armorpolar",
	"bluegem_overcharged",
	"bluegem_shards",
	"chesspiece_emperor_penguin_fruity",
	"chesspiece_emperor_penguin_fruity_moonglass",
	"chesspiece_emperor_penguin_fruity_sketch",
	"chesspiece_emperor_penguin_fruity_stone",
	"chesspiece_emperor_penguin_juggle",
	"chesspiece_emperor_penguin_juggle_moonglass",
	"chesspiece_emperor_penguin_juggle_sketch",
	"chesspiece_emperor_penguin_juggle_stone",
	"chesspiece_emperor_penguin_magestic",
	"chesspiece_emperor_penguin_magestic_moonglass",
	"chesspiece_emperor_penguin_magestic_sketch",
	"chesspiece_emperor_penguin_magestic_stone",
	"chesspiece_emperor_penguin_spin",
	"chesspiece_emperor_penguin_spin_moonglass",
	"chesspiece_emperor_penguin_spin_sketch",
	"chesspiece_emperor_penguin_spin_stone",
	"compass_polar",
	"dryicecream",
	"dug_grass_polar",
	"emperor_egg",
	"emperor_penguinhat",
	"frostwalkeramulet",
	"iceburrito",
	"icelettuce",
	"icelettuce_seeds",
	"iciclestaff",
	"moose_polar_antler",
	"oceanfish_medium_polar1_inv",
	"polar_brazier_item",
	"polar_dryice",
	"polar_spear",
	"polaramulet",
	"polarbearfur",
	"polarbearhat",
	"polarbearhat_red",
	"polarbearhouse",
	"polarcrablegs",
	"polarcrownhat",
	"polarflea",
	"polarflea_sack",
	"polarglobe",
	"oceanfish_in_ice",
	"polarice_plow_item",
	"polaricepack",
	"polaricestaff",
	"polarmoosehat",
	"polarsnow_material",
	"polartrinket_1",
	"polartrinket_2",
	"polarwargstooth",
	"tower_polar_flag_item",
	"trap_polarteeth",
	"turf_polar_caves",
	"turf_polar_dryice",
	"wall_polar_item",
	"winter_ornament_polar_icicle_blue",
	"winter_ornament_polar_icicle_white",
	"winters_fists",
	"wx78module_naughty",
	
	"ms_polarmoosehat_white",
}

--	Scrapbook Stuff

local scrapbook_prefabs = require("scrapbook_prefabs")
local scrapbookdata = require("screens/redux/scrapbookdata")

for i, v in ipairs(ITEMS) do
	RegisterInventoryItemAtlas(GLOBAL.resolvefilepath("images/polarimages.xml"), v..".tex")
end

POLARAMULET_PARTS = GLOBAL.rawget(GLOBAL, "POLARAMULET_PARTS") or {}

local SCRAPBOOK_POLAR = require("scrapbook_polar")
for k, v in pairs(SCRAPBOOK_POLAR) do
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