local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local DeerclopsSpawner = require("components/deerclopsspawner")
local OldDeerclopsSpawner_ctor = DeerclopsSpawner._ctor

DeerclopsSpawner._ctor = function(self, inst, ...)
	OldDeerclopsSpawner_ctor(self, inst, ...)
	
	local megaflare_pos = nil
	
	if inst.event_listeners.megaflare_detonated and inst.event_listeners.megaflare_detonated[TheWorld] then
		local OnMegaFlare = inst.event_listeners.megaflare_detonated[TheWorld][1]
		
		inst.event_listeners.megaflare_detonated[TheWorld][1] = function(src, data, ...)
			if data and data.sourcept.z then
				megaflare_pos = Vector3(data.sourcept.x, data.sourcept.y, data.sourcept.z)
			end
			
			if OnMegaFlare then
				OnMegaFlare(src, data, ...)
			end
		end
		
		--
		
		local TryStartAttacks = PolarUpvalue(self.OnPostInit, "TryStartAttacks")
		local OldAllowedToAttack = PolarUpvalue(TryStartAttacks, "AllowedToAttack")
		
		local function AllowedToAttack(data, ...)
			if data and data.skipcycles and megaflare_pos and GetClosestPolarTileToPoint(megaflare_pos.x, 0, megaflare_pos.z, 32) then
				return true
			end
			
			megaflare_pos = nil
			return OldAllowedToAttack(data, ...)
		end
		
		PolarUpvalue(TryStartAttacks, "AllowedToAttack", AllowedToAttack)
	end
end