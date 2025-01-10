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
	gnarwail_horn = {build = "polar_amulet_items", unlock_recipe = "frostwalkeramulet"},
	houndstooth = {build = "polar_amulet_items", unlock_recipe = "polaricestaff"},
	polarwargstooth = {build = "polar_amulet_items", unlock_recipe = "polarcrownhat"},
	walrus_tusk = {build = "polar_amulet_items", unlock_recipe = "iciclestaff"},
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
	moose_specter = 44,
	polarbear = 3,
	polarfox = 6,
}

for k, v in pairs(POLAR_NAUGHTY_VALUE) do
	NAUGHTY_VALUE[k] = v
end

KRAMPUS_UGLY_SWEATERS = {
	{}, 														-- white
	{hue = 0.6, 	colormult = {0.8, 	0, 		0, 		1}}, 	-- red
	{hue = 0.4, 	colormult = {0.4, 	0.5, 	0.8, 	1}}, 	-- blue
	{hue = 0.35, 	colormult = {0.6, 	0.8, 	0.3, 	1}}, 	-- green
	{hue = 0.2, 	colormult = {0.8, 	0.6, 	0.3, 	1}}, 	-- yellow
	{hue = 0.85, 	colormult = {0.35, 	0.3, 	0.1, 	1}}, 	-- brown
	{hue = 0.8, 	colormult = {0.8, 	0.4, 	0.7, 	1}}, 	-- pink
}

FUELTYPE.DRYICE = "DRYICE"

MATERIALS.DRYICE = "dryice"

OCEAN_DEPTH.POLAR = 5

TECH_INGREDIENT.POLARSNOW = "polarsnow_material"