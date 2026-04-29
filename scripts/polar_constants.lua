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
table.insert(TechTree.AVAILABLE_TECH, "WANDERINGWALRUSSHOP")
table.insert(TechTree.AVAILABLE_TECH, "POLARBEARKING_TRIALS")

for k, v in pairs(TUNING.PROTOTYPER_TREES) do
	v.POLARAMULET_STATION = 0
	v.WANDERINGWALRUSSHOP = 0
	v.POLARBEARKING_TRIALS = 0
end

for k, v in pairs(AllRecipes) do
	v.level.POLARAMULET_STATION = 0
	v.level.WANDERINGWALRUSSHOP = 0
	v.level.POLARBEARKING_TRIALS = 0
end

TECH.NONE.POLARAMULET_STATION = 0
TECH.NONE.WANDERINGWALRUSSHOP = 0
TECH.NONE.POLARBEARKING_TRIALS = 0

TECH.ARCTIC_FOOLS = {SCIENCE = 10}
TECH.POLARAMULET_STATION = {POLARAMULET_STATION = 1}
TECH.WANDERINGWALRUSSHOP = {WANDERINGWALRUSSHOP = 1}
TECH.POLARBEARKING_TRIALS = {POLARBEARKING_TRIALS = 1}

TECH_INGREDIENT.POLARSNOW = "polarsnow_material"
TECH_INGREDIENT.POLARBEAR = "polarbear_material"

POLARAMULET_STATION_MOONPHASE_TRADEDATA = {
	new = {
		{product = "charcoal", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 6, max = 12}},
		{product = "nitre", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 4, max = 8}},
		{product = "bird_egg", 			ingredients = {Ingredient("boneshard", 1)}, 	limits = {min = 3, max = 6}},
	},
	quarter = {
		{product = "twigs", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 6, max = 12}},
		{product = "rocks", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 4, max = 8}},
		{product = "berries", 			ingredients = {Ingredient("boneshard", 1)}, 	limits = {min = 3, max = 6}},
	},
	half = {
		{product = "cutreeds", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 6, max = 12}},
		{product = "flint", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 4, max = 8}},
		{product = "monstermeat", 		ingredients = {Ingredient("boneshard", 1)}, 	limits = {min = 3, max = 6}},
	},
	threequarter = {
		{product = "log", 				ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 6, max = 12}},
		{product = "goldnugget", 		ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 1, max = 2}},
		{product = "red_cap", 			ingredients = {Ingredient("boneshard", 1)}, 	limits = {min = 3, max = 6}}, -- TODO: Change to white shrooms later ?
	},
	full = {
		{product = "cutgrass", 			ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 9, max = 18}},
		{product = "bluegem_shards", 	ingredients = {Ingredient("houndstooth", 1)}, 	limits = {min = 3, max = 6}},
		{product = "glommerfuel", 		ingredients = {Ingredient("spoiled_food", 1), Ingredient("spoiled_fish", 1), Ingredient("rottenegg", 1)}, limits = {min = 3, max = 3}, description = "polar_trade_glommerfuel"},
	},
}

