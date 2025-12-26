local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Sanity = require("components/sanity")
	
	local OldDoDelta = Sanity.DoDelta
	function Sanity:DoDelta(delta, ...)
		if self.inst:HasTag("frozenstats") then
			WandaTimeFreezeDrain(self.inst, "sanity", delta, self.current, self.max)
			delta = 0
		end
		
		return OldDoDelta(self, delta, ...)
	end
	
	local OldRecalc = Sanity.Recalc
	function Sanity:Recalc(dt, ...)
		local fleas = self.inst.components.inventory ~= nil and self.inst.components.inventory:GetItemsWithTag("flea") or nil
		local hostedamt = 0
		
		if fleas then
			for i, v in ipairs(fleas) do
				if v.components.inventoryitem and v.components.inventoryitem.owner == self.inst then -- Only in inv, ignore fleas in backpack
					local is_aura_immune = false
					if self.sanity_aura_immunities then
						for tag, sources in pairs(self.sanity_aura_immunities) do
							if v:HasTag(tag) then
								is_aura_immune = true
								break
							end
						end
					end
					
					if not is_aura_immune then
						hostedamt = hostedamt + 1
					end
				end
			end
		end
		
		if hostedamt > 0 and not self.sanity_aura_immune_sources:Get() and not self.neg_aura_immune_sources:Get() then
			self.externalmodifiers:SetModifier(self.inst, TUNING.POLARFLEA_INV_DAPPERNESS * hostedamt * self:GetAuraMultipliers(), "itchyfleas")
		else
			self.externalmodifiers:RemoveModifier(self.inst, "itchyfleas")
		end
		
		return OldRecalc(self, dt, ...)
	end