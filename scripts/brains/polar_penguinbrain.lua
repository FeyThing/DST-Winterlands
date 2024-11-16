require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/standstill"

local BrainCommon = require("brains/braincommon")

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 15

local SEE_FOOD_DIST = 20
local NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach"}

local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 12

local WANDER_DIST_NIGHT = 6
local WANDER_DIST_DAY = 20

local Polar_PenguinBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
	local target
	
	if inst.sg:HasStateTag("busy") then
		return
	elseif inst.components.inventory and inst.components.eater then
		target = inst.components.inventory:FindItem(function(item)
			return inst.components.eater:CanEat(item)
		end)
		
		if target then
			return BufferedAction(inst, target, ACTIONS.EAT)
		end
	end
	
	target = FindEntity(inst, SEE_FOOD_DIST, function(item)
		return item:GetTimeAlive() >= 8 and item:IsOnPassablePoint() and inst.components.eater:CanEat(item)
	end, nil, NO_TAGS, inst.components.eater:GetEdibleTags())
	
	return target and BufferedAction(inst, target, ACTIONS.PICKUP) or nil
end

--

local function GetWanderHome(inst)
	return inst.components.knownlocations and inst.components.knownlocations:GetLocation("herd")
end

local function GetWanderDistFn(inst)
	return TheWorld.state.isday and WANDER_DIST_DAY or WANDER_DIST_NIGHT
end

--

local function FindNearbyHopPoint(inst)
	if inst._ocean_escape_position == nil then
		return false
	end
	
	return inst:GetDistanceSqToPoint(inst._ocean_escape_position:Get()) < 8
end

local function HopIntoOcean(inst)
	inst:PushEvent("ploof", {pt = inst._ocean_escape_position})
	inst._ocean_escape_position = nil
end

local function ShouldRunAway(inst, target)
	return inst.components.combat and inst.components.combat.target == nil
end

local function GetWaterFn(inst)
	--[[if inst._ocean_escape_position then
		return inst._ocean_escape_position
	end]]
	
	local pt = inst:GetPosition()
	local offset
	local range = 2
	
	while offset == nil and range < TUNING.POLAR_PENGUIN_SHORE_DIST * 2 do
		offset = FindSwimmableOffset(pt, math.random() * TWOPI, range, 6)
		range = range + 2
	end
	
	if offset then
		inst._ocean_escape_position = pt + offset
		
		return inst._ocean_escape_position
	end
end

function Polar_PenguinBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST, 15),
		IfNode(function() return FindNearbyHopPoint(self.inst) end, "Close Enough To Hop Into The Ocean!",
			ActionNode(function() HopIntoOcean(self.inst) end)),
		DoAction(self.inst, EatFoodAction, "Eating Food Action", false),
		RunAway(self.inst, "scarytoprey", RUN_AWAY_DIST, STOP_RUN_AWAY_DIST, function(target)
			return ShouldRunAway(self.inst, target)
		end, false, nil, nil, GetWaterFn),
		Wander(self.inst, GetWanderHome, GetWanderDistFn),
		StandStill(self.inst),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Polar_PenguinBrain