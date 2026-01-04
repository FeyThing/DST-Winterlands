local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Moisture = require("components/moisture")
	
--	Wetness rate is halted while the Frozen Wetness debuff is active, however it will consequently increase if the player is attempting to dry, or rather, melt the debuff
	
	function Moisture:GetPolarMoistureRate(rate)
		rate = rate or self:GetMoistureRate()
		
		local level = GetPolarWetness(self.inst)
		rate = (level <= 0 and rate) or (level == 1 and rate / 2) or 0
		
		return rate
	end
	
	function Moisture:GetPolarDryingRate(rate)
		rate = rate or self:GetDryingRate()
		
		local level = GetPolarWetness(self.inst)
		if level > 0 and rate > 0 then
			rate = TUNING.POLAR_WETNESS_LVL_WETNESS * level * rate
		end
		
		return rate
	end
	
	local OldGetMoistureRate = Moisture.GetMoistureRate
	function Moisture:GetMoistureRate(...)
		local rate = OldGetMoistureRate(self, ...)
		
		return self:GetPolarMoistureRate(rate)
	end
	
	local Old_GetMoistureRateAssumingRain = Moisture._GetMoistureRateAssumingRain
	Moisture._GetMoistureRateAssumingRain = function(self, ...)
		if self.inst.player_classified and self.inst.player_classified.polarsnowlevel:value() ~= 0 then
			return 0
		end
		
		return Old_GetMoistureRateAssumingRain(self, ...)
	end
	
	local OldGetDryingRate = Moisture.GetDryingRate
	function Moisture:GetDryingRate(moisturerate, ...)
		if self.inst:HasTag("frozenstats") then
			return 0 -- Small exception for Timefreeze drain, avoiding being wet is okay, avoiding to dry is just boring !
		end
		
		local rate = OldGetDryingRate(self, moisturerate, ...)
		
		return self:GetPolarDryingRate(rate)
	end
	
	local OldDoDelta = Moisture.DoDelta
	function Moisture:DoDelta(num, ...)
		if self.inst:HasTag("frozenstats") then
			WandaTimeFreezeDrain(self.inst, "moisture", num, self.moisture, self.maxmoisture)
			num = (num > 0 and self.moisture <= 0) and 0.01 or 0 -- Need a minimum of wetness when raining otherwise badge won't show and we still see rate arrow...
		end
		
		return OldDoDelta(self, num, ...)
	end
	
	local OldSetMoistureLevel = Moisture.SetMoistureLevel
	function Moisture:SetMoistureLevel(num, ...)
		if self.inst:HasTag("frozenstats") then
			WandaTimeFreezeDrain(self.inst, "moisture", num, self.moisture, self.maxmoisture)
			num = self.moisture
		end
		
		return OldSetMoistureLevel(self, num, ...)
	end