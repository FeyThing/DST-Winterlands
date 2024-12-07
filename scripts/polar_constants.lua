--	Crafting

local TechTree = require("techtree")

table.insert(TechTree.AVAILABLE_TECH, "POLARAMULET_STATION")

for k, v in pairs(TUNING.PROTOTYPER_TREES) do
	v.POLARAMULET_STATION = 0
end

for k, v in pairs(AllRecipes) do
	v.level.POLARAMULET_STATION = 0
end

TECH.NONE.POLARAMULET_STATION = 0

TECH.POLARAMULET_STATION = {POLARAMULET_STATION = 1}

--

POLARAMULET_PARTS = rawget(_G, "POLARAMULET_PARTS") or {}

local AMULET_PARTS = {
	gnarwail_horn = {build = "polar_amulet_items"},
	houndstooth = {build = "polar_amulet_items"},
	polarwargstooth = {build = "polar_amulet_items"},
	walrus_tusk = {build = "polar_amulet_items"},
}

local scrapbookdata = require("screens/redux/scrapbookdata")
for k, v in pairs(scrapbookdata) do
	if v.subcat == "ornament" then
		local sym = string.gsub(k, "^winter_ornament_", "")
		AMULET_PARTS[k] = {build = v.build, ornament = true, symbol = sym}
	end
end

for k, v in pairs(AMULET_PARTS) do
	POLARAMULET_PARTS[k] = v
end

--

NUM_POLARTRINKETS = 2

local POLAR_NAUGHTY_VALUE = {
	moose_polar = 4,
	polarbear = 3,
	polarfox = 6,
}

for k, v in pairs(POLAR_NAUGHTY_VALUE) do
	NAUGHTY_VALUE[k] = v
end

FUELTYPE.DRYICE = "DRYICE"

MATERIALS.DRYICE = "dryice"

OCEAN_DEPTH.POLAR = 5

TECH_INGREDIENT.POLARSNOW = "polarsnow_material"