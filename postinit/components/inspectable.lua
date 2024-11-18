local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local Inspectable = require("components/inspectable")
	
	local OldGetDescription = Inspectable.GetDescription
	function Inspectable:GetDescription(viewer, ...)
		if IsTooDeepInSnow(self.inst, viewer) then
			return GetString(viewer, "DESCRIBE_IN_POLARSNOW")
		end
		
		return OldGetDescription(self, viewer, ...)
	end