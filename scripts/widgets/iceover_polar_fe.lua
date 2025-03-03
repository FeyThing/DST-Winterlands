local Image = require("widgets/image")
local Widget = require("widgets/widget")

local IceOver_Polar_FE = Class(Widget, function(self, scscreen, mod_name)
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
	
	self.mod_name = mod_name
	
	self.heated = self:IsHeated()
	self.heater_task = self.inst:DoPeriodicTask(1, function() self:RefreshHeater() end, 0)
	
	self:PlaySound()
	self:StartUpdating()
end)

function IceOver_Polar_FE:PlaySound()
	local freeze_sounds = {
		"dontstarve/winter/freeze_1st",
		"dontstarve/winter/freeze_2nd",
		--"dontstarve/winter/freeze_3rd",
		--"dontstarve/winter/freeze_4th",
	}
	
	local winter_sounds = {
		"dontstarve/creatures/together/deer/bell",
	}
	
	local play_sounds = {}
	
	--[[if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		for i, v in ipairs(winter_sounds) do
			table.insert(play_sounds, v)
		end
	end]]
	
	if #play_sounds == 0 then
		play_sounds = freeze_sounds
	end
	
	if not self.heated then
		TheFrontEnd:GetSound():PlaySound(play_sounds[math.random(#play_sounds)])
	end
end

function IceOver_Polar_FE:IsHeated()
	return self.mod_name and GetModConfigData("misc_menumelt", self.mod_name) or false
end

function IceOver_Polar_FE:RefreshHeater()
	local melting = self:IsHeated()
	
	if melting == self.heated then
		return
	end
	
	self.alpha_min = melting and 0 or 1
	self.alpha_min_target = melting and 1 or 0
	
	self.heated = melting
	
	self:PlaySound()
	self:StartUpdating()
end

function IceOver_Polar_FE:OnUpdate(dt)
	if self.heated then
		self.alpha_min = (1 + dt) * self.alpha_min + dt * self.alpha_min_target
	else
		self.alpha_min = (1 - dt) * self.alpha_min + dt * self.alpha_min_target
	end
	
	self.img:SetAlphaRange(self.alpha_min, 2)
	
	if (not self.heated and self.alpha_min <= 0.1) or (self.heated and self.alpha_min >= 0.9) then
		self:StopUpdating()
	end
end

return IceOver_Polar_FE