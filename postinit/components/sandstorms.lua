local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("sandstorms", function(self)
	local OldCalcSandstormLevel = self.CalcSandstormLevel
	function self:CalcSandstormLevel(ent, ...)
		local level = OldCalcSandstormLevel(self, ent, ...)
		
		if level > TUNING.POLAR_STORM_LIGHTER_LEVEL and ent.components.inventory and ent.components.inventory:EquipHasTag("bearhead") then
			level = TUNING.POLAR_STORM_LIGHTER_LEVEL
		end
		
		return level
	end
end)

ENV.AddComponentPostInit("moonstorms", function(self)
	local OldCalcMoonstormLevel = self.CalcMoonstormLevel
	function self:CalcMoonstormLevel(ent, ...)
		local level = OldCalcMoonstormLevel(self, ent, ...)
		
		if level > TUNING.POLAR_STORM_BEARHEAD_LEVEL and ent.components.inventory and ent.components.inventory:EquipHasTag("bearhead") then
			level = TUNING.POLAR_STORM_BEARHEAD_LEVEL -- Not using lighter level (because that effect is much stronger visually)
		end
		
		return level
	end
end)