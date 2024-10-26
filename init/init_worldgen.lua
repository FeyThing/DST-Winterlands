local ENV = env
GLOBAL.setfenv(1, GLOBAL)

require("map/tasks/polar")
local polar_tasks = {"Polar Village", "Polar Lands", "Polar Caves"}

ENV.AddTaskSetPreInitAny(function(self)
	if self.location == "forest" and self.tasks and #self.tasks > 1 then
		for i, v in ipairs(polar_tasks) do
			table.insert(self.tasks, v)
		end	
	end
end)