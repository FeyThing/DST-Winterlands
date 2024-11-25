local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Temperature = require("components/temperature")
	
	function Temperature:GetPolarWetnessModifier(winterInsulation, summerInsulation)
		local level = GetPolarWetness(self.inst)
		
		if level ~= 0 then
			local winterPolarI = winterInsulation * (0.5 ^ (level / 2))
			local summerPolarI = summerInsulation * (2 ^ (level / 2))
			
			return winterPolarI, summerPolarI
		end
		
		return winterInsulation, summerInsulation
	end
	
	local OldGetInsulation = Temperature.GetInsulation
	function Temperature:GetInsulation(...)
		local winterInsulation, summerInsulation = OldGetInsulation(self, ...)
		local winterPolarI, summerPolarI = self:GetPolarWetnessModifier(winterInsulation, summerInsulation)
		
		if self.inst:HasTag("heatrock") and IsInPolar(self.inst) then
			winterPolarI = winterPolarI * TUNING.HEATROCK_INSULATION_POLARMULT
		end
		
		return math.max(0, winterPolarI), math.max(0, summerPolarI)
	end