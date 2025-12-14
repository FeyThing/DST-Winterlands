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

local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 12
local TARGET_FOLLOW_DIST = 6

local NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach"}

local PolarFleaBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local HOST_TAGS =  {"_container", "_health", "fleahosted"}
local HOST_NOT_TAGS = {"INLIMBO", "hiding", "outofreach", "smallcreature"}

local function SortValidHosts(ents, pt)
	table.sort(ents, function(a, b)
		local haspack_a = a:HasTag("fleapack") or (a.components.inventory and a.components.inventory:EquipHasTag("fleapack"))
		local haspack_b = b:HasTag("fleapack") or (b.components.inventory and b.components.inventory:EquipHasTag("fleapack"))
		
		if haspack_a and not haspack_b then
			return true
		elseif not haspack_a and haspack_b then
			return false
		else
			return pt:DistSq(a:GetPosition()) < pt:DistSq(b:GetPosition())
		end
	end)
	
	return ents
end

local function FindHost(inst)
	if inst._host or inst.inlimbo then
		return
	end
	
	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.POLARFLEA_HOST_RANGE, nil, HOST_NOT_TAGS, HOST_TAGS)
	ents = SortValidHosts(ents, pt)
	
	local host
	for i, v in ipairs(ents) do
		if inst.CanBeHost and inst:CanBeHost(v) then
			host = v
			break
		end
	end
	
	if host and inst.components.locomotor then
		inst._hosting_queued = true
		
		local action = BufferedAction(inst, host, ACTIONS.NUZZLE)
		local clear_hosting_queued = function() inst._hosting_queued = false end
		
		inst:DoTaskInTime(3, function()
			clear_hosting_queued()
			
			if inst:GetBufferedAction() == action then
				inst:ClearBufferedAction()
			end
		end)
		
		action:AddSuccessAction(clear_hosting_queued)
		action:AddFailAction(clear_hosting_queued)
		
		return action
	end
end

function PolarFleaBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		EventNode(self.inst, "fleafindhost",
			DoAction(self.inst, FindHost)),
		FailIfSuccessDecorator(ConditionWaitNode(function() return not self.inst._hosting_queued end, "Block While Hosting")),
		
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

function PolarFleaBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return PolarFleaBrain