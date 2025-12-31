local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Rideable = require("components/rideable")
local OldRideable_ctor = Rideable._ctor

local function OnBearTrapped(inst, data)
	if data and data.captured and inst.components.rideable and inst.components.rideable:GetRider() then
		inst.components.rideable:Buck()
	end
end

Rideable._ctor = function(self, inst, ...)
	OldRideable_ctor(self, inst, ...)
	
	self.OnBearTrapped = OnBearTrapped
	
	inst:ListenForEvent("walrus_beartrapped", self.OnBearTrapped)
end