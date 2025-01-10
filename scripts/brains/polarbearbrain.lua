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
local MAX_PLOW_DIST = 10

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
local FINDFOOD_CANT_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach", "show_spoiled"}

--	Followin'

local function GetLeader(inst)
	return inst.components.follower.leader
end

local function GetFrozenLeader(inst)
	local leader = not inst.enraged and GetLeader(inst)
	
	if leader and leader.components.freezable and leader.components.freezable:IsFrozen() then
		return leader
	end
end

local function RescueLeaderAction(inst)
	return BufferedAction(inst, GetFrozenLeader(inst), ACTIONS.ATTACK)
end

--	Eatin' & Stealin'

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
			return item.components.edible and inst.components.eater:CanEat(item) and item:GetTimeAlive() >= 4 and item:IsOnPassablePoint()
		end, nil, FINDFOOD_CANT_TAGS)
	end
	
	return (target and BufferedAction(inst, target, ACTIONS.EAT)) or nil
end

local function FindToothAction(inst)
	if inst.sg:HasStateTag("busy") then
		return
	end
	
	local target = FindEntity(inst, SEE_FOOD_DIST, function(item)
		return POLARAMULET_PARTS[item.prefab] ~= nil and not POLARAMULET_PARTS[item.prefab].ornament and item:GetTimeAlive() >= 4 and item:IsOnPassablePoint()
	end, nil, FINDFOOD_CANT_TAGS)
	
	return (target and BufferedAction(inst, target, ACTIONS.PICKUP)) or nil
end

local function DoToothTrade(inst)
	local target = inst._tooth_trade_giver
	if target == nil or inst.sg:HasStateTag("busy") then
		return
	end
	
	if inst._tooth_trade_loot and #inst._tooth_trade_loot > 0 and target:IsValid() then
		if inst._tooth_trade_reward == nil then
			inst._tooth_trade_reward = SpawnPrefab(inst._tooth_trade_loot[1])
			table.remove(inst._tooth_trade_loot, 1)
		end
		
		local action = BufferedAction(inst, target, ACTIONS.GIVE, inst._tooth_trade_reward)
		inst._tooth_trade_queued = true
		
		local clear_trade_queued = function(inst, success)
			if inst._tooth_trade_queued then
				inst:DropTeethReward(success and target or nil)
				inst._tooth_trade_queued = false
			end
		end
		
		action:AddSuccessAction(function()
			clear_trade_queued(inst, true)
		end)
		inst:DoTaskInTime(5, clear_trade_queued)
		
		action:AddFailAction(function()
			clear_trade_queued(inst, false)
		end)
		
		inst.components.locomotor:PushAction(action, true)
	end
end

--	Housin'

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

--	Plowin'

local function HasPlowTool(inst)
	local tool = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil
	
	return tool and tool.components.polarplower
end

local PLOW_BLOCKER_TAGS = {"wall", "structure"} -- Don't plow around frequent things with colliders

local function HasPolarSnow(pt)
	return TheWorld.Map:IsPolarSnowAtPoint(pt.x, pt.y, pt.z, true) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, pt.y, pt.z, TUNING.POLAR_SNOW_FORGIVENESS.PLOWING)
		and #TheSim:FindEntities(pt.x, pt.y, pt.z, 1.5, PLOW_BLOCKER_TAGS) == 0
end

local function DoPlowingAction(inst)
	local pt = GetHomePos(inst, true)
	
	if pt and inst.components.timer and inst.components.timer:TimerExists("plowinthemorning") then
		local dist = 2
		local offset
		
		while offset == nil and dist < MAX_PLOW_DIST do
			offset = FindWalkableOffset(pt, TWOPI * math.random(), dist, 2, true, true, HasPolarSnow)
			dist = dist + 1
		end
		
		if offset then
			inst:StartPolarPlowing()
			local plower = inst.components.inventory:FindItem(function(item) return item.components.polarplower end) or inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			
			return BufferedAction(inst, nil, ACTIONS.POLARPLOW, plower, pt + offset)
		else
			inst:StopPolarPlowing()
		end
	end
end

local function GetFaceTargetNearestPlayerFn(inst)
	if inst.components.combat and inst.components.combat.target then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	return FindClosestPlayerInRange(x, y, z, MIN_FOLLOW_DIST, true)
end

local function KeepFaceTargetNearestPlayerFn(inst, target)
	return GetFaceTargetNearestPlayerFn(inst) == target
