local Levels = require("map/levels")
local StartLocations = require("map/startlocations")
local TaskSets = require("map/tasksets")

local deepcopy = GLOBAL.deepcopy
local STRINGS = GLOBAL.STRINGS
require("polar_strings/strings")

local polar_tasks = {"Polar Village", math.random() <= 0.66 and "Polar Lands" or "Polar Deciduous Lands", "Polar Caves"}
local polar_start_required_tasks = {"Polar Floe", "Polar Quarry"}

--	Add Island, Setpieces, ...

require("map/tasks/polar")

AddTaskSetPreInitAny(function(self)
	if GLOBAL.WINTERLANDS_TYPE == "skip" then
		return
	end
	
	local winterlands_preset = self.name == STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.POLAR
	
	if GLOBAL.Polar_CompatibleShard(self.location) then
		for i, task in ipairs(polar_tasks) do
			table.insert(self.tasks, task)
		end
		
		for task, chance in pairs(TUNING.POLAR_TASKS_OPTIONALITY) do
			if (winterlands_preset and table.contains(polar_start_required_tasks, task)) or math.random() < chance then
				table.insert(self.tasks, task)
			end
		end
		
		self.set_pieces["PolarAmulet_Shack"] = {count = 1, tasks = {"Polar Lands", "Polar Deciduous Lands", "Polar Village", "Polar Quarry"}}
		self.set_pieces["PolarFox_Duo"] = {count = 1, tasks = {"Polar Lands", "Polar Village", "Polar Quarry"}}
		self.set_pieces["PolarFox_Solo"] = {count = 3, tasks = {"Polar Lands", "Polar Village", "Polar Quarry"}}
		
		if math.random() < 0.5 then
			self.set_pieces["skeleton_beartrapped"] = {count = 1, tasks = {"Polar Lands", "Polar Deciduous Lands"}}
		else
			self.set_pieces["skeleton_icicle"] = {count = 1, tasks = {"Polar Caves"}}
		end
		if math.random() < 0.33 then
			self.set_pieces["arrowsigns_polarvillages"] = {count = 1, tasks = {"Polar Lands", "Polar Deciduous Lands", "Polar Village"}}
		end
		
		if self.required_prefabs == nil then
			self.required_prefabs = {}
		end
		
		table.insert(self.required_prefabs, "polaramulet_station")
		table.insert(self.required_prefabs, "polarbearhouse_village")
		table.insert(self.required_prefabs, "wysp_skeleton_marker")
	end
end)

AddRoomPreInit("OceanRough", function(self)
	if GLOBAL.Polar_CompatibleShard("forest") then
		if self.contents.countstaticlayouts == nil then
			self.contents.countstaticlayouts = {}
		end
		
		self.contents.countstaticlayouts["BearOnIce"] = function() return math.random(0, 1) end
	end
end)

AddRoomPreInit("OceanCoastal", function(self)
	if GLOBAL.Polar_CompatibleShard("forest") then
		if self.contents.countprefabs == nil then
			self.contents.countprefabs = {}
		end
		
		self.contents.countprefabs["rock_ice_spawner_polar"] = 60
	end
end)

--	World Settings

--AddCustomizeGroup(LEVELCATEGORY.SETTINGS, "polar", STRINGS.UI.SANDBOXMENU.WORLDSETTINGS_POLAR, nil, nil, 4.1)
--AddCustomizeGroup(LEVELCATEGORY.WORLDGEN, "polar", STRINGS.UI.SANDBOXMENU.WORLDGENERATION_POLAR, nil, nil, 3.1)

for k, v in pairs(require("map/polar_customizations")) do
	AddCustomizeItem(v.category, v.group, v.name, {
		value = v.value,
		desc = type(v.desc) == "string" and GetCustomizeDescription(v.desc) or v.desc,
		world = v.world or {"forest", "cave", "shipwrecked", "volcanoworld", "porkland"},
		image = v.image,
		atlas = "images/worldgen_polar.xml",
		masteroption = v.masteroption, master_controlled = v.master_controlled, order = v.order
	})
end

--	Bunches

local Bunches = require("map/bunches").Bunches
local Polar_Bunches = require("map/polar_bunches").Bunches

for k, bunch in pairs(Polar_Bunches) do
	Bunches[k] = bunch
end

--	Winterlands Start

local polar_start = deepcopy(StartLocations.GetStartLocation("default")) or {}

polar_start.name = STRINGS.UI.SANDBOXMENU.POLARSTART

AddStartLocation("polar", polar_start)

--

local polar_level = deepcopy(Levels.GetDataForLevelID("SURVIVAL_TOGETHER")) or {}

polar_level.id = "SURVIVAL_POLAR"
polar_level.name = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS.SURVIVAL_POLAR
polar_level.desc = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC.SURVIVAL_POLAR

if polar_level.overrides == nil then
	polar_level.overrides = {}
end

polar_level.overrides.polar_throne = "yearly"
polar_level.overrides.season_start = "winter"
polar_level.overrides.start_location = "polar"
polar_level.overrides.task_set = "polar"

AddLevel(LEVELTYPE.SURVIVAL, polar_level)

local OldChooseSetPieces = GLOBAL.Level.ChooseSetPieces
GLOBAL.Level.ChooseSetPieces = function(self, ...)
	local start_location = self.overrides and self.overrides.start_location
	if start_location == "polar" then
		if self.set_pieces == nil then
			self.set_pieces = {}
		end
		self.set_pieces["PolarStart"] = {count = 1, tasks = {"Polar Village", "Polar Lands", "Polar Deciduous Lands"}}
		
		if self.required_prefabs == nil then
			self.required_prefabs = {}
		end
		if not table.contains(self.required_prefabs, "spawnpoint_polar") then
			table.insert(self.required_prefabs, "spawnpoint_polar")
		end
	end
	
	OldChooseSetPieces(self, ...)
end

--

local polar_taskset = deepcopy(TaskSets.GetGenTasks("default")) or {}

if polar_taskset.required_prefabs == nil then
	polar_taskset.required_prefabs = {}
end

if polar_taskset.set_pieces == nil then
	polar_taskset.set_pieces = {}
end

polar_taskset.name = STRINGS.UI.CUSTOMIZATIONSCREEN.TASKSETNAMES.POLAR

polar_taskset.set_pieces["skeleton_polar"] = {count = 1, tasks = {"Polar Lands", "Polar Floe", "Polar Quarry"}}

AddTaskSet("polar", polar_taskset)