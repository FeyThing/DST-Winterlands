local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Preserver = require("components/preserver")
	
	function Preserver:GetIcePackMult(item)
		local mult = 1
		local should_preserve = item == nil or not item:HasTag("icepack")
		
		if self.inst.components.inventory then
			for i, v in ipairs(self.inst.components.inventory:GetItemsWithTag("icepack")) do
				if should_preserve then
					mult = mult * v.preserver_mult
				else
					should_preserve = true
				end
			end
		end
		if self.inst.components.container then
			for i, v in ipairs(self.inst.components.container:GetItemsWithTag("icepack")) do
				if should_preserve then
					mult = mult * v.preserver_mult
				else
					should_preserve = true
				end
			end
		end
		
		return mult
	end
	
	local OldGetPerishRateMultiplier = Preserver.GetPerishRateMultiplier
	function Preserver:GetPerishRateMultiplier(item, ...)
		local rate = OldGetPerishRateMultiplier(self, item, ...)
		local pack_rate = self:GetIcePackMult(item)
		
		return rate * pack_rate
	end