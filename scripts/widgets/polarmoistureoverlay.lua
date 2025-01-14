local UIAnim = require("widgets/uianim")
local Widget = require("widgets/widget")

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
	self.polaranim:Hide()
	
	self.meltanim = self:AddChild(UIAnim())
	self.meltanim:GetAnimState():SetBank("meter_polar_over")
	self.meltanim:GetAnimState():SetBuild("meter_polar_over")
	self.meltanim:GetAnimState():PlayAnimation("melting", true)
	self.meltanim:GetAnimState():AnimateWhilePaused(false)
	self.meltanim:SetClickable(false)
	self.meltanim:Hide()
	
	self.inst:DoTaskInTime(0.2, function() self:InternalUpdate() end)
end)

function PolarMoistureOverlay:InternalUpdate(level)
	local polar_level = level or GetPolarWetness(self.owner)
	
	local wetnessactive = self.moisturemeter and self.moisturemeter.active
	
	local rate = self.owner and self.owner:GetMoistureRateScale()
	if rate then
		--[[local moisturepercent = 0
		
		if wetnessactive and self.moisturemeter.anim then
			local frame = self.moisturemeter.anim:GetAnimState():GetCurrentAnimationFrame()
			local maxframe = self.moisturemeter.anim:GetAnimState():GetCurrentAnimationNumFrames()
			moisturepercent = math.abs(frame - maxframe / 2) / (maxframe / 2)
		end]]
		
		if rate > 0 and polar_level > 0 then --and moisturepercent < 1 then
			self.meltanim:Show()
		else
			self.meltanim:Hide()
		end
	end
	
	if not wetnessactive then
		self.polaranim:Hide()
		self.meltanim:Hide()
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