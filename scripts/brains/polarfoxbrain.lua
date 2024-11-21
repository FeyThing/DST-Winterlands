require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"

local BrainCommon = require("brains/braincommon")

local FINDFOOD_CANT_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach", "show_spoiled"}

local PolarFoxBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function GetLeader(inst)
	return inst.components.follower.leader
end

local function FindFoodAction(inst)
	if inst.sg:HasStateTag("busy") then
		return
	end
	
	inst._can_eat_test = inst._can_eat_test or function(item)
		return inst.components.eater:CanEat(item)
	end
	
	local target = (inst.components.inventory and inst.components.eater and inst.components.inventory:FindItem(inst._can_eat_test)) or nil
	
	if not target then
		target = FindEntity(inst, SEE_FOOD_DIST, function(item)
			return item.components.edible and inst.components.eater:CanEat(item) and item:GetTimeAlive() >= 8 and item:IsOnPassablePoint()
		end, nil, FINDFOOD_CANT_TAGS)
	end
	
	local leader = GetLeader(inst)
	if leader == nil and inst.components.playerprox and inst.components.playerprox:IsPlayerClose() then
		return
	end
	
	if inst.sniffed_food and not inst.sniffed_food:IsValid() or inst.sniffed_food:IsInLimbo() then
		inst.sniffed_food = nil
	end
	
	local target_dist = target and inst:GetDistanceSqToInst(target) or 0
	if target and leader == nil and inst.sniffed_food == nil and target_dist <= 20 then
		inst.sg:GoToState("sniff", target)
	end
	
	return (target and BufferedAction(inst, target, ACTIONS.EAT)) or nil
end

local function GetFaceTargetFn(inst)
	return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
	return inst.components.follower.leader == target
end

function PolarFoxBrain:OnStart()
	local root = PriorityNode({
		--BrainCommon.PanicWhenScared(self.inst, 1),
		--BrainCommon.PanicTrigger(self.inst),
		IfNode(function() return GetLeader(self.inst) end, "HasLeader",
			FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn)),
		StandStill(self.inst),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return PolarFoxBrain