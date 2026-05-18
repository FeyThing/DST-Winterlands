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

local LEASH_MAJOR_MAX_DIST = 10
local LEASH_MAJOR_RETURN_DIST = 6

local STOP_RUN_DIST = 30
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 30
local TRADE_DIST = 20
local SEE_FOOD_DIST = 10

local SEE_BURNING_HOME_DIST_SQ = 20 * 20

local SEE_PLAYER_DIST = 6

local GETTRADER_MUST_TAGS = {"player"}
local FINDFOOD_CANT_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach", "show_spoiled"}

--  Facin' Major

local function GetMajor(inst)
	return inst.current_major
end

local function KeepMajor(inst)
	return inst.current_major ~= nil
end

local function GetMajorPos(inst)
	return inst.current_major ~= nil and inst.current_major:GetPosition() or nil
end

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

local function UpdateLeaderOnRug(inst)
	local leader = inst.components.follower and inst.components.follower:GetLeader()
	
	if leader and leader._polarbear_rug then
		inst.components.follower:StopFollowing()
		
		if inst.SetEnraged then
			inst:SetEnraged(false)
		end
		if inst.sg and not inst.sg:HasStateTag("busy") and not (inst.components.combat and inst.components.combat.target) then
			inst.sg:GoToState("disapproval")
		end
		
		return true
	end
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
	local t = GetTime()
	
	if not target then
		target = FindEntity(inst, SEE_FOOD_DIST, function(item)
			local take_time = item._tooth_trade_taketime
			if take_time and take_time > t then
				return false
			end
			
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

--	Tradin'

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
	end

	return GetHomePos(inst)
end

local function GetWanderPos(inst)
	local leader = GetLeader(inst)
	if leader then
		return leader:GetPosition()
	end
	
	if inst.components.knownlocations then
		return inst.components.knownlocations:GetLocation("spawnpt")
	end
end

--	Fuelin'

local BRAZIER_TAGS = {"canlight"}
local BRAZIER_ONE_OF_TAGS = {"portable_brazier", "portable_campfire"}
local BRAZIER_NOT_TAGS = {"INLIMBO", "_inventoryitem"}

local function AddFuelAction(inst)
	if TheWorld.state.isday or inst.components.timer and inst.components.timer:TimerExists("brazierfuel_cooldown") then
		return
	end
	
	local brazier = FindEntity(inst, TUNING.POLARBEAR_PROTECTSTUFF_RANGE, nil, BRAZIER_TAGS, BRAZIER_NOT_TAGS, BRAZIER_ONE_OF_TAGS)
	
	if brazier and brazier.components.fueled and brazier.components.fueled:GetCurrentSection() < TUNING.POLARBEAR_BRAZIER_REFUEL_PERCENT then
		local fuel = inst.components.inventory:FindItem(function(item) return item.prefab == "polarbearfur" end)
		if fuel == nil then
			fuel = SpawnPrefab("polarbearfur")
			inst.components.inventory:GiveItem(fuel)
			
			fuel.components.inventoryitem:SetOnDroppedFn(fuel.Remove)
			fuel.persists = false
		end
		
		local action = BufferedAction(inst, brazier, ACTIONS.ADDFUEL, fuel)
		local fueled_cooldown = function()
			if inst.components.timer and not inst.components.timer:TimerExists("brazierfuel_cooldown") then
				inst.components.timer:StartTimer("brazierfuel_cooldown", TUNING.POLARBEAR_BRAZIER_REFUEL_COOLDOWN)
			end
		end
		
		action:AddSuccessAction(fueled_cooldown)
		
		return action
	end
end

--	Prankin'

local PRANK_TAGS = {"player", "pig", "manrabbit"}
local PRANK_NOT_TAGS = {"INLIMBO", "arcticfooled", "bearbuddy", "playerghost"}

local function StickArcticFoolFishAction(inst)
	if not IsSpecialEventActive(SPECIAL_EVENTS.ARCTIC_FOOLS)
		or (inst.components.follower and inst.components.follower.leader)
		or (inst.components.timer and inst.components.timer:TimerExists("arcticfooled_cooldown")) then
		return
	end
	
	local target = FindEntity(inst, TUNING.ARCTIC_FOOL_FISH_BEAR_RANGE, function(guy)
		return guy.components.timer and not guy.components.timer:TimerExists("arcticfooledrecently")
	end, nil, PRANK_NOT_TAGS, PRANK_TAGS)
	
	if target then
		local fish = inst.components.inventory:FindItem(function(item) return item.prefab == "arctic_fool_fish" end)
		if fish == nil then
			fish = SpawnPrefab("arctic_fool_fish")
			inst.components.inventory:GiveItem(fish)
		end
		
		local action = BufferedAction(inst, target, ACTIONS.STICK_ARCTIC_FISH, fish)
		inst._arctic_fooling_around = true
		
		local fooled_cooldown = function()
			inst._arctic_fooling_around = nil
			
			if target.components.timer and not target.components.timer:TimerExists("arcticfooledrecently") then
				target.components.timer:StartTimer("arcticfooledrecently", TUNING.ARCTIC_FOOL_FISH_PRANKER_COOLDOWN)
			end
			if inst.components.timer and not inst.components.timer:TimerExists("arcticfooled_cooldown") then
				inst.components.timer:StartTimer("arcticfooled_cooldown", 60)
			end
			
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
		end
		
		action:AddSuccessAction(fooled_cooldown)
		
		inst:DoTaskInTime(3 + math.random(), fooled_cooldown)
		
		return action
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

--	Choppin'

local CHOP_TAGS = {"CHOP_workable"}
local CHOP_CANT_TAGS = {"carnivalgame_part", "event_trigger", "waxedplant"}

local function GetValidDecidMonster(inst)
	local has_tree_target = inst.tree_target and inst.tree_target:IsValid() and not inst.tree_target:HasAnyTag("stump", "burnt")
	
	if has_tree_target then
		return inst.tree_target
	else
		inst.tree_target = nil
	end
end

local function ChopTreeKeepGoing(inst, leaderdist, finddist)
	local leader = GetLeader(inst)
	
	local valid_tree_target = (inst.tree_target and inst.tree_target:IsValid() and not inst.tree_target:HasTag("stump"))
	if not valid_tree_target then
		inst.tree_target = nil
	end
	
	return (leader and leader.components.timer and leader.components.timer:TimerExists("polarbear_loyaltyboost"))
		or GetValidDecidMonster(inst) ~= nil
end

local function ChopTreeFinder(inst, leaderdist, finddist)
	local target = GetValidDecidMonster(inst) or FindEntity(inst, finddist, nil, CHOP_TAGS, CHOP_CANT_TAGS)
	
	if target then
		return BufferedAction(inst, target, ACTIONS.CHOP)
	end
end

--	Chattin'

local function ShouldPauseChatty(inst)
	return inst.components.timer and inst.components.timer:TimerExists("pause_chatty")
end

local BUDDY_TAGS = {"bearbuddy"}
local BUDDY_NOT_TAGS = {"bear"}

local function GetChatterLines(inst)
	if ShouldPauseChatty(inst) then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local in_polar = GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil
	
	if in_polar and TheWorld.components.polarstorm and not TheWorld.components.polarstorm:IsPolarStormActive() then
		local time_before_storm = TheWorld.components.polarstorm:GetTimeLeft()
		
		if time_before_storm and time_before_storm <= TUNING.POLARBEAR_BLIZZARD_WARNTIME then
			return STRINGS.POLARBEAR_BLIZZARDSOON[math.random(#STRINGS.POLARBEAR_BLIZZARDSOON)]
		end
	end
	
	if FindEntity(inst, 2, nil, BUDDY_TAGS, BUDDY_NOT_TAGS) then
		return STRINGS.POLARBEAR_LOOKATBEARSON[math.random(#STRINGS.POLARBEAR_LOOKATBEARSON)]
	end
	
	local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
	if (TheWorld.components.polarsnow_manager and TheWorld.components.polarsnow_manager:IsTileMelting(tx, ty))
		or (not in_polar and TheWorld.state.temperature >= 5) then
		
		return STRINGS.POLARBEAR_LOOKATWILSON_HOT[math.random(#STRINGS.POLARBEAR_LOOKATWILSON_HOT)]
	end
	
	return STRINGS.POLARBEAR_LOOKATWILSON[math.random(#STRINGS.POLARBEAR_LOOKATWILSON)]
end

local function GetCombatLines(inst)
	if ShouldPauseChatty(inst) then
		return
	end
	
	local target = inst.components.combat and inst.components.combat.target
	if target then
		if target.components.timer and target.components.timer:TimerExists("stealing_bear_stuff") then
			return STRINGS.POLARBEAR_PROTECTSTUFF[math.random(#STRINGS.POLARBEAR_PROTECTSTUFF)]
		elseif target:HasTag("arcticfooled") then
			return STRINGS.POLARBEAR_FOOLFIGHT[math.random(#STRINGS.POLARBEAR_FOOLFIGHT)]
		elseif not inst.enraged and target:HasAnyTag(POLARBEAR_FISHY_TAGS) then
			return STRINGS.POLARBEAR_FISHFIGHT[math.random(#STRINGS.POLARBEAR_FISHFIGHT)]
		end
	end
	
	return STRINGS.POLARBEAR_FIGHT[math.random(#STRINGS.POLARBEAR_FIGHT)]
end

local function GetWorkingLines(inst)
	local t = GetTime()
	if ShouldPauseChatty(inst) or (inst.next_work_chatter and t < inst.next_work_chatter) then
		return
	end
	
	inst.next_work_chatter = t + 3 + math.random() * 3
	return STRINGS.POLARBEAR_HELP_CHOP_WOOD[math.random(#STRINGS.POLARBEAR_HELP_CHOP_WOOD)]
end

local function GetFaceTargetNearestPlayerFn(inst)
	if inst._arctic_fooling_around or (inst.components.combat and inst.components.combat.target) then
		return
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	return FindClosestPlayerInRange(x, y, z, MIN_FOLLOW_DIST, true)
end

local function KeepFaceTargetNearestPlayerFn(inst, target)
	return GetFaceTargetNearestPlayerFn(inst) == target
end

--  Trialin'

local function GetTrialParticipatorLines(inst)
	if inst.trialdata then
		if inst.trialdata.combat_trial then
			return STRINGS.POLARBEAR_IN_COMBAT_TRIAL[math.random(#STRINGS.POLARBEAR_IN_COMBAT_TRIAL)]
		elseif inst.trialdata.fun_trial then
			return STRINGS.POLARBEAR_IN_FUN_TRIAL[math.random(#STRINGS.POLARBEAR_IN_FUN_TRIAL)]
		end
	end
end

local function GetTrialSpectatorLines(inst)
	if inst.nearby_trial then
		if inst.nearby_trial.components.trialsholder.trialdata.combat_trial then
			return STRINGS.POLARBEAR_SPECTATING_COMBAT_TRIAL[math.random(#STRINGS.POLARBEAR_SPECTATING_COMBAT_TRIAL)]
		elseif inst.nearby_trial.components.trialsholder.trialdata.fun_trial then
			return STRINGS.POLARBEAR_SPECTATING_FUN_TRIAL[math.random(#STRINGS.POLARBEAR_SPECTATING_FUN_TRIAL)]
		end
	end
end

local function FindNearbyTrial(inst)
	if inst.nearby_trial == nil or not inst.nearby_trial:IsValid() then
		inst.nearby_trial = FindEntity(inst, 24,
		function(guy)
			return guy.components.trialsholder:IsTrialActive() and
				   guy.components.trialsholder.trialdata.audience_valid
		end,
		{ "bear_major" })

	elseif not inst.nearby_trial.components.trialsholder:IsTrialActive() then
		inst.nearby_trial = nil
	end

	if inst.nearby_trial ~= nil then
		inst:AddTag("trial_spectator")
	else
		inst:RemoveTag("trial_spectator")
	end

	return inst.nearby_trial
end

local function GetNearbyTrial(inst)
	return inst.nearby_trial
end

local function KeepFaceNearbyTrial(inst)
	return inst.nearby_trial and inst.nearby_trial:IsValid() and inst.nearby_trial.components.trialsholder:IsTrialActive()
end

local function GetTrialFollowMinDist(inst)
	return inst.nearby_trial and inst.nearby_trial.components.trialsholder.trialdata.radius + 1 or 24
end

local function GetTrialFollowTargetDist(inst)
	return inst.nearby_trial and inst.nearby_trial.components.trialsholder.trialdata.radius + 2 or 24 + 1
end

local function GetTrialFollowMaxDist(inst)
	return inst.nearby_trial and inst.nearby_trial.components.trialsholder.trialdata.radius + 4 or 24 + 2
end

--

local function HasRageZoomies(inst)
	return inst.enraged and GetValidDecidMonster(inst) == nil
end

local PolarBearBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function PolarBearBrain:OnStart()
	local combat_trial_nodes = ChattyNode(self.inst, GetTrialParticipatorLines,
		ChaseAndAttack(self.inst, 999, 999))
	
	-- local fun_trial_nodes = PriorityNode({
	-- 	WhileNode(function() return self.inst.trialdata.fun_trial end,
	-- 		ChattyNode(self.inst, GetTrialParticipatorLines,
	-- 			TODO))
	-- }, 0)
	
	local observe_trial_nodes = PriorityNode({
		Follow(self.inst, GetNearbyTrial, GetTrialFollowMinDist, GetTrialFollowTargetDist, GetTrialFollowMaxDist, true),
		ChattyNode(self.inst, GetTrialSpectatorLines,
			FaceEntity(self.inst, GetNearbyTrial, KeepFaceNearbyTrial), 5, 5, 1, 1)
	}, 0)
	
	local root = PriorityNode({
		-- Panic nodes
		WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "Panic Haunted",
			ChattyNode(self.inst, "POLARBEAR_PANICHAUNT",
				Panic(self.inst))),
		WhileNode(function() return self.inst.components.health.takingfiredamage end, "On Fire",
			ChattyNode(self.inst, "POLARBEAR_PANICFIRE",
				Panic(self.inst))),
		WhileNode(function() return BrainCommon.ShouldAvoidElectricFence(self.inst) end, "Shocked",
			ChattyNode(self.inst, "POLARBEAR_PANICELECTRICITY",
				AvoidElectricFence(self.inst))),
		
		-- Trial participation nodes
		WhileNode(function() return self.inst:HasTag("trial_participator") and self.inst.trialdata.combat_trial end, "Participate In Combat Trial", combat_trial_nodes),
		-- WhileNode(function() return self.inst:HasTag("trial_participator") and self.inst.trialdata.fun_trial end, "Participate In Fun Trial", fun_trial_nodes),
		
		-- Common nodes
		ChattyNode(self.inst, GetCombatLines,
			WhileNode(function() return not self.inst.components.combat:InCooldown() end, "Attack Momentarily",
				ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST))),
		WhileNode(function() return IsHomeOnFire(self.inst) end, "On Fire",
			ChattyNode(self.inst, "POLARBEAR_PANICHOUSEFIRE",
				Panic(self.inst))),
		
		-- Trial spectating nodes
		WhileNode(function() if not self.inst:HasTag("trial_participator") then return FindNearbyTrial(self.inst) ~= nil end end, "Observe Trial", observe_trial_nodes),
		
		-- Common nodes
		WhileNode(function() return KeepMajor(self.inst) end, "Face Major",
			PriorityNode({
				Leash(self.inst, GetMajorPos, LEASH_MAJOR_MAX_DIST, LEASH_MAJOR_RETURN_DIST, true),
				FaceEntity(self.inst, GetMajor, KeepMajor)
			}, 0)),
		WhileNode(function() return HasRageZoomies(self.inst) end, "Rage Zoomin",
			Panic(self.inst)),
		EventNode(self.inst, "gohome",
			ChattyNode(self.inst, "POLARBEAR_BLIZZARD",
				DoAction(self.inst, GoHomeAction, "Run Home", true))),
		ChattyNode(self.inst, "POLARBEAR_RESCUE",
			WhileNode(function() return GetFrozenLeader(self.inst) end, "Leader Frozen",
				DoAction(self.inst, RescueLeaderAction, "Rescue Leader", true))),
		RunAway(self.inst, "ice_crack_fx", 5, 7),
		ConditionNode(function() return UpdateLeaderOnRug(self.inst) end, "Leave Creepy Leader"),
		
		-- Teeth trading nodes
		FailIfSuccessDecorator(ActionNode(function() DoToothTrade(self.inst) end, "Tooth Trade")),
		FailIfSuccessDecorator(ConditionWaitNode(function() return not self.inst._tooth_trade_queued end, "Block While Doing Tooth Trade")),
		
		-- Action chatty nodes
		IfNode(function() return not ShouldPauseChatty(self.inst) end, "Other Trade",
			ChattyNode(self.inst, "POLARBEAR_ATTEMPT_TRADE",
				FaceEntity(self.inst, GetTraderFn, KeepTraderFn))),
		BrainCommon.NodeAssistLeaderDoAction(self, {
			action = "CHOP",
			chatterstring = GetWorkingLines,
			keepgoing = ChopTreeKeepGoing,
			finder = ChopTreeFinder,
			shouldrun = true,
		}),
		
		ChattyNode(self.inst, "POLARBEAR_FIND_TOOTH",
			DoAction(self.inst, FindToothAction, nil, true)),
		ChattyNode(self.inst, "POLARBEAR_FIND_FOOD",
			DoAction(self.inst, FindFoodAction)),
		ChattyNode(self.inst, "POLARBEAR_FOLLOWWILSON",
			Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),
		WhileNode(function() return self.inst.components.timer and self.inst.components.timer:TimerExists("arcticfooled_cooldown") end, "Avoid Pranked",
			RunAway(self.inst, "arcticfooled", 4, 10, nil, nil, nil, true)),
		
		-- Bored nodes
		PriorityNode({
			ChattyNode(self.inst, "POLARBEAR_STICKARCTICFISH",
				DoAction(self.inst, StickArcticFoolFishAction, "Pranking Players")),
			ChattyNode(self.inst, "POLARBEAR_FUELBRAZIER",
				DoAction(self.inst, AddFuelAction, "Add Fuel")),
			ChattyNode(self.inst, "POLARBEAR_PLOWSNOW",
				DoAction(self.inst, DoPlowingAction, "Plow Snow"), 5, 10, 5, 5),
		}, 0.5),
		
		-- Common nodes
		ChattyNode(self.inst, "POLARBEAR_GOHOME",
			WhileNode(function() return TheWorld.state.iscavenight or not self.inst:IsInLight() end, "Night Time",
				DoAction(self.inst, GoHomeAction, "Go Home", true))),
		Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
		ChattyNode(self.inst, GetChatterLines,
			FaceEntity(self.inst, GetFaceTargetNearestPlayerFn, KeepFaceTargetNearestPlayerFn)),
		Wander(self.inst, GetWanderPos, MAX_WANDER_DIST)
	}, 0.35)
	
	self.bt = BT(self.inst, root)
end

return PolarBearBrain