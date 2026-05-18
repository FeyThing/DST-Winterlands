local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WorldState = require("components/worldstate")
local OldWorldState_ctor = WorldState._ctor

WorldState._ctor = function(self, ...)
	OldWorldState_ctor(self, ...)
	
	if self.inst.event_listeners.snowcoveredchanged and self.inst.event_listeners.snowcoveredchanged[self.inst] then
		local OldOnSnowCoveredChanged = self.inst.event_listeners.snowcoveredchanged[self.inst][1]
		
		--	Entities in the Winterlands manage themselves. Preventing snow symbol to hide when the snow overlay clears (TheSim.HandleAllSnowSymbols)
		self.inst.event_listeners.snowcoveredchanged[self.inst][1] = function(...)
			
			local handled = {}
			for k, v in pairs(Ents) do
				if v.polar_snow_covered and v:HasTag("SnowCovered") then
					v:RemoveTag("SnowCovered")
					table.insert(handled, v)
				end
			end
			
			if OldOnSnowCoveredChanged then
				OldOnSnowCoveredChanged(...)
			end
			
			for i, v in pairs(handled) do
				v:AddTag("SnowCovered")
			end
		end
	end
end