require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/follow"

local BrainCommon = require("brains/braincommon")

local RUN_AWAY_COMBAT_DIST = 10
local RUN_AWAY_DIST = 6
local STOP_RUN_AWAY_DIST = 25

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 7
local TARGET_FOLLOW_DIST = 5
local TARGET_FAR_DIST = TUNING.POLARFOX_LEADER_RUN_DIST

local SEE_FOOD_DIST = 10

local AVOID_TAGS = {"scarytoprey", "hostile"}
local AVOID_NOT_TAGS = {"INLIMBO", "companion", "shadowcreature", "brightmare_gestalt"}
local FINDFOOD_CANT_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach", "show_spoiled"}

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

local function GetFarLeader(inst)
	local leader = GetLeader(inst)
	
	if leader == nil then
		return
	end
	
	if inst:GetDistanceSqToInst(leader) >= TARGET_FAR_DIST or (inst.sg and inst.sg:HasStateTag("running")) or inst:GetCurrentPlatform() ~= leader:GetCurrentPlatform() then
		return leader
	end
end

local function KeepLeader(inst, target)
	return GetLeader(inst) == target
end

local function CanChill(inst, cansit)
	if inst.wantstoalert or (inst.sg and (inst.sg.statemem.alerted or inst.sg:HasStateTag("alert") or inst.sg:HasStateTag("sniffing"))) then
		return false
	end
	
	return not inst.sg:HasStateTag("sitting") or cansit
end

local function FindFoodAction(inst)
	if inst.components.eater == nil or inst.sg:HasStateTag("busy") or not CanChill(inst, true) then
		return
	end
	
	inst._can_eat_test = inst._can_eat_test or function(item)
		return inst.components.eater:CanEat(item) and FindEntity(item, 4, nil, AVOID_NOT_TAGS, AVOID_TAGS) == nil
	end
	
	local target = (inst.components.inventory and inst.components.inventory:FindItem(inst._can_eat_test)) or nil
	local time_since_eat = inst.components.eater:TimeSinceLastEating()
	
	if not target and (not time_since_eat or time_since_eat > TUNING.SEG_TIME) then
		target = FindEntity(inst, SEE_FOOD_DIST, function(item)
			return item.components.edible and inst.components.eater:CanEat(item) and item:GetTimeAlive() >= 8 and item:IsOnPassablePoint()
		end, nil, FINDFOOD_CANT_TAGS)
	end
	
	return (target and BufferedAction(inst, target, ACTIONS.EAT)) or nil
end

local function ShouldRunAway(target, inst)
	local dist = inst:GetDistanceSqToInst(target)
	local leader = GetLeader(inst)
	
	if target.components.health and target.components.health:IsDead() then
		return false
	elseif not target:HasTag("hostile") and target:HasTag("scarytoprey") and leader ~= nil then
		return false
	end
	
	if inst._trusted_survivors and inst._trusted_survivors[target.prefab] then
		return false
	end
	
	if inst.components.combat and inst.components.combat.target == target and dist < RUN_AWAY_COMBAT_DIST * RUN_AWAY_COMBAT_DIST then
		inst._trusted_foods = {}
		return true
	end
	
	if dist < RUN_AWAY_DIST * RUN_AWAY_DIST then
		inst._trusted_foods = {}
		return true
	end
	
	return false
end

local function WanderPointFn(pt) -- TODO: I guess that doesn't work the way I thought
	if pt and TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z) then
		return true
	end
	
	return false
end

function PolarFoxBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicWhenScared(self.inst, 1),
		BrainCommon.PanicTrigger(self.inst),
		RunAway(self.inst, {fn = ShouldRunAway, oneoftags = AVOID_TAGS, notags = AVOID_NOT_TAGS}, RUN_AWAY_COMBAT_DIST, STOP_RUN_AWAY_DIST),
		WhileNode(function() return GetFarLeader(self.inst) end, "LeaderIsFar",
			Follow(self.inst, GetFarLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, true)),
		Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, false),
		DoAction(self.inst, FindFoodAction, "Eat Food"),
		WhileNode(function() return CanChill(self.inst) end, "Chilling",
			Wander(self.inst, nil, 5, wandertimes, nil, nil, WanderPointFn)),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return PolarFoxBrain