local customizations = {
--	WORLDSETTINGS
	polar_icicles = 	{category = LEVELCATEGORY.SETTINGS, group = "misc", world = {"forest", "shipwrecked", "porkland"}},
	polar_throne = 		{category = LEVELCATEGORY.SETTINGS, group = "global", desc = "yesno_descriptions", world = {"forest", "shipwrecked", "porkland"}, order = 13.1},
	polarbears = 		{category = LEVELCATEGORY.SETTINGS, group = "animals"},
	polarfleas = 		{category = LEVELCATEGORY.SETTINGS, group = "monsters"},
	polarfoxes = 		{category = LEVELCATEGORY.SETTINGS, group = "animals", world = {"forest", "shipwrecked", "porkland"}},
	tumbleweed_polar = 	{category = LEVELCATEGORY.SETTINGS, group = "misc", world = {"forest", "shipwrecked", "porkland"}},
	
--	WORLDGEN
	antler_trees = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
	grass_polar = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
	polarbearhouses = 	{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "animals", world = {"forest", "shipwrecked", "porkland"}},
	rocks_polar = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions", group = "resources", world = {"forest", "shipwrecked", "porkland"}},
}

--

local map = require("map/forest_map")
local TRANSLATE_TO_PREFABS = map.TRANSLATE_TO_PREFABS
local TRANSLATE_AND_OVERRIDE = map.TRANSLATE_AND_OVERRIDE

TRANSLATE_TO_PREFABS["antler_trees"] = 		{"antler_tree", "antler_tree_burnt", "antler_tree_stump"}
TRANSLATE_TO_PREFABS["polarbearhouses"] = 	{"polarbearhouse", "winter_tree_sparse"}
TRANSLATE_TO_PREFABS["polar_icicles"] = 	{"polar_icicle", "polar_icicle_rock"}
TRANSLATE_TO_PREFABS["rocks_polar"] = 		{"rock_polar"}

TRANSLATE_AND_OVERRIDE["grass_polar"] = 	{"grass_polar", "grass_polar_spawner"}

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

--

for k, v in pairs(customizations) do
	v.name = k
	
	v.category = v.category
	--v.group = v.group or "polar"
	
	v.value = v.value or "default"
	v.desc = v.desc or "frequency_descriptions"
end

return customizations