end

--

local function GetChatterLines(inst)
	if inst.components.timer and inst.components.timer:TimerExists("pause_chatty") then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil and TheWorld.components.polarstorm and not TheWorld.components.polarstorm:IsPolarStormActive() then
		local time_before_storm = TheWorld.components.polarstorm:GetTimeLeft()
		
		if time_before_storm and time_before_storm <= TUNING.POLARBEAR_BLIZZARD_WARNTIME then
			return STRINGS.POLARBEAR_BLIZZARDSOON[math.random(#STRINGS.POLARBEAR_BLIZZARDSOON)]
		end
	end
	
	return STRINGS.POLARBEAR_LOOKATWILSON[math.random(#STRINGS.POLARBEAR_LOOKATWILSON)]
end

local function GetCombatLines(inst)
	if inst.components.timer and inst.components.timer:TimerExists("pause_chatty") then
		return
	end
	local target = inst.components.combat and inst.components.combat.target
	
	if target then
		if target.components.timer and target.components.timer:TimerExists("stealing_bear_stuff") then
			return STRINGS.POLARBEAR_PROTECTSTUFF[math.random(#STRINGS.POLARBEAR_PROTECTSTUFF)]
		elseif not inst.enraged and (target:HasTag("fish") or target:HasTag("merm") or target:HasTag("shark")) then
			return STRINGS.POLARBEAR_FISHFIGHT[math.random(#STRINGS.POLARBEAR_FISHFIGHT)]
		end
	end
	
	return STRINGS.POLARBEAR_FIGHT[math.random(#STRINGS.POLARBEAR_FIGHT)]
end

--

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
		
		ChattyNode(self.inst, GetCombatLines,
			WhileNode(function() return not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
				ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST))),
		WhileNode(function() return IsHomeOnFire(self.inst) end, "OnFire",
			ChattyNode(self.inst, "POLARBEAR_PANICHOUSEFIRE",
				Panic(self.inst))),
		WhileNode(function() return self.inst.enraged end, "RageZoomin",
			Panic(self.inst)),
		EventNode(self.inst, "gohome",
			ChattyNode(self.inst, "POLARBEAR_BLIZZARD",
				DoAction(self.inst, GoHomeAction, "run home", true))),
		ChattyNode(self.inst, "POLARBEAR_RESCUE",
			WhileNode(function() return GetFrozenLeader(self.inst) end, "Leader Frozen",
				DoAction(self.inst, RescueLeaderAction, "Rescue Leader", true))),
		RunAway(self.inst, "icecrackfx", 5, 7),
		
		FailIfSuccessDecorator(ActionNode(function() DoToothTrade(self.inst) end, "Tooth Trade")),
		FailIfSuccessDecorator(ConditionWaitNode(function() return not self.inst._tooth_trade_queued end, "Block While Doing Tooth Trade")),
		
		IfNode(function() return not self.inst.sg:HasStateTag("toothtrading") end, "Other Trade",
			ChattyNode(self.inst, "POLARBEAR_ATTEMPT_TRADE",
				FaceEntity(self.inst, GetTraderFn, KeepTraderFn))),
		ChattyNode(self.inst, "POLARBEAR_FIND_TOOTH",
			DoAction(self.inst, FindToothAction, nil, true)),
		ChattyNode(self.inst, "POLARBEAR_FIND_FOOD",
			DoAction(self.inst, FindFoodAction)),
		ChattyNode(self.inst, "POLARBEAR_FOLLOWWILSON",
			Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),
		
		IfNode(function() return not self.inst.components.locomotor.dest end, "Bored",
			ChattyNode(self.inst, "POLARBEAR_PLOWSNOW",
				DoAction(self.inst, DoPlowingAction, "plow snow"), 5, 10, 5, 5)),
		
		ChattyNode(self.inst, "POLARBEAR_GOHOME",
			WhileNode(function() return TheWorld.state.iscavenight or not self.inst:IsInLight() end, "NightTime",
				DoAction(self.inst, GoHomeAction, "go home", true))),
		Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
		ChattyNode(self.inst, GetChatterLines,
			FaceEntity(self.inst, GetFaceTargetNearestPlayerFn, KeepFaceTargetNearestPlayerFn)),
		Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST)
	}, 0.5)
	
	self.bt = BT(self.inst, root)
end

return PolarBearBrain