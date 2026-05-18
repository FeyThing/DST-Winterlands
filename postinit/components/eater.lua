local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Eater = require("components/eater")
	
	local OldSetDiet = Eater.SetDiet
	function Eater:SetDiet(...)
		OldSetDiet(self, ...)
		
		-- Any creature can take a sip from the Crocus Petal Tea
		if self.caneat and not table.contains(self.caneat, FOODTYPE.CROCUS) then
			table.insert(self.caneat, FOODTYPE.CROCUS)
		end
		if self.preferseating and not table.contains(self.preferseating, FOODTYPE.CROCUS) then
			table.insert(self.preferseating, FOODTYPE.CROCUS)
		end
	end
	
	local OldTestFood = Eater.TestFood
	function Eater:TestFood(food, ...)
		if food and food.prefab == "hermitcrabtea_petals_polar" and not self.inst:HasTag("player") then
			return true
		end
		
		return OldTestFood(self, food, ...)
	end