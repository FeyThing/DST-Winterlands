require "behaviours/wander"
require "behaviours/chaseandattack"
require "behaviours/follow"

local MIN_FOLLOW = TUNING.SHADOW_ICICLER_ATTACK_RANGE * 0.6
local MED_FOLLOW = TUNING.SHADOW_ICICLER_ATTACK_RANGE * 0.8
local MAX_FOLLOW = 30

local HARASS_MIN = TUNING.SHADOW_ICICLER_ATTACK_RANGE * 0.6
local HARASS_MED = TUNING.SHADOW_ICICLER_ATTACK_RANGE * 0.8
local HARASS_MAX = TUNING.SHADOW_ICICLER_ATTACK_RANGE

local Shadow_IciclerBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local ShadowCreatureBrain = require("brains/shadowcreaturebrain")
Shadow_IciclerBrain.SetTarget = ShadowCreatureBrain.SetTarget

function Shadow_IciclerBrain:OnStop()
	self:SetTarget(nil)
end

local function ShouldAttack(self)
	local target = self.inst.components.combat.target
	
	if self.inst.components.shadowsubmissive:ShouldSubmitToTarget(target) then
		self._harasstarget = target
		
		return false
	end
	self._harasstarget = nil
	
	return target and self.inst:GetDistanceSqToInst(target) >= TUNING.SHADOW_ICICLER_ATTACK_RANGE * TUNING.SHADOW_ICICLER_ATTACK_RANGE * 0.6
end

local function ShouldHarass(self)
	return self._harasstarget and self._harasstarget:IsValid() and (self.inst.components.combat.nextbattlecrytime == nil
		or self.inst.components.combat.nextbattlecrytime < GetTime())
end

local function ShouldChaseAndHarass(self)
	return not self.inst:IsNear(self._harasstarget, HARASS_MED)
end

local function GetHarassWanderDir(self)
	return (self._harasstarget:GetAngleToPoint(self.inst.Transform:GetWorldPosition()) - 60 + math.random() * 120) * DEGREES
end

function Shadow_IciclerBrain:OnStart()
	local root = PriorityNode({
		WhileNode(function() return ShouldAttack(self) end, "Attack", ChaseAndAttack(self.inst, 100)),
		WhileNode(function() return ShouldHarass(self) end, "Harass",
			PriorityNode({
				WhileNode(function() return ShouldChaseAndHarass(self) end, "ChaseAndHarass",
					Follow(self.inst, function() return self._harasstarget end, HARASS_MIN, HARASS_MED, HARASS_MAX)),
				ActionNode(function()
					self.inst.components.combat:BattleCry()
					if self.inst.sg.currentstate.name == "taunt" then
						self.inst:ForceFacePoint(self._harasstarget.Transform:GetWorldPosition())
					end
				end),
		}, 0.25)),
		WhileNode(function() return self._harasstarget ~= nil and self._harasstarget:IsValid() end, "LoiterAndHarass",
			Wander(self.inst, function() return self._harasstarget:GetPosition() end, 20, {minwaittime = 0, randwaittime = 0.3}, function() return GetHarassWanderDir(self) end)),
		Follow(self.inst, function() return self.mytarget end, MIN_FOLLOW, MED_FOLLOW, MAX_FOLLOW),
		Wander(self.inst, function() return self.mytarget and self.mytarget:GetPosition() or nil end, 20),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Shadow_IciclerBrain