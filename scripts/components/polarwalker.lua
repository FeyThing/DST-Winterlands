local PolarWalker = Class(function(self, inst)
	self.inst = inst
	
	self.slowed_mult = TUNING.POLAR_SLOWMULT
	self.slowing_mult = TUNING.POLAR_SLOWMULT
	
	self.slow_time = 0
	self.slow_time_max = TUNING.POLAR_SLOWTIME
end)

local function IsPolarTile(pt)
	return TheWorld.Map:IsPolarSnowAtPoint(pt.x, pt.y, pt.z, true)
end

function PolarWalker:IsPolarEdgeAtPoint(pt)
	if TheWorld.Map:IsOceanTileAtPoint(pt.x, 0, pt.z) and TheWorld.Map:IsVisualGroundAtPoint(pt.x, 0, pt.z) then
		local offset = FindWalkableOffset(pt, math.random() * TWOPI, 1.35, 12, false, true, IsPolarTile)
		
		return offset ~= nil
	end
	
	return false
end

function PolarWalker:ShouldSlow()
	local pt = self.inst:GetPosition()
	
	if self.inst:HasTag("polarimmune") then
		return false, "IMMUNE"
	end
	
	if self.inst.components.rider and self.inst.components.rider:IsRiding() then
		return false, "RIDING"
	end
	
	if IsPolarTile(pt) or self:IsPolarEdgeAtPoint(pt) then
		return not TheWorld.Map:IsPolarSnowBlocked(pt.x, pt.y, pt.z), "SNOW"
	end
	
	return false
end

function PolarWalker:GetSlowTime()
	local slowtime = self.slow_time_max
	
	if self.inst.components.inventory then
		for k, v in pairs(self.inst.components.inventory.equipslots) do
			if v.components.equippable and v.components.equippable.polar_slowtime then
				slowtime = math.max(0.1, slowtime + v.components.equippable.polar_slowtime)
            end
		end
	end
	
	if self.inst.polar_slowtime then
		slowtime = math.max(0.1, self.inst:polar_slowtime(slowtime))
	end
	
	return slowtime
end

function PolarWalker:GetSlowedMult()
	local mult = self.slowed_mult
	
	if self.inst.polar_slowedmult then
		mult = self.inst:polar_slowedmult(mult)
	end
	
	return mult
end

function PolarWalker:GetSlowingMult()
	local mult = self.slowing_mult
	local slowtime = self:GetSlowTime()
	
	if self.inst.polar_slowingmult then
		mult = self.inst:polar_slowingmult(mult)
	end
	
	if self.start_time then
		mult = Lerp(1, mult, math.min((self.slow_time - self.start_time), slowtime) / slowtime)
	end
	
	return mult
end

function PolarWalker:IsPolarSlowed()
	if self.inst:HasTag("flying") or self.inst:HasTag("playerghost")
		or (self.inst.components.health and self.inst.components.health:IsDead()) then
		
		self.slow_time = 0
		self.start_time = nil
		
		return false, false
	end
	
	local slowed = false
	local slowing = self:ShouldSlow()
	
	if slowing then
		if self.start_time == nil then
			self.start_time = GetTime()
		end
		
		self.slow_time = GetTime()
		
		if self.slow_time - self.start_time >= self:GetSlowTime() then
			slowed = true
		end
	else
		self.slow_time = 0
		self.start_time = nil
	end
	
	return slowed, slowing
end

function PolarWalker:IsSlowed(fully)
	if fully then
		return self._slowed == "slowed"
	else
		return self._slowed ~= nil
	end
end

function PolarWalker:Stop()
	if self.updating then
		self.inst:StopUpdatingComponent(self)
		
		self.updating = nil
	end
end

function PolarWalker:Start()
	if not self.updating then
		self.inst:StartUpdatingComponent(self)
		
		self.updating = true
	end
end

local function LearnDryIceRecipe(inst)
	local rec = "polar_dryice"
	
	if not inst.components.builder:KnowsRecipe(rec) and inst.components.builder:CanLearn(rec) then
		inst.components.builder:UnlockRecipe(rec)
		inst:PushEvent("learnrecipe", {teacher = inst, recipe = rec})
	end
end

function PolarWalker:SetWetness()
	if self._learndryice == nil then
		self._learndryice = self.inst:DoTaskInTime(1 + math.random(), LearnDryIceRecipe)
	end
	
	if (self.inst.components.health and self.inst.components.health:IsInvincible()) or HasPolarImmunity(self.inst) then
		return
	end
	
	self.inst:AddDebuff("buff_polarwetness", "buff_polarwetness")
end

function PolarWalker:OnUpdate()
	if not self.inst:HasTag("moving") then
		return
	end
	
	local slowed, slowing = self:IsPolarSlowed()
	
	local locomotor = self.inst.components.locomotor
	local carefulwalker = self.inst.components.carefulwalker
	
	if locomotor then
		if slowing then
			locomotor:SetExternalSpeedMultiplier(self.inst, "polar_slow", self:GetSlowingMult())
		else
			locomotor:RemoveExternalSpeedMultiplier(self.inst, "polar_slow")
		end
	end
	
	if carefulwalker then
		if slowed and slowing then
			local slowed_mult = self:GetSlowedMult()
			
			carefulwalker._polar_exit_speed = carefulwalker.carefulwalkingspeedmult
			carefulwalker:SetCarefulWalkingSpeedMultiplier(slowed_mult)
			
			if slowed_mult <= 1 then
				local curtime = GetTime()
				
				if self._slowed ~= "slowed" then
					self._nextcomplain = curtime + math.random(6, 12)
				end
				
				if self._nextcomplain == nil or self._nextcomplain < curtime then
					self._nextcomplain = curtime + math.random(6, 12)
					
					self.inst:PushEvent("polarwalking")
				end
			end
			
			self.inst:PushEvent("unevengrounddetected", {inst = self.inst, radius = 30, period = 0.6})
		elseif carefulwalker._polar_exit_speed and not slowed then
			carefulwalker:SetCarefulWalkingSpeedMultiplier(carefulwalker._polar_exit_speed)
			
			self.inst:PushEvent("unevengrounddetected", {inst = self.inst, radius = 0, period = 0})
		end
	end
	
	if slowing and self.inst.components.moisture then
		self:SetWetness()
	end
	
	if self.inst.components.builder and self._slowed ~= slowed then
		self.inst:PushEvent("refreshcrafting")
	end
	
	self._slowed = slowed and "slowed" or slowing and "slowing" or nil
end

function PolarWalker:OnEntitySleep()
	self.inst:StopUpdatingComponent(self)
end

function PolarWalker:OnEntityWake()
	self.inst:StartUpdatingComponent(self)
end

return PolarWalker