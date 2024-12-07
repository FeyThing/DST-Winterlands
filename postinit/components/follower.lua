local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Follower = require("components/follower")
	
	local OldAddLoyaltyTime = Follower.AddLoyaltyTime
	function Follower:AddLoyaltyTime(time, ...)
		if self.leader and self.leader.components.inventory then
			local amulet = self.leader.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
			if amulet and amulet.GetAmuletParts then
				local walrus_tusks = amulet:GetAmuletParts("walrus_tusk")
				
				if walrus_tusks > 0 then
					time = time * (walrus_tusks * TUNING.POLARAMULET.WALRUS_TUSK.LOYALTY_MULT)
				end
			end
		end
		
		OldAddLoyaltyTime(self, time, ...)
	end