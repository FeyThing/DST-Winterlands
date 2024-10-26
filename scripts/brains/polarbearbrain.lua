require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"

local BrainCommon = require("brains/braincommon")

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9
local MAX_WANDER_DIST = 20

local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 30

local STOP_RUN_DIST = 30
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local TRADE_DIST = 20
local SEE_FOOD_DIST = 10

local SEE_BURNING_HOME_DIST_SQ = 20 * 20

local SEE_PLAYER_DIST = 6

local GETTRADER_MUST_TAGS = {"player"}
local FINDFOOD_CANT_TAGS = {"INLIMBO", "outofreach"}

local function GetTraderFn(inst)
	return FindEntity(inst, TRADE_DIST, function(target)
		return inst.components.trader:IsTryingToTradeWithMe(target)
	end, GETTRADER_MUST_TAGS)
end

local function KeepTraderFn(inst, target)
	return inst.components.trader:IsTryingToTradeWithMe(target)
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

	return (target and BufferedAction(inst, target, ACTIONS.EAT)) or nil
end

local function HasValidHome(inst)
	local home = (inst.components.homeseeker and inst.components.homeseeker.home) or nil
	
	return home and home:IsValid() and not (home.components.burnable and home.components.burnable:IsBurning()) and not home:HasTag("burnt")
end

local function GoHomeAction(inst)
	if not inst.components.follower.leader and not inst.components.combat.target and HasValidHome(inst) then
		return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
	end
end

local function IsHomeOnFire(inst)
	local homeseeker = inst.components.homeseeker
	
	return homeseeker and homeseeker.home and homeseeker.home.components.burnable and homeseeker.home.components.burnable:IsBurning()
		and inst:GetDistanceSqToInst(homeseeker.home) < SEE_BURNING_HOME_DIST_SQ
end

local function GetLeader(inst)
	return inst.components.follower.leader
end

local function GetHomePos(inst)
	return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function GetNoLeaderHomePos(inst)
	if GetLeader(inst) then
		return nil
	else
		return GetHomePos(inst)
	end
end

local PolarBearBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function PolarBearBrain:OnStart()
	local root = PriorityNode({
		WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted",
			ChattyNode(self.inst, "POLARBEAR_PANICHAUNT",
				Panic(self.inst))),
		WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
			ChattyNode(self.inst, "POLARBEAR_PANICFIRE",
				Panic(self.inst))),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		WhileNode(function() return IsHomeOnFire(self.inst) end, "OnFire",
			ChattyNode(self.inst, "POLARBEAR_PANICHOUSEFIRE",
				Panic(self.inst))),
		FaceEntity(self.inst, GetTraderFn, KeepTraderFn),
		DoAction(self.inst, FindFoodAction),
		Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		ChattyNode(self.inst, "POLARBEAR_GOHOME",
			WhileNode(function() return TheWorld.state.iscavenight or not self.inst:IsInLight() end, "NightTime",
				DoAction(self.inst, GoHomeAction, "go home", true))),
		Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
		Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST)
	}, 0.5)
	
	self.bt = BT(self.inst, root)
end

return PolarBearBrain