POLARWALRUS_TRADEDATA = { -- Note: Default chance for each trade is 50%, respect same min/max stock on the same product !
	walrus = {
		{product = "blowdart_pipe",	 				ingredients = {Ingredient("smallmeat", 2)}, 							limits = {min = 3, max = 4}, chance = 1},
		{product = "blowdart_sleep",				ingredients = {Ingredient("smallmeat", 1)}, 							limits = {min = 4, max = 6}, numtogive = 2, chance = 1},
		{product = "flint", 						ingredients = {Ingredient("fishmeat_small", 2)}, 						limits = {min = 1, max = 8}},
		{product = "goldnugget", 					ingredients = {Ingredient("fishmeat", 2)}, 								limits = {min = 5, max = 12}},
		{product = "goldnugget", 					ingredients = {Ingredient("trunk_summer", 1)}, 							limits = {min = 5, max = 12}, numtogive = 4, chance = 1},
		{product = "goldnugget", 					ingredients = {Ingredient("trunk_winter", 1)}, 							limits = {min = 5, max = 12}, numtogive = 5, chance = 1},
		{product = "nonslipgrit",					ingredients = {Ingredient("goldnugget", 1)}, 							limits = {min = 1, max = 3}},
		{product = "desiccant", 					ingredients = {Ingredient("goldnugget", 1)}, 							limits = {min = 1, max = 3}},
		{product = "walrushat",		 				ingredients = {Ingredient("polarbearfur", 2)}, 							limits = {min = 1, max = 1}, chance = 1},
		{product = "polarbear_rug_blueprint",		ingredients = {Ingredient("papyrus", 1), Ingredient("goldnugget", 1)}, 	limits = {min = 1, max = 1}, nameoverride = "walrustrade_polarbear_rug_blueprint", description = "WALRUSTRADE_BLUEPRINT", image = "blueprint_rare.tex"},
		{product = "bundlewrap_blueprint",			ingredients = {Ingredient("papyrus", 1), Ingredient("goldnugget", 4)}, 	limits = {min = 1, max = 1}, chance = 0.05, nameoverride = "walrustrade_bundlewrap_blueprint", description = "WALRUSTRADE_BLUEPRINT", image = "blueprint_rare.tex"},
		{product = "deserthat_blueprint",			ingredients = {Ingredient("papyrus", 1), Ingredient("goldnugget", 2)}, 	limits = {min = 1, max = 1}, chance = 0.05, nameoverride = "walrustrade_deserthat_blueprint", description = "WALRUSTRADE_BLUEPRINT", image = "blueprint_rare.tex"},
		{product = "dragonflyfurnace_blueprint", 	ingredients = {Ingredient("papyrus", 1), Ingredient("goldnugget", 3)}, 	limits = {min = 1, max = 1}, chance = 0.05, nameoverride = "walrustrade_dragonflyfurnace_blueprint", description = "WALRUSTRADE_BLUEPRINT", image = "blueprint_rare.tex"},
	},
	little_walrus = {
		{product = "smallmeat", 		ingredients = {Ingredient("ice", 2)}, 					limits = {min = 3, max = 8}, chance = 1},
		{product = "meat", 				ingredients = {Ingredient("ice", 4)}, 					limits = {min = 2, max = 4}},
		{product = "monstermeat", 		ingredients = {Ingredient("ice", 3)}, 					limits = {min = 1, max = 3}},
		{product = "saltrock", 			ingredients = {Ingredient("smallmeat_dried", 1)}, 		limits = {min = 3, max = 9}, numtogive = 2, chance = 1},
		{product = "saltrock", 			ingredients = {Ingredient("meat_dried", 1)}, 			limits = {min = 3, max = 9}, numtogive = 3, chance = 1},
		{product = "saltrock", 			ingredients = {Ingredient("fishmeat_small_dried", 1)}, 	limits = {min = 3, max = 9}, numtogive = 3, chance = 1},
		{product = "saltrock", 			ingredients = {Ingredient("fishmeat_dried", 1)}, 		limits = {min = 3, max = 9}, numtogive = 4, chance = 1},
		{product = "saltrock", 			ingredients = {Ingredient("monstermeat_dried", 1)}, 	limits = {min = 3, max = 9}, chance = 1},
		{product = "boneshard", 		ingredients = {Ingredient("goldnugget", 1)}, 			limits = {min = 2, max = 4}, chance = 1},
		{product = "houndstooth", 		ingredients = {Ingredient("flint", 1)}, 				limits = {min = 2, max = 4}, chance = 1},
		{product = "trunk_summer", 		ingredients = {Ingredient("saltrock", 4)}, 				limits = {min = 1, max = 1}},
		{product = "trunk_winter", 		ingredients = {Ingredient("saltrock", 5)}, 				limits = {min = 1, max = 1}},
	},
	girl_walrus = {
		{product = "walrus_beartrap", 	ingredients = {Ingredient("houndstooth", 4)}, 	limits = {min = 2, max = 3}, chance = 1},
		{product = "trap_teeth", 		ingredients = {Ingredient("flint", 2)}, 		limits = {min = 2, max = 5}, chance = 1},
		{product = "sewing_kit", 		ingredients = {Ingredient("boneshard", 3)}, 	limits = {min = 1, max = 1}, chance = 1},
		{product = "beefalowool", 		ingredients = {Ingredient("saltrock", 2)}, 		limits = {min = 1, max = 6}, chance = 1},
		{product = "pigskin", 			ingredients = {Ingredient("saltrock", 4)}, 		limits = {min = 1, max = 4}, chance = 1},
		{product = "polarbearfur", 		ingredients = {Ingredient("saltrock", 6)}, 		limits = {min = 1, max = 2}, chance = 1},
		{product = "steelwool", 		ingredients = {Ingredient("saltrock", 20)}, 	limits = {min = 1, max = 1}},
		{product = "saltrock", 			ingredients = {Ingredient("beefalowool", 1)}, 	limits = {min = 5, max = 10}, chance = 1},
		{product = "saltrock", 			ingredients = {Ingredient("pigskin", 1)}, 		limits = {min = 5, max = 10}, numtogive = 3, chance = 1},
		{product = "saltrock", 			ingredients = {Ingredient("polarbearfur", 1)}, 	limits = {min = 5, max = 10}, numtogive = 5, chance = 1},
		{product = "cookingrecipecard", ingredients = {Ingredient("goldnugget", 1)}, 	limits = {min = 1, max = 1}, nosharedstock = true, nameoverride = "cookingrecipecard_koalefried_trunk_summer", image = "cookingrecipecard.tex"},
		{product = "cookingrecipecard", ingredients = {Ingredient("goldnugget", 1)}, 	limits = {min = 1, max = 1}, nosharedstock = true, nameoverride = "cookingrecipecard_koalefried_trunk_winter", image = "cookingrecipecard.tex"},
	},
}

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
	{tag = "polarbear", sym = "pig_torso", 			ups = {2, 5}, 		scale = 1.1},
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

--ApplyExtraEvent(SPECIAL_EVENTS.ARCTIC_FOOLS) -- EVENT TOGGLE ! Keep this around about ~ 1 Week upon April's Fool :>

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

UPGRADETYPES.POLARFLEA_SACK = "polarflea_sack"

OCEAN_DEPTH.POLAR = 5

POLAR_SNOWMAN_HATS = {
	beefalohat = 2,
	polarmoosehat = 2,
	tophat = 1,
	winterhat = 2,
	
	bushhat = 1,
	deserthat = 1,
	minerhat = 1,
	scraphat = 1,
	
	cookiecutterhat = 0.5,
	footballhat = 0.5,
	icehat = 0.5,
	spiderhat = 0.5,
	
	--pumpkinhat = Added from unique setpiece when Halloween event is active, do not mix with random hats
}

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