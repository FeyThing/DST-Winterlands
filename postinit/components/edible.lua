local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Edible = require("components/edible")
	
	local OldGetHealth = Edible.GetHealth
	function Edible:GetHealth(eater, ...)
		local healthvalue = OldGetHealth and OldGetHealth(self, eater, ...) or 0
		local crocushat = eater and eater.components.inventory and eater.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		
		if healthvalue < 0 and crocushat and crocushat:HasTag("crocushat") then
			local freshness = crocushat.components.perishable and crocushat.components.perishable:GetPercent() or 1
			healthvalue = math.abs(healthvalue * freshness)
		end
		
		return healthvalue
	end
	
	local OldGetSanity = Edible.GetSanity
	function Edible:GetSanity(eater, ...)
		local sanityvalue = OldGetSanity and OldGetSanity(self, eater, ...) or 0
		local crocushat = eater and eater.components.inventory and eater.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
		
		if sanityvalue < 0 and crocushat and crocushat:HasTag("crocushat") then
			local freshness = crocushat.components.perishable and crocushat.components.perishable:GetPercent() or 1
			sanityvalue = math.abs(sanityvalue * freshness)
		end
		
		return sanityvalue
	end