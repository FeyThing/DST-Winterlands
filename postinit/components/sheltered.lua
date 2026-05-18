local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Sheltered = require("components/sheltered")
	
	local OldOnUpdate = Sheltered.OnUpdate
	function Sheltered:OnUpdate(dt, ...)
		OldOnUpdate(self, dt, ...)
		
		local x, y, z = self.inst.Transform:GetWorldPosition()
		if IsUnderIceCaveAtXZ(x, z) then
			self:SetSheltered(true, 2)
		end
	end