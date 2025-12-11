local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--TODO: There seems to be a bug with the icepacks inside of iceboxes and other specific containers when they are placed, then removed,
--		the spoiling items will spoil FASTER than normal. So far no idea why this happens o_o (but I didn't look much, im sick)

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