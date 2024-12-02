local Image = require("widgets/image")
local Widget = require("widgets/widget")

local IceOver_Polar_FE = Class(Widget, function(self, scscreen)
	Widget._ctor(self, "IceOver_Polar_FE")
	self:SetClickable(false)
	
	self.img = self:AddChild(Image("images/fx.xml", "ice_over.tex"))
	self.img:SetEffect("shaders/uifade.ksh")
	self.img:SetHAnchor(ANCHOR_MIDDLE)
	self.img:SetVAnchor(ANCHOR_MIDDLE)
	self.img:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.img:SetAlphaRange(2, 2)
	
	self.alpha_min = 1
	self.alpha_min_target = 0
	
	self:StartUpdating()
end)

function IceOver_Polar_FE:OnUpdate(dt)
	self.alpha_min = (1 - dt) * self.alpha_min + dt * self.alpha_min_target
	
	self.img:SetAlphaRange(self.alpha_min, 2)
	
	if self.alpha_min <= 0.1 then
		self:StopUpdating()
	end
end

return IceOver_Polar_FE