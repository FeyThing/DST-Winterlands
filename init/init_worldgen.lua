require("map/tasks/polar")

local polar_tasks = {"Polar Village", "Polar Lands", "Polar Caves"}
local polar_optional = {"Polar Floe"} -- "Polar Lake"

local STRINGS = GLOBAL.STRINGS

--	Add Islands, Boons, ...

AddTaskSetPreInitAny(function(self)
	if self.location == "forest" and self.tasks and #self.tasks > 1 then
		for i, task in ipairs(polar_tasks) do
			table.insert(self.tasks, task)
		end
		for i, optional_task in ipairs(polar_optional) do
			local task_chance = TUNING.POLAR_TASKS_OPTIONALITY[optional_task] or 0
			if math.random() < task_chance then
				table.insert(self.tasks, optional_task)
			end
		end	
		
		local bear_town = "BearTown"..math.random(2)
		
		self.set_pieces[bear_town] = {count = 1, tasks = {"Polar Village"}}
		self.set_pieces["PolarAmulet_Shack"] = {count = 1, tasks = {"Polar Lands", "Polar Village"}}
		self.set_pieces["IcicleSkeleton"] = {count = 1, tasks = {"Polar Caves"}}
		self.set_pieces["PolarFox_Duo"] = {count = 1, tasks = {"Polar Lands", "Polar Caves", "Polar Village", "Polar Floe"}}
		self.set_pieces["PolarFox_Solo"] = {count = 4, tasks = {"Polar Lands", "Polar Caves", "Polar Village", "Polar Floe"}}
		
		if self.required_prefabs then
			table.insert(self.required_prefabs, "polaramulet_station")
		end
	end
end)

--	World Settings

AddCustomizeGroup(LEVELCATEGORY.SETTINGS, "polar", STRINGS.UI.SANDBOXMENU.WORLDSETTINGS_POLAR, nil, nil, 4.1)
AddCustomizeGroup(LEVELCATEGORY.WORLDGEN, "polar", STRINGS.UI.SANDBOXMENU.WORLDGENERATION_POLAR, nil, nil, 3.1)

for k, v in pairs(require("map/polar_customizations")) do
	if v.category == LEVELCATEGORY.SETTINGS then
		v.image = "worldsettings_"..v.name
	else
		v.image = "worldgen_"..v.name
	end
	AddCustomizeItem(v.category, v.group, v.name, {
		value = v.value,
		desc = GetCustomizeDescription(v.desc),
		world = v.world or {"forest"},
		image = v.image..".tex",
		atlas = "images/worldgen_polar.xml",
		masteroption = v.masteroption, master_controlled = v.master_controlled, order = v.order
	})
end