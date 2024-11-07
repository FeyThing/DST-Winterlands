require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"

local Shadow_IciclerBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function Shadow_IciclerBrain:OnStart()
	local root = PriorityNode({
		
	}, 0.25)

	self.bt = BT(self.inst, root)
end

return Shadow_IciclerBrain