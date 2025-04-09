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

TECH.ARCTIC_FOOLS = {SCIENCE = 10}
TECH.POLARAMULET_STATION = {POLARAMULET_STATION = 1}

TECH_INGREDIENT.POLARSNOW = "polarsnow_material"

--	Events

ARCTIC_FOOLS_MOBS = {
	daywalker = 		{sym = "ww_hunch", 			ups = {2}, 			scale = 1.4},
	daywalker2 = 		{sym = "ww_hunch", 			ups = {2}, 			scale = 1.4},
	hermitcrab = 		{sym = "torso", 			ups = {6, 7, 8}, 	scale = 0.7, 			offset = {0, -15, 0}},
	klaus = 			{sym = "klaus_body", 		ups = {2}, 			scale = 1.3},
	minotaur = 			{sym = "head", 				ups = {2}, 			scale = 1.4},
	sharkboi = 			{sym = "sharkboi_cloak", 	ups = {4}, 			scale = 1.4},
}

ARCTIC_FOOLS_TAGS = {--	Prioritize important tags first
	{tag = "player", 	sym = "torso", 				ups = {6, 7, 8}, 	scale = 0.7, 			offset = {0, -20, 0}},
	{tag = "bearger", 	sym = "bearger_body", 		ups = {5}, 			scale = 1.4},
	{tag = "deerclops", sym = "deerclops_body", 	ups = {1}, 			scale = 1.4},
	{tag = "leif", 		sym = "pieces", 			ups = {18}, 		scale = 1.3, 			face_up_only = true},
	{tag = "bear", 		sym = "pig_torso", 			ups = {2, 5}, 		scale = 1.1},
	{tag = "manrabbit", sym = "manrabbit_torso", 	ups = {2, 4}},
	{tag = "merm", 		sym = "pig_torso", 			ups = {2, 5}, 		nottags = {"mermking", "shadowminion"}},
	{tag = "pig", 		sym = "pig_torso", 			ups = {2, 5}},
	{tag = "rocky", 	sym = "hips", 				ups = {2}},
	{tag = "walrus", 	sym = "pig_torso", 			ups = {2, 5}},
	{tag = "bishop", 	sym = "shoulder", 			ups = {1}},
	{tag = "knight", 	sym = "neck", 				ups = {3}},
	{tag = "rook", 		sym = "head", 				ups = {2}, 			scale = 1.2},
	{tag = "penguin", 	sym = "body", 				ups = {7, 8}, 		scale = 0.8, 			offset = {0, 10, 0}},
}

SPECIAL_EVENTS.ARCTIC_FOOLS = "arctic_fools"

--	ApplyExtraEvent(SPECIAL_EVENTS.ARCTIC_FOOLS) -- Keep this around about ~ 1 Week upon April's Fool :>

--	Teeth Stuff

POLARAMULET_PARTS = rawget(_G, "POLARAMULET_PARTS") or {}

local AMULET_PARTS = {
	gnarwail_horn = 	{build = "polar_amulet_items", unlock_recipe = "frostwalkeramulet"},
	houndstooth = 		{build = "polar_amulet_items", unlock_recipe = "polaricestaff"},
	lavae_tooth = 		{build = "polar_amulet_items", unlock_recipe = "polar_lavae_tooth"},
	polarwargstooth = 	{build = "polar_amulet_items", unlock_recipe = "polarcrownhat"},
	walrus_tusk = 		{build = "polar_amulet_items", unlock_recipe = "iciclestaff"},
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