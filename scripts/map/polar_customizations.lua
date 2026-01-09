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
	icelettuce_regrowth = 	{category = LEVELCATEGORY.SETTINGS, desc = "speed_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
	polar_icicles = 		{category = LEVELCATEGORY.SETTINGS, group = "misc", world = {"forest", "shipwrecked", "porkland"}},
	polar_throne = 			{category = LEVELCATEGORY.SETTINGS, group = "global", desc = descriptions.polarthrone_descriptions, world = {"forest", "shipwrecked", "porkland"}, order = 13.1},
	polarbears = 			{category = LEVELCATEGORY.SETTINGS, group = "animals"},
	polarfleas = 			{category = LEVELCATEGORY.SETTINGS, group = "monsters"},
	polarflea_mother = 		{category = LEVELCATEGORY.SETTINGS, group = "giants"},
	polarfoxes = 			{category = LEVELCATEGORY.SETTINGS, group = "animals", world = {"forest", "shipwrecked", "porkland"}},
	tumbleweed_polar = 		{category = LEVELCATEGORY.SETTINGS, group = "misc", world = {"forest", "shipwrecked", "porkland"}},
	
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
		never = 	{ICELETTUCE_REGROWTH_CHANCE = 0, ICELETTUCE_REGROWTH_MAX_QUANTITY = 0, ICELETTUCE_REGROWTH_MIN_QUANTITY = 0},
		veryslow = 	{ICELETTUCE_REGROWTH_CHANCE = 0.1, ICELETTUCE_REGROWTH_MAX_QUANTITY = 2, ICELETTUCE_REGROWTH_MIN_QUANTITY = 1},
		slow = 		{ICELETTUCE_REGROWTH_CHANCE = 0.18, ICELETTUCE_REGROWTH_MAX_QUANTITY = 5, ICELETTUCE_REGROWTH_MIN_QUANTITY = 2},
		--default = {ICELETTUCE_REGROWTH_CHANCE = 0.25, ICELETTUCE_REGROWTH_MAX_QUANTITY = 10, ICELETTUCE_REGROWTH_MIN_QUANTITY = 3, ICELETTUCE_REGROWTH_SEASONS = {"summer"}},
		fast = 		{ICELETTUCE_REGROWTH_CHANCE = 0.66, ICELETTUCE_REGROWTH_MAX_QUANTITY = 15, ICELETTUCE_REGROWTH_MIN_QUANTITY = 5, ICELETTUCE_REGROWTH_SEASONS = {"autumn", "summer"}},
		veryfast = 	{ICELETTUCE_REGROWTH_CHANCE = 0.9, ICELETTUCE_REGROWTH_MAX_QUANTITY = 20, ICELETTUCE_REGROWTH_MIN_QUANTITY = 10, ICELETTUCE_REGROWTH_SEASONS = {"autumn", "winter", "spring", "summer"}},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polar_icicles = function(difficulty)
	local tuning_vars = {
		never = 	{POLAR_ICICLE_ENABLED = false},
		few = 		{POLAR_MAX_ICICLES = 2, POLAR_WORLD_MAXICICLES = 30},
		--default = {POLAR_MAX_ICICLES = 5, POLAR_WORLD_MAXICICLES = 100},
		many = 		{POLAR_MAX_ICICLES = 7, POLAR_WORLD_MAXICICLES = 120},
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
		few = 		{POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 6},
		--default = {POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 4},
		many = 		{POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2},
		always = 	{POLARBEARHOUSE_SPAWN_TIME = TUNING.TOTAL_DAY_TIME},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarfleas = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFLEA_WORLD_MAXFLEAS = 0, POLARFLEA_HOUNDED_MAX = 0},
		few = 		{POLARFLEA_WORLD_MAXFLEAS = 25, GRASS_POLAR_FLEA_CHANCE = 0.1, POLARFLEA_HOUNDED_MAX = 1},
		--default = {POLARFLEA_WORLD_MAXFLEAS = 100, GRASS_POLAR_FLEA_CHANCE = 0.2, POLARFLEA_HOUNDED_MIN = 0, POLARFLEA_HOUNDED_MAX = 3},
		many = 		{POLARFLEA_WORLD_MAXFLEAS = 150, GRASS_POLAR_FLEA_CHANCE = 0.4, POLARFLEA_HOUNDED_MAX = 5},
		always = 	{POLARFLEA_WORLD_MAXFLEAS = 300, GRASS_POLAR_FLEA_CHANCE = 0.8, POLARFLEA_HOUNDED_MIN = 1, POLARFLEA_HOUNDED_MAX = 5},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarflea_mother = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 1, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0},
		few = 		{POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.2, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.01},
		--default = {POLARFLEA_MOTHER_SPAWN_CHANCE = 0, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.1, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.01},
		many = 		{POLARFLEA_MOTHER_SPAWN_CHANCE = 0.02, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.05, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.02},
		always = 	{POLARFLEA_MOTHER_SPAWN_CHANCE = 0.05, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_DECAY = 0.01, POLARFLEA_MOTHER_FLEAS_SPAWNCHANCE_KILL = 0.03},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.polarfoxes = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFOX_ENABLED = false},
		few = 		{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2, POLARFOX_SPAWN_TIME_VARIATION = TUNING.TOTAL_DAY_TIME * 2, POLARFOX_MIN_SPAWN_POINTS = 3},
		--default = {POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME, POLARFOX_MIN_SPAWN_POINTS = 6},
		many = 		{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 2, POLARFOX_MIN_SPAWN_POINTS = 9},
		always = 	{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 4, POLARFOX_MIN_SPAWN_POINTS = 15},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

WSO.Pre.tumbleweed_polar = function(difficulty)
	local tuning_vars = {
		never = 	{TUMBLEWIND_ENABLED = false},
		few = 		{TUMBLEWIND_SPAWNRATE_EARLY = 4, TUMBLEWIND_SPAWNRATE_LATER = 20},
		--default = {TUMBLEWIND_SPAWNRATE_EARLY = 1, TUMBLEWIND_SPAWNRATE_LATER = 6},
		many = 		{TUMBLEWIND_SPAWNRATE_EARLY = 1, TUMBLEWIND_SPAWNRATE_LATER = 4},
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

return customizations