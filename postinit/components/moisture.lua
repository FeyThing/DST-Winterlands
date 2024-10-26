local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Moisture = require("components/moisture")
	
	function Moisture:GetPolarMoistureRate(rate, drying)
		rate = rate or self:GetMoistureRate()
		
		local level = GetPolarWetness(self.inst)
		local level_rate = (level <= 0 and rate) or (level == 1 and rate / 2) or 0
		
		return level_rate -- TODO: if debuff is drying, then increase wetness! (using drying rate)
	end
	
	local OldGetMoistureRate = Moisture.GetMoistureRate
	function Moisture:GetMoistureRate(...)
		local rate = OldGetMoistureRate(self, ...)
		
		return self:GetPolarMoistureRate(rate)
	end
	
	local OldGetDryingRate = Moisture.GetDryingRate
	function Moisture:GetDryingRate(...)
		local rate = OldGetDryingRate(self, ...)
		
		local polar_level = GetPolarWetness(self.inst)
		if polar_level > 0 and rate > 0 then
			rate = -rate -- TODO: change that to level based rate, I gotta go tho :wave:
		end
		
		return rate
	end