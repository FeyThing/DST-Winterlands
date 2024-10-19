local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddLevelPreInitAny = ENV.AddLevelPreInitAny
local AddTaskSetPreInitAny = ENV.AddTaskSetPreInitAny
local AddRoomPreInit = ENV.AddRoomPreInit
local AddTaskPreInit = ENV.AddTaskPreInit
local GetModConfigData = ENV.GetModConfigData

local tasks = require("map/tasks/winterlands")

local winter_tasks = {"Icy Fields", "Tundra", "Icy Pillars", "Cold Wastes"}

AddTaskSetPreInitAny(function(tasksetdata)
   		if tasksetdata.location == "forest" and tasksetdata.tasks and #tasksetdata.tasks > 1 then
			for i, setpieces in ipairs(winter_tasks) do
			table.insert(tasksetdata.tasks, setpieces)
			end	
   		end
end)



