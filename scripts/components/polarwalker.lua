local function IsPolarTile(pt)
	return TheWorld.Map:IsPolarSnowAtPoint(pt.x, pt.y, pt.z, true)
end

local function LearnDryIceRecipe(inst, self)
	local rec = "polar_dryice"
	
	if inst.components.builder and not inst.components.builder:KnowsRecipe(rec) and inst.components.builder:CanLearn(rec) then
		inst.components.builder:UnlockRecipe(rec)
		inst:PushEvent("learnrecipe", {teacher = inst, recipe = rec})
	end

	self._learndryice_task = nil
end

local PolarWalker = Class(function(self, inst)
	self.inst = inst
	
	self.max_slowdown = TUNING.POLAR_SLOWMULT
	self.base_slow_time = TUNING.POLAR_SLOWTIME
	self.snowdepth = 0 -- LukaS: How deep the player is in snow, [0, 1]
	
	self.deepinhighsnow = false

	self.updating = false

	self._nextcomplain = nil
end)

function PolarWalker:OnRemoveFromEntity()
	self.inst:StopUpdatingComponent(self)
	self.snowdepth = 0
end

function PolarWalker:IsPolarEdgeAtPoint(pt)
	if TheWorld.Map:IsOceanTileAtPoint(pt.x, 0, pt.z) and TheWorld.Map:IsVisualGroundAtPoint(pt.x, 0, pt.z) then
		local offset = FindWalkableOffset(pt, math.random() * TWOPI, 1.35, 12, false, true, IsPolarTile)
		
		return offset ~= nil
	end
	
	return false
end

function PolarWalker:ShouldSlow()
	if TheWorld.state.temperature > TUNING.POLAR_SNOW_MELT_TEMP then
		return false, "MELTED"
	end
	
	if self.inst.components.rider and self.inst.components.rider:IsRiding() then
		return false, "RIDING"
	end
	
	local pt = self.inst:GetPosition()
	if (IsPolarTile(pt) or self:IsPolarEdgeAtPoint(pt)) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, pt.y, pt.z, 2) then
		if HasPolarSnowImmunity(self.inst) then
			return false, "IMMUNE"
		else
			return true
		end
	end
	
	return false
end

function PolarWalker:ShouldDebuff()
	if TheWorld.state.temperature > TUNING.POLAR_SNOW_MELT_TEMP then
		return false, "MELTED"
	end
	
	if self.inst.components.rider and self.inst.components.rider:IsRiding() then
		return false, "RIDING"
	end

	local pt = self.inst:GetPosition()
	if (IsPolarTile(pt) or self:IsPolarEdgeAtPoint(pt)) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, pt.y, pt.z, 2) then
		if self.inst.components.moisture == nil or HasPolarDebuffImmunity(self.inst) then
			return false, "IMMUNE"
		else
			return true
		end
	end

	return false
end

function PolarWalker:GetSlowTime()
	if self.inst.polar_slowtime then
		return math.max(0.1, self.inst:polar_slowtime()) or self.base_slow_time
	end

	local slowtime = self.base_slow_time
	if self.inst.components.inventory then
		for k, v in pairs(self.inst.components.inventory.equipslots) do
			if v.components.equippable and v.components.equippable.polar_slowtime then
				slowtime = slowtime + v.components.equippable.polar_slowtime
            end
		end
	end
	
	return slowtime
end

function PolarWalker:IsSlowed(fully)
	if fully then
		return self.snowdepth == 1
	else
		return self.snowdepth ~= 0
	end
end

function PolarWalker:AddPolarWetness()
	if (self.inst.components.health and self.inst.components.health:IsInvincible()) or HasPolarDebuffImmunity(self.inst) then
		return -- Only immunity to debuff, not slowdown
	end
	
	self.inst:AddDebuff("buff_polarwetness", "buff_polarwetness")
end

function PolarWalker:OnUpdate(dt)
	local locomotor = self.inst.components.locomotor
	if locomotor and locomotor:WantsToMoveForward() then
		if self:ShouldSlow() then
			if self._learndryice_task == nil then
				self._learndryice_task = self.inst:DoTaskInTime(1 + math.random(), function() LearnDryIceRecipe(self.inst, self) end)
			end

			self.snowdepth = math.clamp(self.snowdepth + (dt / self:GetSlowTime()), 0, 1)
			
			locomotor:SetExternalSpeedMultiplier(self.inst, "polar_slow", 1 - self.max_slowdown * self.snowdepth)
		else
			self.snowdepth = 0
			locomotor:RemoveExternalSpeedMultiplier(self.inst, "polar_slow")
		end
	end

	if self.inst.components.snowedshader then
		self.inst.components.snowedshader:SetSubmergedAmount(self.snowdepth)
	end
	
	if self.snowdepth >= 0.8 then
		if self.inst.components.wisecracker then
			local curtime = GetTime()
			if self._nextcomplain == nil or self._nextcomplain < curtime then
				self._nextcomplain = curtime + math.random(6, 12)
				
				self.inst:PushEvent("polarwalking")
			end
		end
	end
	
	if self.inst.deepinhighsnow then
		local isdeepinhighsnow = self.inst.deepinhighsnow:value()
		if isdeepinhighsnow and self.snowdepth < 0.8 or
		not isdeepinhighsnow and self.snowdepth >= 0.8 then
			self.inst.deepinhighsnow:set(not isdeepinhighsnow)
		end
	end
	
	if self.inst.nearhighsnow then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local is_near_high_snow = TheWorld.Map:IsPolarSnowAtPoint(x, 0, z) and not TheWorld.Map:IsPolarSnowBlocked(x, 0, z)
		if self.inst.nearhighsnow:value() ~= is_near_high_snow then
			if TheWorld.ismastersim then
				self.inst:PushEvent("refreshcrafting")
			end

			self.inst.nearhighsnow:set(is_near_high_snow)
		end
	end
	
	if self:ShouldDebuff() then
		self:AddPolarWetness()
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

function PolarWalker:OnEntitySleep()
	if TUNING.POLAR_WAVES_ENABLED then
		self:Stop()
	end
end

function PolarWalker:OnEntityWake()
	if TUNING.POLAR_WAVES_ENABLED then
		self:Start()
	end
end

return PolarWalker