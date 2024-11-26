require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"

local BrainCommon = require("brains/braincommon")

local FINDFOOD_CANT_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach", "show_spoiled"}

local RUN_AWAY_COMBAT_DIST = 10
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 25

local wandertimes = {
	minwalktime = 2,
	randwalktime = 3,
	minwaittime = 4,
	randwaittime = 12,
}

local PolarFoxBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function GetLeader(inst)
	return inst.components.follower and inst.components.follower.leader
end

local function KeepLeader(inst, target)
	return GetLeader(inst) == target
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

local function ShouldRunAway(target, inst)
	local dist = inst:GetDistanceSqToInst(target)
	
	if target.components.health and target.components.health:IsDead() then
		return false
	elseif target:HasTag("character") and GetLeader(inst) ~= nil then
		return false
	end
	
	if inst.components.combat and inst.components.combat.target == target and dist < RUN_AWAY_COMBAT_DIST * RUN_AWAY_COMBAT_DIST then
		return true
	end
	
	return dist < RUN_AWAY_DIST * RUN_AWAY_DIST
end

local function CanChill(inst)
	return inst.sg and not inst.sg.statemem.alerted and not inst.sg:HasStateTag("sitting") and not inst.sg:HasStateTag("alert") and not inst.wantstoalert
end

local function WanderPointFn(pt)
	if pt and TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z) then
		return true
	end
	
	return false
end

function PolarFoxBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicWhenScared(self.inst, 1),
		BrainCommon.PanicTrigger(self.inst),
		RunAway(self.inst, {fn = ShouldRunAway, oneoftags = {"hostile", "scarytoprey"}, notags = {"INLIMBO", "companion"}}, RUN_AWAY_COMBAT_DIST, STOP_RUN_AWAY_DIST),
		IfNode(function() return GetLeader(self.inst) end, "HasLeader",
			FaceEntity(self.inst, GetLeader, KeepLeader)),
		WhileNode(function() return CanChill(self.inst) end, "Chilling",
			Wander(self.inst, nil, 5, wandertimes, nil, nil, WanderPointFn)),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return PolarFoxBrain