local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Sheltered = require("components/sheltered")

	local SHADE_ICECAVE_TAGS = {"icecaveshelter"}
	
	local OldOnUpdate = Sheltered.OnUpdate
	function Sheltered:OnUpdate(dt, ...)
		local shelters = FindEntity(self.inst, TUNING.SHADE_POLAR_RANGE, nil, SHADE_ICECAVE_TAGS)
		
		if shelters and self.inst.components.rainimmunity and self.inst.components.rainimmunity.sources[shelters] then
			self.announcecooldown = math.max(0, self.announcecooldown - dt)
			
			self:SetSheltered(true, 2)
		else
			OldOnUpdate(self, dt, ...)
		end
	end