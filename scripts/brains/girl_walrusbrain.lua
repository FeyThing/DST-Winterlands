require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/follow"
require "behaviours/standstill"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/leash"

local BrainCommon = require("brains/braincommon")

local RUN_START_DIST = 7
local RUN_STOP_DIST = 15

local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 40
local MAX_CHASE_TIME = 10

local MIN_FOLLOW_DIST = 10
local MAX_FOLLOW_DIST = 17
local TARGET_FOLLOW_DIST = MAX_FOLLOW_DIST + MIN_FOLLOW_DIST / 2
local MAX_PLAYER_STALK_DISTANCE = 40

local LEASH_RETURN_DIST = 40
local LEASH_MAX_DIST = 80

local MIN_FOLLOW_LEADER = 1
local MAX_FOLLOW_LEADER = 5
local TARGET_FOLLOW_LEADER = MAX_FOLLOW_LEADER + MIN_FOLLOW_LEADER / 2

local START_FACE_DIST = MAX_FOLLOW_DIST
local KEEP_FACE_DIST = MAX_FOLLOW_DIST

local DEPLOY_TRAP_OFFSET_DIST = 1.2
local DEPLOY_TRAP_TARGET_DIST = 70

local BOOST_ALLY_DIST = 6
local SEE_ALLY_DIST = 20

local function GetFaceTargetFn(inst)
	local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
	
	return target and not target:HasTag("notarget") and target or nil
end

local function KeepFaceTargetFn(inst, target)
	return not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
end

local function GetLeader(inst)
	return inst.components.follower and inst.components.follower.leader or nil
end

local ALLY_TAGS = {"walrus", "hound"}
local ALLY_NOT_TAGS = {"isdead"}

local PLAYER_ALLY_TAGS = {"walruspal"}
local PLAYER_ALLY_NOT_TAGS = {"INLIMBO", "isdead"}

local function GetNoLeaderFollowTarget(inst, ...)
	local target = GetLeader(inst) == nil and FindClosestPlayerToInst(inst, MAX_PLAYER_STALK_DISTANCE, true) or nil
	
	if target then
		local ally = FindEntity(inst, 10, nil, PLAYER_ALLY_TAGS, PLAYER_ALLY_NOT_TAGS)
		
		if ally ~= nil or target:HasTag("spawnprotection") or (target.components.age and target.components.age:GetAge() < 10) then
			return -- Don't follow if player has spawned recently or uses bagpipes
		end
	end
	
	return target
end

local function GetAllies(inst)
	return inst._wantstoboost and FindEntity(inst, 10, function(guy) return not guy:HasTag("walrus_support") and not guy:HasTag("hound") end, nil, ALLY_NOT_TAGS, ALLY_TAGS)
end

local function GetHome(inst)
	return inst.components.homeseeker and inst.components.homeseeker.home or nil
end

local function ShouldRunAway(inst, guy)
	local runaway = inst.components.combat:InCooldown() and inst.components.combat.target == guy
	
	inst._runaway_allowtraps = runaway
	
	return runaway
end

local EATFOOD_MUST_TAGS = {"edible_MEAT"}
local EATFOOD_CANT_TAGS = {"INLIMBO", "outofreach"}
local CHARACTER_TAGS = {"character"}

local function EatFoodAction(inst)
	local target = FindEntity(inst, SEE_FOOD_DIST, nil, EATFOOD_MUST_TAGS, EATFOOD_CANT_TAGS)
	if target and (not target:IsOnValidGround() or GetClosestInstWithTag(CHARACTER_TAGS, target, RUN_START_DIST)) then
		target = nil
	end
	
	if target then
		local act = BufferedAction(inst, target, ACTIONS.EAT)
		act.validfn = function()
			return target.components.inventoryitem == nil or target.components.inventoryitem.owner == nil or target.components.inventoryitem.owner == inst
		end
		
		return act
	end
end

local function ShouldGoHomeAtNight(inst)
	return TheWorld.state.isnight and GetLeader(inst) == nil and GetHome(inst) and inst.components.combat.target == nil
end

local function ShouldGoHomeScared(inst)
	if GetLeader(inst) or inst.components.leader:CountFollowers() > 0 then
		return false
	end
	
	if inst.components.inventory and inst.components.inventory:FindItem(function(trap) return trap:HasTag("walrus_beartrap") end) then
		return false
	end
	
	return FindEntity(inst, SEE_ALLY_DIST, nil, nil, ALLY_NOT_TAGS, ALLY_TAGS) == nil
