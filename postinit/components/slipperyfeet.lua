local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPolarIce(inst, on_polar_ice)
	local self = inst.components.slipperyfeet
	self.OnOceanIce(inst, on_polar_ice)
end
	
ENV.AddComponentPostInit("slipperyfeet", function(self)
	self.OnPolarIce = OnPolarIce
	
	self.inst:ListenForEvent("on_POLAR_ICE_tile", self.OnPolarIce)
end)