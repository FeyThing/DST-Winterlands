local descriptions = {
	polarthrone_descriptions = {
		{text = STRINGS.UI.SANDBOXMENU.DISABLED, 		data = "none"},
		{text = STRINGS.UI.SANDBOXMENU.ENABLED, 		data = "default"},
		{text = STRINGS.UI.SANDBOXMENU.THRONE_REFRESH, 	data = "yearly"},
	},
}

local customizations = {
--	WORLDSETTINGS
	antler_trees_regrowth = {category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions", group = "resources", image = "antler_trees.tex", world = {"forest", "shipwrecked", "porkland"}},
	arctic_fools = 			{category = LEVELCATEGORY.SETTINGS, desc = "extraevent_descriptions", group = "events", masteroption = true, master_controlled = true, order = 0.14},
	emperor_penguin = 		{category = LEVELCATEGORY.SETTINGS, group = "giants", world = {"forest"}},
	flowers_polar = 		{category = LEVELCATEGORY.SETTINGS, group = "polar", world = {"forest", "shipwrecked", "porkland"}}, -- group = "speed_descriptions"
	icelettuce_regrowth = 	{category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
	polar_icicles = 		{category = LEVELCATEGORY.SETTINGS, group = "polar", world = {"forest", "shipwrecked", "porkland"}}, -- group = "misc"
	polar_throne = 			{category = LEVELCATEGORY.SETTINGS, desc = descriptions.polarthrone_descriptions, group = "polar", world = {"forest", "shipwrecked", "porkland"}, order = 13.1}, -- group = "global"
	polarbears = 			{category = LEVELCATEGORY.SETTINGS, group = "animals"},
	polarfleas = 			{category = LEVELCATEGORY.SETTINGS, group = "monsters", master_controlled = true},
	polarflea_mother = 		{category = LEVELCATEGORY.SETTINGS, group = "giants", master_controlled = true},
	polarfoxes = 			{category = LEVELCATEGORY.SETTINGS, group = "animals", world = {"forest", "shipwrecked", "porkland"}},
	polarice = 				{category = LEVELCATEGORY.SETTINGS, group = "polar", masteroption = true, master_controlled = true}, -- group = "misc"
	polarsnow = 			{category = LEVELCATEGORY.SETTINGS, desc = "yesno_descriptions", group = "polar", masteroption = true, master_controlled = true}, -- group = "misc"
	polarsnow_melt = 		{category = LEVELCATEGORY.SETTINGS, group = "polar", masteroption = true, master_controlled = true}, -- group = "misc"
	polarstorms = 			{category = LEVELCATEGORY.SETTINGS, group = "polar", masteroption = true, master_controlled = true}, -- group = "misc"
	tumbleweed_polar = 		{category = LEVELCATEGORY.SETTINGS, group = "polar", world = {"forest", "shipwrecked", "porkland"}}, -- group = "misc"
	
--	WORLDGEN
	antler_trees = 			{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
	grass_polar = 			{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
	polarbearhouses = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "animals", world = {"forest", "shipwrecked", "porkland"}},
	rocks_polar = 			{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
}

for k, v in pairs(customizations) do
	v.name = k
	v.image = v.image or k..".tex"
	
	v.category = v.category
	--v.group = v.group or "polar"
	
	v.value = v.value or "default"
	v.desc = v.desc or "frequency_descriptions"
end

--

local map = require("map/forest_map")
local TRANSLATE_TO_PREFABS = map.TRANSLATE_TO_PREFABS
local TRANSLATE_AND_OVERRIDE = map.TRANSLATE_AND_OVERRIDE

TRANSLATE_TO_PREFABS["antler_trees"] = 			{"antler_tree", "antler_tree_burnt", "antler_tree_stump"}
TRANSLATE_TO_PREFABS["polarbearhouses"] = 		{"polarbearhouse", "polarbearhouse_village", "winter_tree_sparse"}
TRANSLATE_TO_PREFABS["polar_icicles"] = 		{"polar_icicle", "polar_icicle_rock"}
TRANSLATE_TO_PREFABS["rocks_polar"] = 			{"rock_polar"}

if TRANSLATE_TO_PREFABS["trees"] then
	table.insert(TRANSLATE_TO_PREFABS["trees"], "deciduoustree_polar")
end

TRANSLATE_AND_OVERRIDE["grass_polar"] = 		{"grass_polar", "grass_polar_spawner"}

--

local WSO = require("worldsettings_overrides")

local function OverrideTuningVariables(tuning)
	if tuning ~= nil then
		for k, v in pairs(tuning) do
			ORIGINAL_TUNING[k] = TUNING[k]
			TUNING[k] = v
		end
	end
end

WSO.Pre.antler_trees_regrowth = function(difficulty)
	local tuning_vars = {
		never = {ANTLER_TREE_REGROWTH_TIME_MULT = 0},
		veryslow = {ANTLER_TREE_REGROWTH_TIME_MULT = 0.25},
		slow = {ANTLER_TREE_REGROWTH_TIME_MULT = 0.5},
		--default = {ANTLER_TREE_REGROWTH_TIME_MULT = 1},
		fast = {ANTLER_TREE_REGROWTH_TIME_MULT = 1.5},
		veryfast = {ANTLER_TREE_REGROWTH_TIME_MULT = 3},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.icelettuce_regrowth = function(difficulty)
	local tuning_vars = {
		never = 	{ICELETTUCE_REGROWTH_CHANCE = 0, ICELETTUCE_REGROWTH_RANGE_SQ = 0},
		veryslow = 	{ICELETTUCE_REGROWTH_CHANCE = 0.25, ICELETTUCE_REGROWTH_RANGE_SQ = 16},
		slow = 		{ICELETTUCE_REGROWTH_CHANCE = 0.25, ICELETTUCE_REGROWTH_RANGE_SQ = 64},
		--default = {ICELETTUCE_REGROWTH_CHANCE = 0.5, ICELETTUCE_REGROWTH_RANGE_SQ = 140},
		fast = 		{ICELETTUCE_REGROWTH_CHANCE = 0.75, ICELETTUCE_REGROWTH_RANGE_SQ = 260},
		veryfast = 	{ICELETTUCE_REGROWTH_CHANCE = 1, ICELETTUCE_REGROWTH_RANGE_SQ = 400},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polar_icicles = function(difficulty)
	local tuning_vars = {
		never = 	{POLAR_ICICLE_ENABLED = false},
		rare = 		{POLAR_MAX_ICICLES = 2, POLAR_WORLD_MAXICICLES = 30},
		--default = {POLAR_MAX_ICICLES = 5, POLAR_WORLD_MAXICICLES = 100},
		often = 	{POLAR_MAX_ICICLES = 7, POLAR_WORLD_MAXICICLES = 120},
		always = 	{POLAR_MAX_ICICLES = 9, POLAR_WORLD_MAXICICLES = 150},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polar_throne = function(difficulty)
	local tuning_vars = {
		never = {SPAWN_POLAR_THRONE = false},
		--default = {SPAWN_POLAR_THRONE = true},
		yearly = {POLAR_THRONE_EZ_REFRESH = true},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarbears = function(difficulty)
	local tuning_vars = {
		never = 	{POLARBEARHOUSE_ENABLED = false},
		rare = 		{POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 6},
		--default = {POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 4},
		often = 	{POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2},
		always = 	{POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarfleas = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFLEA_WORLD_MAXFLEAS = 0, POLARFLEA_HOUNDED_MAX = 0},
		rare = 		{POLARFLEA_WORLD_MAXFLEAS = 25, GRASS_POLAR_FLEA_CHANCE = 0.1, POLARFLEA_HOUNDED_MAX = 1},
		--default = {POLARFLEA_WORLD_MAXFLEAS = 100, GRASS_POLAR_FLEA_CHANCE = 0.2, POLARFLEA_HOUNDED_MIN = 0, POLARFLEA_HOUNDED_MAX = 3},
		often = 	{POLARFLEA_WORLD_MAXFLEAS = 150, GRASS_POLAR_FLEA_CHANCE = 0.4, POLARFLEA_HOUNDED_MAX = 5},
		always = 	{POLARFLEA_WORLD_MAXFLEAS = 300, GRASS_POLAR_FLEA_CHANCE = 0.8, POLARFLEA_HOUNDED_MIN = 1, POLARFLEA_HOUNDED_MAX = 5},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarflea_mother = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 1, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0},
		rare = 		{POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.2, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.01},
		--default = {POLARFLEA_MOTHER_SPAWN_CHANCE = 0, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.1, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.01},
		often = 	{POLARFLEA_MOTHER_SPAWN_CHANCE = 0.02, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.05, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.02},
		always = 	{POLARFLEA_MOTHER_SPAWN_CHANCE = 0.05, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.01, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.03},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarfoxes = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFOX_ENABLED = false},
		rare = 		{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2, POLARFOX_SPAWN_TIME_VARIATION = TUNING.TOTAL_DAY_TIME * 2, POLARFOX_MIN_SPAWN_POINTS = 3},
		--default = {POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME, POLARFOX_MIN_SPAWN_POINTS = 6},
		often = 	{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 2, POLARFOX_MIN_SPAWN_POINTS = 9},
		always = 	{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 4, POLARFOX_MIN_SPAWN_POINTS = 15},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.tumbleweed_polar = function(difficulty)
	local tuning_vars = {
		never = 	{TUMBLEWIND_ENABLED = false},
		rare = 		{TUMBLEWIND_SPAWNRATE_EARLY = 4, TUMBLEWIND_SPAWNRATE_LATER = 20},
		--default = {TUMBLEWIND_SPAWNRATE_EARLY = 1, TUMBLEWIND_SPAWNRATE_LATER = 6},
		often = 	{TUMBLEWIND_SPAWNRATE_EARLY = 1, TUMBLEWIND_SPAWNRATE_LATER = 4},
		always = 	{TUMBLEWIND_SPAWNRATE_EARLY = 1, TUMBLEWIND_SPAWNRATE_LATER = 2},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.emperor_penguin = function(difficulty)
	local tuning_vars = {
		never = {SPAWN_EMPEROR_PENGUIN = false},
		rare = {SPAWN_EMPEROR_PENGUIN_MOD = 0.5},
		--default = {SPAWN_EMPEROR_PENGUIN_MOD = 1, SPAWN_EMPEROR_PENGUIN = true},
		often = {SPAWN_EMPEROR_PENGUIN_MOD = 1.5},
		always = {SPAWN_EMPEROR_PENGUIN_MOD = 2},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.flowers_polar = function(difficulty)
	local tuning_vars = {
		never = 	{MAX_FLOWER_POLAR = 0},
		rare = 		{MAX_FLOWER_POLAR = 200},
		--default = {MAX_FLOWER_POLAR = 750},
		often = 	{MAX_FLOWER_POLAR = 1500},
		always = 	{MAX_FLOWER_POLAR = 3000},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarice = function(difficulty)
	local tuning_vars = {
		never = 	{POLAR_ICEGEN_CONFIG = -2},
		rare = 		{POLAR_ICEGEN_CONFIG = -1},
		--default = {POLAR_ICEGEN_CONFIG = 0},
		often = 	{POLAR_ICEGEN_CONFIG = 1},
		always = 	{POLAR_ICEGEN_CONFIG = 2},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarsnow = function(difficulty)
	local tuning_vars = {
		never = 	{POLAR_WAVES_ENABLED = false},
		--default = {POLAR_WAVES_ENABLED = true},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarsnow_melt = function(difficulty)
	local tuning_vars = {
		never = 	{POLAR_SNOW_MELT_TEMP = 999, POLAR_SNOW_MELT_TEMP_MAX = 1000},
		few = 		{POLAR_SNOW_MELT_TEMP = 90, POLAR_SNOW_MELT_TEMP_MAX = 120},
		--default = {POLAR_SNOW_MELT_TEMP = 50, POLAR_SNOW_MELT_TEMP_MAX = 90},
		many = 		{POLAR_SNOW_MELT_TEMP = 40, POLAR_SNOW_MELT_TEMP_MAX = 50},
		always = 	{POLAR_SNOW_MELT_TEMP = 20, POLAR_SNOW_MELT_TEMP_MAX = 40},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarstorms = function(difficulty)
	local tuning_vars = {
		never = 	{POLAR_BLIZZARDS_CONFIG = -2},
		few = 		{POLAR_BLIZZARDS_CONFIG = -1},
		--default = {POLAR_BLIZZARDS_CONFIG = 0},
		many = 		{POLAR_BLIZZARDS_CONFIG = 1},
		always = 	{POLAR_BLIZZARDS_CONFIG = 2},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

return customizations