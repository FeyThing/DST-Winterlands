local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPolarIce(inst, on_polar_ice)
	local self = inst.components.slipperyfeet
	
	if self then
		self.OnOceanIce(inst, on_polar_ice)
	end
end
	
ENV.AddComponentPostInit("slipperyfeet", function(self)
	self.OnPolarIce = OnPolarIce
	
	self.inst:ListenForEvent("on_POLAR_ICE_tile", self.OnPolarIce)
end)