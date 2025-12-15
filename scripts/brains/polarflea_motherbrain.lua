require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/wander"
require "behaviours/chaseandattack"

local BrainCommon = require("brains/braincommon")

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 40
local MAX_WANDER_DIST = 40

local FLEA_TAGS = {"flea", "_combat"}
local FLEA_NOT_TAGS = {"epic", "INLIMBO", "isdead"}

local MIN_FLEAS_IN_RANGE = 7
local MIN_FLEAS_RANGE = 80 * 80

local PolarFlea_MotherBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function SpawnFleaEvent(inst)
	if not inst._wantstospawnfleas or (inst.sg and inst.sg:HasStateTag("busy")) then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local fleas = {}
	
	for follower in pairs(inst.components.leader.followers) do
		if follower:HasTag("flea") and follower:GetDistanceSqToPoint(x, y, z) <= MIN_FLEAS_RANGE then
			table.insert(fleas, follower)
		end
	end
	
	if #fleas < MIN_FLEAS_IN_RANGE then
		inst:PushEvent("fleathrowback")
	end
end

function PolarFlea_MotherBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		DoAction(self.inst, function() return SpawnFleaEvent(self.inst) end, "Spawn Fleas", true),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

function PolarFlea_MotherBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return PolarFlea_MotherBrain