local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local SnowballMelting = require("components/snowballmelting")
	
	local OldShouldMelt = SnowballMelting.ShouldMelt
	function SnowballMelting:ShouldMelt(...)
		if IsInPolar(self.inst) then
			return false
		end
		
		return OldShouldMelt(self, ...)
	end