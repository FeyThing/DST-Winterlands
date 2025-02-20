local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WateryProtection = require("components/wateryprotection")
local OldWateryProtection_ctor = WateryProtection._ctor

WateryProtection._ctor = function(self, ...)
	OldWateryProtection_ctor(self, ...)
	
	if self.inst:HasTag("wateringcan") then
		self:AddIgnoreTag("portable_brazier") -- This thing is high...
	end
end