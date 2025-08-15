require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/leash"
require "behaviours/standstill"

local BrainCommon = require("brains/braincommon")

local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 15

local WANDER_DIST = 2

local Emperor_PenguinBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

local function IsOnTower(inst)
	return inst.entity:GetParent() == inst._juggle_tower and inst._juggle_tower ~= nil
end

local function IsProperEmperor(inst)
	return TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner.emperor == inst
end

local function ShouldCallGuards(inst)
	return inst.wants_to_call_guards and IsProperEmperor(inst) and (not inst.wants_to_juggle or IsOnTower(inst)) and inst.sg and not inst.sg:HasStateTag("busy")
end

local function ShouldJuggle(inst)
	return inst.wants_to_juggle and IsProperEmperor(inst) and IsOnTower(inst) and inst.sg and not inst.sg:HasStateTag("busy")
end

local function ShouldGetToTower(inst)
	if IsProperEmperor(inst) and inst.wants_to_juggle and inst.sg and not inst.sg:HasStateTag("busy") and not IsOnTower(inst) then
		if inst._juggle_tower == nil then
			local tower = TheWorld.components.emperorpenguinspawner.ice_towers[math.random(#TheWorld.components.emperorpenguinspawner.ice_towers)]
			inst._juggle_tower = tower
		end
	else
		return false
	end
	
	return inst._juggle_tower ~= nil
end

local function ShouldChase(inst)
	local target = inst.components.combat and inst.components.combat.target
	
	if target and IsProperEmperor(inst) then
		local in_castle = TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(target)
		if not in_castle then
			inst.components.combat:GiveUp()
		end
		
		return in_castle
	end
	
	return not IsOnTower(inst)
end

local function ShouldSpin(inst)
	return IsProperEmperor(inst) and inst.wants_to_spin and not inst._juggle_tower and inst.sg and not inst.sg:HasStateTag("busy")
		and inst.components.combat and inst.components.combat.target and TheWorld.components.emperorpenguinspawner:IsInstInsideCastle(inst.components.combat.target)
end

--

local function GetWanderHome(inst)
	return inst.components.knownlocations and inst.components.knownlocations:GetLocation("rookery")
end

local function GetWanderDistFn(inst)
	return WANDER_DIST
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

--

function Emperor_PenguinBrain:OnStart()
	local root = PriorityNode({
		WhileNode(function() return ShouldRunAway(self.inst) end, "Escaping",
			PriorityNode({
				IfNode(function() return FindNearbyHopPoint(self.inst) end, "Close Enough To Hop Into The Ocean!",
					ActionNode(function() HopIntoOcean(self.inst) end)),
				Leash(self.inst, GetWaterFn, 0.2, 0.2, true),
			}, 0.25)),
		
		IfNode(function() return ShouldCallGuards(self.inst) end, "Call Guards",
			ActionNode(function() self.inst.sg:GoToState("summon_guards") end)),
		--[[IfNode(function() return ShouldJuggle(self.inst) end, "Go Juggling",
			ActionNode(function() self.inst.sg:GoToState("emperor_juggle") end)),]]
		WhileNode(function() return ShouldGetToTower(self.inst) end, "Climb Tower",
			ParallelNode{
				PriorityNode({
					Leash(self.inst, function() return self.inst._juggle_tower and self.inst._juggle_tower:GetPosition() end, 3, 3, true),
					ActionNode(function() self.inst:PushEvent("emperor_entertower") end),
				}, 0.25),
				LoopNode{
					ActionNode(function()
						if self.inst.sg:HasStateTag("busy") and not self.inst.sg:HasStateTag("hit") then
							self.inst.components.stuckdetection:Reset()
						elseif self.inst.components.stuckdetection:IsStuck() and not self.inst.components.combat:InCooldown() then
							self.inst.components.combat:TryAttack()
						end
					end),
				},
			}),
		
		IfNode(function() return ShouldSpin(self.inst) end, "Spin Attack",
			ActionNode(function() self.inst:PushEvent("emperor_spin") end)),
		WhileNode(function() return ShouldChase(self.inst) end, "Should Chase",
			ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST, 15)),
		Wander(self.inst, GetWanderHome, GetWanderDistFn),
		StandStill(self.inst),
	}, 0.25)
	
	self.bt = BT(self.inst, root)
end

return Emperor_PenguinBrain