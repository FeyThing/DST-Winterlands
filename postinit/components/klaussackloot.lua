local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local KlausSackLoot = require("components/klaussackloot")
local OldKlausSackLoot_ctor = KlausSackLoot._ctor

KlausSackLoot._ctor = function(self, ...)
	local OldRollKlausLoot = self.RollKlausLoot
	function self:RollKlausLoot(...)
		OldRollKlausLoot(self, ...)
		
		for i, bundle in ipairs(self.loot or {}) do
			for j, item in ipairs(bundle or {}) do
				if type(item) == "string" then
					local polar_stacksize = TUNING.KLAUSSACK_POLAR_STACKSIZES[item]
					
					if polar_stacksize then
						self.loot[i][j] = {item, polar_stacksize}
					end
				end
			end
		end
	end
	
	OldKlausSackLoot_ctor(self, ...)
end