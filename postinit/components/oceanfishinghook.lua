local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OceanFishingHook = require("components/oceanfishinghook")
	
	local Old_ClacCharm = OceanFishingHook._ClacCharm
	function OceanFishingHook:_ClacCharm(fish, ...)
		local charm = Old_ClacCharm(self, fish, ...)
		local polar_charm
		
		local x, y, z = self.inst.Transform:GetWorldPosition()
		if GetClosestPolarTileToPoint(x, 0, z, 52) ~= nil and self.lure_data then
			local fish_lure_prefs = fish and fish.fish_def.lures or nil
			
			local mod = (self.inst.components.perishable and self.inst.components.perishable:GetPercent() or 1)
				* (self.lure_data.timeofday and self.lure_data.timeofday[TheWorld.state.phase] or 0)
				* (fish_lure_prefs == nil and 1 or self.lure_data.style and fish_lure_prefs[self.lure_data.style] or 0)
				* (self.lure_data.weather and self.lure_data.weather["snowing"] or TUNING.OCEANFISHING_LURE_WEATHER_DEFAULT["snowing"] or 1)
				* (self.lure_fns.charm_mod_fn and self.lure_fns.charm_mod_fn(fish) or 1)
			
			polar_charm = (self.lure_data.charm + self.lure_data.reel_charm * self.reel_mod) * mod
			
			return polar_charm
		end
		
		return charm
	end