end

local function GoHomeAction(inst)
	local home = GetHome(inst)
	
	return home and home:IsValid() and BufferedAction(inst, home, ACTIONS.GOHOME, nil, home:GetPosition()) or nil
end

local function GetHomeLocation(inst)
	local home = GetHome(inst)
	
	return home and home:GetPosition() or nil
end

local function GetNoLeaderLeashPos(inst)
	if not inst:HasTag("flare_summoned") then
		return GetLeader(inst) == nil and GetHomeLocation(inst) or nil
	end
end

local function DoWalrusSupport(inst, pos)
	if not inst._wantstoboost or inst._runaway_allowtraps or FindEntity(inst, BOOST_ALLY_DIST, nil, nil, ALLY_NOT_TAGS, ALLY_TAGS) == nil then
		return
	end
	
	inst:PushEvent("dowalrusboost")
end

local function DeployTrapAtPoint(inst, pos)
	if not inst._runaway_allowtraps then
		return
	end
	
	local trap = inst.components.inventory and inst.components.inventory:FindItem(function(trap) return trap:HasTag("walrus_beartrap") and trap.components.deployable end)
	
	if pos == nil and inst.components.combat and inst.components.combat.target then
		local pt = inst:GetPosition()
		local target_pt = inst.components.combat.target:GetPosition()
		
		if inst:GetDistanceSqToPoint(target_pt:Get()) < DEPLOY_TRAP_TARGET_DIST then
			return -- Too close for comfort
		end
		
		local dir = (target_pt - pt)
		
		dir = dir:GetNormalized()
		pos = pt + dir * (inst:GetPhysicsRadius(0) + DEPLOY_TRAP_OFFSET_DIST)
	end
	
	if pos and trap and trap.components.deployable:CanDeploy(pos, false, inst, inst.Transform:GetRotation())
		and inst.components.timer and not inst.components.timer:TimerExists("deploy_trap_cooldown") then
		
		local buffered_action = BufferedAction(inst, nil, ACTIONS.DEPLOY, trap, pos)
		
		inst._start_deploy_cooldown_callback = inst._start_deploy_cooldown_callback or function()
			inst.components.timer:StartTimer("deploy_trap_cooldown", TUNING.GIRL_WALRUS_SPAWN_TRAP_COOLDOWN + math.random())
		end
		buffered_action:AddSuccessAction(inst._start_deploy_cooldown_callback)
		
		return buffered_action
	end
end

local Girl_WalrusBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function Girl_WalrusBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		Leash(self.inst, GetNoLeaderLeashPos, LEASH_MAX_DIST, LEASH_RETURN_DIST), -- Dementia behavior, for consistancy...
		
		WhileNode(function() return self.inst.components.combat.target and not self.inst.sg:HasStateTag("walrusboosting") end, "ShouldSupport",
			DoAction(self.inst, function() return DeployTrapAtPoint(self.inst) end, "Deploy Trap", true)),
			Follow(self.inst, GetAllies, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER, true),
			DoAction(self.inst, function() return DoWalrusSupport(self.inst) end, "Play Bagpipes", true),
		RunAway(self.inst, function(guy) return ShouldRunAway(self.inst, guy) end, RUN_START_DIST, RUN_STOP_DIST),
		
		FailIfSuccessDecorator(ConditionWaitNode(function() return not self.inst.sg:HasStateTag("walrusboosting") end, "Block While Playing")),
		
		WhileNode(function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
			ChaseAndAttack(self.inst, MAX_CHASE_TIME)),
		Follow(self.inst, function() return self.inst.components.combat.target end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, true),
		
		WhileNode(function() return ShouldGoHomeAtNight(self.inst) end, "ShouldGoHomeAtNight",
			DoAction(self.inst, GoHomeAction, "Go Home Night")),
		
		WhileNode(function() return ShouldGoHomeScared(self.inst) end, "ShouldGoHomeScared",
			DoAction(self.inst, GoHomeAction, "Go Home Scared", true)),
		
		WhileNode(function() return self.inst.components.combat.target == nil end, "FollowMacTusk",
			Follow(self.inst, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER, false)),
			Follow(self.inst, GetNoLeaderFollowTarget, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, false),
		
		DoAction(self.inst, EatFoodAction, "Eat Food"),
		
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
		FaceEntity(self.inst, GetLeader, GetLeader),
		
		Wander(self.inst, GetHomeLocation, MAX_WANDER_DIST),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Girl_WalrusBrain