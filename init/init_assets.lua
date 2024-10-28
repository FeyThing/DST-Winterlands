GLOBAL.POLAR_ATLAS = MODROOT.."images/polarimages.xml"

Assets = {
	Asset("IMAGE", "images/polarimages.tex"),
	Asset("ATLAS", "images/polarimages.xml"),
	Asset("ATLAS_BUILD", "images/polarimages.xml", 256),
	
	Asset("IMAGE", "images/polarminimap.tex"),
	Asset("ATLAS", "images/polarminimap.xml"),
	
	-- UI
	--Asset("IMAGE", "images/cookbook_polar.tex"),
	--Asset("ATLAS", "images/cookbook_polar.xml"),
	
	Asset("IMAGE", "images/scrapbook_polar.tex"),
	Asset("ATLAS", "images/scrapbook_polar.xml"),
	
	Asset("ANIM", "anim/meter_polar_over.zip"),
	
	-- Anims / Builds
	Asset("ANIM", "anim/polar_snow.zip"),
	
	Asset("IMAGE", "images/polarpillar.tex"),
	
	-- Sounds
	Asset("SOUNDPACKAGE", "sound/polarsounds.fev"),
	Asset("SOUND", "sound/polarsounds.fsb"),
}

AddMinimapAtlas("images/polarminimap.xml")

AddSimPostInit(function()
	modimport("postinit/shadeeffects")
end)

--	Inventory Images

local ITEMS = {
	"polar_dryice",
	"polarbearfur",
	"polarbearhouse",
	"turf_polar_dryice",
	"wall_polar_item",
}

--	Scrapbook Stuff

local scrapbook_prefabs = require("scrapbook_prefabs")
local scrapbookdata = require("screens/redux/scrapbookdata")

for i, v in pairs(ITEMS) do
	RegisterInventoryItemAtlas("images/polarimages.xml", v..".tex")
end

local SCRAPBOOK_POLAR = require("scrapbook_polar")
for k, v in pairs(SCRAPBOOK_POLAR) do
	v.name = k
	v.prefab = k
	v.tex = k..".tex"
	v.type = v.type or "things"
	
	if not (v.type == "item" or v.type == "food") then
		RegisterScrapbookIconAtlas(GLOBAL.resolvefilepath("images/scrapbook_polar.xml"), v.tex)
	end
	
	scrapbook_prefabs[k] = true
	scrapbookdata[k] = v
end