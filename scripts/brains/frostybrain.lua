require("behaviours/chaseandattack")
require("behaviours/wander")
require("behaviours/doaction")
require("behaviours/attackwall")
require("behaviours/leash")
require("behaviours/faceentity")

local CHASE_DIST = 32
local CHASE_TIME = 20

-- local OUTSIDE_CATAPULT_RANGE = TUNING.WINONA_CATAPULT_MAX_RANGE + TUNING.WINONA_CATAPULT_KEEP_TARGET_BUFFER + TUNING.MAX_WALKABLE_PLATFORM_RADIUS + 1
-- local function OceanChaseWaryDistance(inst, target) -- TODO
--     -- We already know the target is on water. We'll approach if our attack can reach, but stay away otherwise.
--     return (CanProbablyReachTargetFromShore(inst, target, TUNING.DEERCLOPS_ATTACK_RANGE - 0.25) and 0) or OUTSIDE_CATAPULT_RANGE
-- end

local FrostyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function FrostyBrain:OnStart()
    local root = PriorityNode({
            -- ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST, nil, nil, nil, OceanChaseWaryDistance),
            ChaseAndAttack(self.inst, CHASE_TIME, CHASE_DIST),
            Wander(self.inst, nil, 30),
		}, 0.5)

    self.bt = BT(self.inst, root)
end

return FrostyBrain