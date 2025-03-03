--	Tags, Counts

NUM_POLARTRINKETS = 2

POLARBEAR_FISHY_TAGS = {
	"merm",
	"gnarwail",
	"shark",
	"squid",
}

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

TECH_INGREDIENT.POLARSNOW = "polarsnow_material"

--	Teeth Stuff

POLARAMULET_PARTS = rawget(_G, "POLARAMULET_PARTS") or {}

local AMULET_PARTS = {
	gnarwail_horn = {build = "polar_amulet_items", unlock_recipe = "frostwalkeramulet"},
	houndstooth = {build = "polar_amulet_items", unlock_recipe = "polaricestaff"},
	lavae_tooth = {build = "polar_amulet_items", unlock_recipe = "polar_lavae_tooth"},
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

--	Naughty Things

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
	{}, 																			-- white
	{hue = 0.6, 	colormult = {157 / 255, 	72 / 255, 		64 / 255, 	1}}, 	-- red
	{hue = 0.4, 	colormult = {102 / 255, 	127 / 255, 		204 / 255, 	1}}, 	-- blue
	{hue = 0.35, 	colormult = {153 / 255, 	204 / 255, 		76 / 255, 	1}}, 	-- green
	{hue = 0.2, 	colormult = {204 / 255, 	153 / 255, 		76 / 255, 	1}}, 	-- yellow
	{hue = 0.85, 	colormult = {119 / 255, 	106 / 255, 		55 / 255, 	1}}, 	-- brown
	{hue = 0.8, 	colormult = {204 / 255, 	102 / 255, 		178 / 255, 	1}}, 	-- pink
}

--	Others

FUELTYPE.DRYICE = "DRYICE"

MATERIALS.DRYICE = "dryice"

OCEAN_DEPTH.POLAR = 5

POLARRIFY_MOD_SEASONS = {
	autumn = "autumn",
	winter = "winter",
	spring = "spring",
	summer = "summer",
	
	mild = "autumn",
	wet = "winter",
	green = "spring",
	dry = "summer",
	
	temperate = "autumn",
	humid = "winter",
	lush = "spring",
	aporkalypse = "summer",
}