local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Pushable = require("components/pushable")
	
	local OldStartPushing = Pushable.StartPushing
	function Pushable:StartPushing(doer, ...)
		local test = OldStartPushing(self, doer, ...)
		
		if self.inst.components.snowwavemelter then
			self.inst.components.snowwavemelter.melt_push = true
			self.inst.components.snowwavemelter:StartMelting()
		end
		
		return test
	end
	
	local OldStopPushing = Pushable.StopPushing
	function Pushable:StopPushing(doer, ...)
		if self.inst.components.snowwavemelter then
			self.inst.components.snowwavemelter:StopMelting()
			self.inst.components.snowwavemelter.melt_push = nil
		end
		
		return OldStopPushing(self, doer, ...)
	end