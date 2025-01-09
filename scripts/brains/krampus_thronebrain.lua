require "behaviours/chaseandattack"
require "behaviours/panic"
require "behaviours/runaway"
require "behaviours/standstill"
require "behaviours/wander"

local BrainCommon = require("brains/braincommon")

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 40

local MIN_RUNAWAY = 6
local MAX_RUNAWAY = 12

local MAX_WANDER_DIST = 16

local Krampus_ThroneBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function Krampus_ThroneBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("polarthrone") end, MAX_WANDER_DIST),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Krampus_ThroneBrain