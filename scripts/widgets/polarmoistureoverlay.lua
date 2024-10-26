local UIAnim = require("widgets/uianim")
local Widget = require("widgets/widget")

--TODO: add a pst anims for each levels for when debuff gets removed

local PolarMoistureOverlay = Class(Widget, function(self, owner, parent)
	Widget._ctor(self, "PolarMoistureOverlay")
	self.owner = owner
	self.moisturemeter = parent
	
	self.polaranim = self:AddChild(UIAnim())
	self.polaranim:GetAnimState():SetBank("meter_polar_over")
	self.polaranim:GetAnimState():SetBuild("meter_polar_over")
	self.polaranim:GetAnimState():Hide("test")
	self.polaranim:GetAnimState():PlayAnimation("lvl0", true)
	self.polaranim:GetAnimState():AnimateWhilePaused(false)
	self.polaranim:SetClickable(false)
	
	self.inst:DoTaskInTime(0.2, function() self:InternalUpdate() end)
end)

function PolarMoistureOverlay:InternalUpdate(level)
	local polar_level = level or GetPolarWetness(self.owner)
	
	if self.moisturemeter == nil or not self.moisturemeter.active then
		self.polaranim:Hide()
	elseif polar_level ~= self.polar_level then
		self.polaranim:Show()
		
		if polar_level > 0 then
			self.polaranim:GetAnimState():PlayAnimation("lvl"..(polar_level - 1).."_"..polar_level)
			self.polaranim:GetAnimState():PushAnimation("lvl"..polar_level, true)
			
			TheFrontEnd:GetSound():PlaySoundWithParams("polarsounds/common/snow_freeze", {level = polar_level / TUNING.POLAR_WETNESS_LVLS})
		else
			self.polaranim:GetAnimState():PlayAnimation("lvl0", true)
		end
		
		self.polar_level = polar_level
	end
	
	self.inst:DoTaskInTime(0.2, function() self:InternalUpdate() end)
end

return PolarMoistureOverlay