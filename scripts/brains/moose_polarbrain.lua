require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/chaseandram"
require "behaviours/faceentity"
require "behaviours/runaway"

local BrainCommon = require("brains/braincommon")

local MAX_CHARGE_TIME = nil
local MAX_CHARGE_DIST = 12
local CHARGE_GIVEUP_DIST = 20

local MAX_CHASE_TIME = 5
local CHASE_GIVEUP_DIST = 10

local START_FACE_DIST = 8
local KEEP_FACE_DIST = 10

local wandertimes = {
	minwalktime = 3,
	randwalktime = 5,
	minwaittime = 5,
	randwaittime = 10,
}

local function GetFaceTargetFn(inst)
	if inst.components.combat and inst.components.combat.target then
		return inst.components.combat.target
	end
	
	if not BrainCommon.ShouldSeekSalt(inst) and not (inst.components.timer and inst.components.timer:TimerExists("alertcooldown")) then
		local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
		return target and not target:HasTag("notarget") and target or nil
	end
end

local function KeepFaceTargetFn(inst, target)
	if inst.components.combat and inst.components.combat.target == target then
		return true
	end
	
	return not BrainCommon.ShouldSeekSalt(inst) and not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
		and not (inst.components.timer and inst.components.timer:TimerExists("alertcooldown"))
end

local Moose_PolarBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function Moose_PolarBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		WhileNode(function() return self.inst.hasantler and (not self.inst.components.combat.target or not self.inst.components.combat:InCooldown()) end, "Ram Attack",
			ChaseAndRam(self.inst, MAX_CHARGE_TIME, CHARGE_GIVEUP_DIST, MAX_CHARGE_DIST)),
		WhileNode(function() return not self.inst.hasantler end, "Cringe Attack",
			ChaseAndAttack(self.inst, MAX_CHASE_TIME, CHASE_GIVEUP_DIST)),
		
		WhileNode(function() return self.inst:HasTag("spectermoose") and (not self.inst.components.combat.target or not self.inst.components.combat:InCooldown()) end, "Evade",
			RunAway(self.inst, "character", 5, 25)),
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
		
		BrainCommon.AnchorToSaltlick(self.inst),
		Wander(self.inst, nil, nil, wandertimes),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Moose_PolarBrain