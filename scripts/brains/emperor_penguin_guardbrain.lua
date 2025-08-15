require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/standstill"

-- TODO: in the event the castle is blocked, probably penguins should be allowed to attack walls?

local BrainCommon = require("brains/braincommon")

local MAX_CHASE_TIME = 60
local MAX_CHASE_DIST = 40

local WANDER_DIST_NIGHT = 6
local WANDER_DIST_DAY = 12

local Emperor_Penguin_GuardBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function GetWanderHome(inst)
	return inst.components.knownlocations and inst.components.knownlocations:GetLocation("rookery")
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

local function ShouldRunAway(inst)
	return TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.defeated
end

local function GetWaterFn(inst)
	if inst._ocean_escape_position then
		return inst._ocean_escape_position
	end
	
	local pt = inst:GetPosition()
	local offset
	local range = 2
	
	while offset == nil and range < TUNING.POLAR_PENGUIN_SHORE_DIST * 8 do
		offset = FindSwimmableOffset(pt, math.random() * TWOPI, range, 12)
		range = range + 2
	end
	
	if offset then
		inst._ocean_escape_position = pt + offset
		
		if inst._forgetcollisions == nil then
			inst._forgetcollisions = inst:DoTaskInTime(3, function()
				inst.Physics:ClearCollisionMask()
				inst.Physics:CollidesWith(COLLISION.GROUND)
			end)
		end
		
		return inst._ocean_escape_position
	end
end

local function ShouldRecoverStamina(inst)
	if inst.sg and inst.sg:HasStateTag("panting") then
		inst._timerunning = nil
		return false
	end
	if inst.recovering_stamina then
		inst._timerunning = nil
		return true
	end
	
	if not ShouldRunAway(inst) and inst.sg and (inst.sg:HasStateTag("running") or inst.sg:HasStateTag("runningattack")) then
		local t = GetTime()
		if inst._timerunning == nil then
			inst._timerunning = t
		end
		if inst._staminatime == nil then
			inst._staminatime = 5.5 + math.random() * 1.5
		end
		
		return t - inst._timerunning > inst._staminatime
	end
	
	inst._timerunning = nil
	return false
end

--

function Emperor_Penguin_GuardBrain:OnStart()
	local root = PriorityNode({
		BrainCommon.PanicTrigger(self.inst),
		BrainCommon.ElectricFencePanicTrigger(self.inst),
		
		WhileNode(function() return ShouldRunAway(self.inst) end, "Escaping",
            PriorityNode({
				IfNode(function() return FindNearbyHopPoint(self.inst) end, "Close Enough To Hop Into The Ocean!",
					ActionNode(function() HopIntoOcean(self.inst) end)),
                Leash(self.inst, GetWaterFn, 0.2, 0.2, true),
            }, 0.25)),
		
		WhileNode(function() return ShouldRecoverStamina(self.inst) end, "Recover Stamina",
			ActionNode(function() self.inst.recovering_stamina = true self.inst:PushEvent("guard_panting") end)),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST, 15),
		Wander(self.inst, GetWanderHome, GetWanderDistFn),
		StandStill(self.inst),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Emperor_Penguin_GuardBrain