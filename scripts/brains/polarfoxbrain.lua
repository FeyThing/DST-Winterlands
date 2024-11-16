require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"

local BrainCommon = require("brains/braincommon")

local PolarFoxBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function PolarFoxBrain:OnStart()
	local root = PriorityNode({
		--BrainCommon.PanicTrigger(self.inst),
		
		StandStill(self.inst),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return PolarFoxBrain