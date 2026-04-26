local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Temperature = require("components/temperature")
	
	function Temperature:GetPolarWetnessModifier(winterInsulation, summerInsulation)
		local level = GetPolarWetness(self.inst)
		
		if level ~= 0 and not self.inst:HasDebuff("buff_polarimmunity") then
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
		
		local fleas = self.inst.components.inventory and self.inst.components.inventory:GetItemsWithTag("flea") or {}
		winterPolarI = winterPolarI + (#fleas * TUNING.POLARFLEA_INV_INSULATION)
		
		if self.inst:HasTag("heatrock") and IsInPolar(self.inst) then
			winterPolarI = winterPolarI * TUNING.HEATROCK_INSULATION_POLARMULT
		end
		if self.inst._polarbear_rug then
			winterPolarI = winterPolarI + (TUNING.POLARBEAR_RUG_INSULATION * (self.inst:HasTag("polite") and TUNING.POLARBEAR_RUG_MULT_CANADIAN or 1))
		end
		
		return math.max(0, winterPolarI), math.max(0, summerPolarI)
	end
	
	local OldOnUpdate = Temperature.OnUpdate
	function Temperature:OnUpdate(...)
		if TheWorld.components.polarstorm == nil then
			OldOnUpdate(self, ...)
			
			return
		end
		
		if TheWorld.components.polarstorm:IsInPolarStorm(self.inst) then
			if self.temperature_modifiers == nil or self.temperature_modifiers["polarblizzard"] ~= nil then
				self:SetModifier("polarblizzard", TUNING.POLAR_STORM_TEMP_MODIFIER)
			end
		else
			self:RemoveModifier("polarblizzard")
		end
		
		return OldOnUpdate(self, ...)
	end
	
	--	Note: Unlike other stats for Timefreeze Watch buff time reduction, see prefabs/polarbuffs at wandatimefreeze_ontemperaturedelta
	
	local OldSetTemperature = Temperature.SetTemperature
	function Temperature:SetTemperature(value, ...)
		local old = self.current
		local frozenstats = self.inst:HasTag("frozenstats")
		if frozenstats then
			value = math.clamp(value, 1, self.overheattemp - 1)
		end
		
		OldSetTemperature(self, value, ...)
		
		if frozenstats then
			self.current = old
		end
	end