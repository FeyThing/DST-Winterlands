local FIREFX_MULTS = TUNING.SNOW_BLOCK_RANGES.FIREFX_LEVEL_MULTS

local SnowwaveMelter = Class(function(self, inst)
	self.inst = inst
	
	self.melt_range = TUNING.SNOW_BLOCK_RANGES[self.inst.prefab == "character_fire" and "CREATURE" or "FIRE"] -- same as default _snowblockrange
	self.melt_rate = 0.25
	self.melt_time = TUNING.POLARPLOW_BLOCKER_DURATION_FIRE
	
	self.growth_time = 2
	self.melting = false
	self.melting_paused = false
end)

function SnowwaveMelter:CanMelt()
	if self.canmeltfn then
		return self.canmeltfn(self.inst)
	end
	
	return not self.inst:HasTag("INLIMBO")
end

function SnowwaveMelter:GetMeltRange(skip_growth)
	local range = FunctionOrValue(self.melt_range, self.inst)
	
	-- Gonna adjust melt_range based on burnable size, so burning items don't cover as much range as burning tree !
	if self.inst.components.firefx then
		local level = self.inst.components.firefx.level or 3
		
		range = range * ((level <= 1 and FIREFX_MULTS.LVL1)
			or (level <= 2 and FIREFX_MULTS.LVL2)
			or (level >= 4 and FIREFX_MULTS.LVL4)
			or FIREFX_MULTS.LVL3)
	end
	
	if not skip_growth then
		local growth = math.min(1, 0.5 + ((GetTime() - self.melt_start_time) / self.growth_time) * 0.5)
		
		 -- NOTE: Melting range should grows overtime for ents without _snowblockrange,
		 --	this is to prevent campfires to apply the extra firefx level they spawn with for a split second
		range = range * growth
	end
	
	return range
end

function SnowwaveMelter:Melt()
	local canmelt, stopmelting = self:CanMelt()
	
	if stopmelting then
		self:StopMelting()
	end
	if not canmelt then
		return
	end
	
	local duration = self.use_melt_time and self.melt_time or GetPolarPlowDuration(self.inst, self.melt_time, "melted")
	
	return SpawnPolarSnowBlocker(self.inst:GetPosition(), self:GetMeltRange(), duration, self.inst, "melted")
end

local function DoMelt(inst, self)
	self:Melt()
end

function SnowwaveMelter:StartMelting()
	self.melting = true
	self.melt_start_time = GetTime()
	
	if self.inst:IsAsleep() then
		self.melting_paused = true
		return
	end
	
	if self.melt_task == nil then
		self.melt_task = self.inst:DoPeriodicTask(self.melt_rate, DoMelt, 0, self)
	end
end

function SnowwaveMelter:StopMelting()
	if self.melt_task then
		self.melt_task:Cancel()
		self.melt_task = nil
	end
	
	self.melt_start_time = nil
	self.melting = false
	self.melting_paused = false
end

function SnowwaveMelter:OnEntitySleep()
	self.melting_paused = self.melting
	
	if self.melt_task then
		self.melt_task:Cancel()
		self.melt_task = nil
	end
end

function SnowwaveMelter:OnEntityWake()
	if self.melting_paused and self.melt_task == nil then
		self.melt_task = self.inst:DoPeriodicTask(self.melt_rate, DoMelt, 0, self)
	end
end

return SnowwaveMelter