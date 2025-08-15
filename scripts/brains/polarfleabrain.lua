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

local NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "outofreach"}

local PolarFleaBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local HOST_TAGS =  {"_health", "fleahosted"}
local HOST_NOT_TAGS = {"INLIMBO", "hiding", "outofreach", "_inventoryitem", "smallcreature"}

local function SortMammals(ents, pt)
	table.sort(ents, function(a, b)
		local haspack_a = a.components.inventory and a.components.inventory:EquipHasTag("fleapack")
		local haspack_b = b.components.inventory and b.components.inventory:EquipHasTag("fleapack")
		
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

local function FindMammal(inst)
	if inst._host or inst.inlimbo then
		return
	end
	
	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, TUNING.POLARFLEA_HOST_RANGE, nil, HOST_NOT_TAGS, HOST_TAGS)
	ents = SortMammals(ents, pt)
	
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
		
		inst:DoTaskInTime(5, clear_hosting_queued)
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
			DoAction(self.inst, FindMammal)),
		FailIfSuccessDecorator(ConditionWaitNode(function() return not self.inst._hosting_queued end, "Block While Hosting")),
		
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
		Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

function PolarFleaBrain:OnInitializationComplete()
	self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition(), true)
end

return PolarFleaBrain