local customizations = {
--	WORLDSETTINGS
--	moose_polar = 		{category = LEVELCATEGORY.SETTINGS},
	polar_icicles = 	{category = LEVELCATEGORY.SETTINGS},
	polarbears = 		{category = LEVELCATEGORY.SETTINGS},
	polarfoxes = 		{category = LEVELCATEGORY.SETTINGS},
	tumbleweed_polar = 	{category = LEVELCATEGORY.SETTINGS},
	
--	WORLDGEN
	antler_trees = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	grass_polar = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	polarbearhouses = 	{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
	rocks_polar = 		{category = LEVELCATEGORY.WORLDGEN, desc = "worldgen_frequency_descriptions"},
}

--

local map = require("map/forest_map")
local TRANSLATE_TO_PREFABS = map.TRANSLATE_TO_PREFABS
local TRANSLATE_AND_OVERRIDE = map.TRANSLATE_AND_OVERRIDE

TRANSLATE_TO_PREFABS["antler_trees"] = 		{"antler_tree", "antler_tree_burnt", "antler_tree_stump"}
TRANSLATE_TO_PREFABS["grass_polar"] = 		{"grass_polar", "grass_polar_spawner"}
TRANSLATE_TO_PREFABS["polarbearhouses"] = 	{"polarbearhouse"}
TRANSLATE_TO_PREFABS["polar_icicles"] = 	{"polar_icicle", "polar_icicle_rock"}
TRANSLATE_TO_PREFABS["rocks_polar"] = 		{"rock_polar"}

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

WSO.Pre.polarfoxes = function(difficulty)
	local tuning_vars = {
		never = 	{POLARFOX_ENABLED = false},
		few = 		{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME * 2, POLARFOX_SPAWN_TIME_VARIATION = TUNING.TOTAL_DAY_TIME * 2},
		--default = {POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME},
		many = 		{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 2},
		always = 	{POLARFOX_SPAWN_TIME = TUNING.TOTAL_DAY_TIME / 4},
	}
	OverrideTuningVariables(tuning_vars[difficulty])
end

--

for k, v in pairs(customizations) do
	v.name = k
	
	v.category = v.category
	v.group = v.group or "polar"
	
	v.value = v.value or "default"
	v.desc = v.desc or "frequency_descriptions"
	v.world = v.world or {"forest"}
end

return customizations