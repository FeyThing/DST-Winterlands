local UIAnim = require "widgets/uianim"
local easing = require "easing"

local NUM_HANDS = 2
local NUM_GEARS = 15

local TIC_THRESHOLD = 0.025

local WandaTimeFreezeOver = Class(UIAnim, function(self, owner)
	self.owner = owner
	UIAnim._ctor(self)
	
	self:SetClickable(false)
	
	self:SetHAnchor(ANCHOR_MIDDLE)
	self:SetVAnchor(ANCHOR_MIDDLE)
	self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
	
	self:GetAnimState():SetBank("wanda_timefreeze_over")
	self:GetAnimState():SetBuild("wanda_timefreeze_over")
	self:GetAnimState():PlayAnimation("over_idle")
	self:GetAnimState():AnimateWhilePaused(false)
	self:GetAnimState():SetScale(0.9, 0.9)
	
	self.tac = false
	self.rewinding = false
	self.rewind_time = 0
	self.rewind_duration = 1
	
	self:MakeHands()
	self:MakeGears()
	
	self:Hide()
	
	self.inst:ListenForEvent("timefreezepercent_changed", function(owner, data)
		local percent = data and data.percent or 0
		
		self.percent = percent
		self.target_long = (1 - percent) * (TUNING.POCKETWATCH_BUFF_DURATION / 60)
		self.target_short = (1 - percent) * 1
		
		if percent > 0 and not self.shown then
			self:Toggle(true)
		elseif percent <= 0 and self.shown then
			self:Toggle(false)
		end
	end, owner)
	
	self.inst:DoPeriodicTask(FRAMES, function() self:OnTick() end)
end)

function WandaTimeFreezeOver:Rewind()
	self.rewinding = true
	self.rewind_time = 0
	
	self.rewind_start_long = self.current_long
	self.rewind_start_short = self.current_short
	
	self.rewind_rot_long = -2
	self.rewind_rot_short = -1
end

function WandaTimeFreezeOver:Toggle(show)
	self:Rewind()
	
	if show and not self.shown then
		if self.hidetask then
			self.hidetask:Cancel()
			self.hidetask = nil
		end
		
		self:Show()
		
		--TheFrontEnd:GetSound():PlaySound("polarsounds/timefreeze/clock_start")
		self:GetAnimState():PlayAnimation("over_pre")
		
	elseif not show and self.shown then
		--TheFrontEnd:GetSound():PlaySound("polarsounds/timefreeze/clock_stop")
		self:GetAnimState():PlayAnimation("over_pst")
		
		local time = self.inst.AnimState:GetCurrentAnimationLength() + FRAMES
		if self.hidetask then
			self.hidetask:Cancel()
			self.hidetask = nil
		end
		
		self.hidetask = self.inst:DoTaskInTime(time, function(inst) self:Hide() end)
	end
	
	self.shown = show
end

function WandaTimeFreezeOver:MakeHands()
	self.hands = {}
	
	self.current_long = 0
	self.current_short = 0
	
	self.target_long = 0
	self.target_short = 0
	
	self.rewinding = false
	
	for i = 1, NUM_HANDS do
		local hand = self:AddChild(UIAnim())
		local anim = "hand"..i
		
		hand:GetAnimState():SetBank("wanda_timefreeze_over")
		hand:GetAnimState():SetBuild("wanda_timefreeze_over")
		hand:GetAnimState():PlayAnimation(anim)
		hand:GetAnimState():AnimateWhilePaused(false)
		hand:GetAnimState():SetMultColour(1, 1, 1, 0.2) -- A bit hard to see during the day :/ but quite visible at night, aaaa
		hand:GetAnimState():Pause()
		hand:SetClickable(false)
		
		table.insert(self.hands, hand)
	end
end

function WandaTimeFreezeOver:MakeGears()
	self.gears = {}
	
	for i = 1, NUM_GEARS do
		local gear = self:AddChild(UIAnim())
		local anim = "gear"..i
		
		gear:GetAnimState():SetBank("wanda_timefreeze_over")
		gear:GetAnimState():SetBuild("wanda_timefreeze_over")
		gear:GetAnimState():PlayAnimation(anim, true)
		gear:GetAnimState():AnimateWhilePaused(false)
		gear:GetAnimState():SetMultColour(1, 1, 1, 0.1)
		gear:SetClickable(false)
		self:UpdateGear(gear, anim)
		
		table.insert(self.gears, gear)
	end
end

function WandaTimeFreezeOver:UpdateGear(gear, anim)
	gear:GetAnimState():SetDeltaTimeMultiplier(GetRandomMinMax(-0.2, 0.2))
	gear.inst:DoTaskInTime(math.random() * 10, function()
		self:UpdateGear(gear, anim)
	end)
end

function WandaTimeFreezeOver:OnTick()
	if self.hands == nil or #self.hands == 0 then
		return
	end
	
	local speed = 0.18
	self.current_long = self.current_long + (self.target_long - self.current_long) * speed
	self.current_short = self.current_short + (self.target_short - self.current_short) * speed
	
	if self.rewinding then
		self.rewind_time = self.rewind_time + FRAMES
		local t = self.rewind_time / self.rewind_duration
		
		if t >= 1 then
			self.rewinding = false
			
			self.current_long = 0
			self.current_short = 0
			self.target_long = 0
			self.target_short = 0
		else
			self.current_long = self.rewind_start_long + self.rewind_rot_long * t
			self.current_short = self.rewind_start_short + self.rewind_rot_short * t
		end
	else
		self.current_long = self.current_long + (self.target_long - self.current_long) * speed
		self.current_short = self.current_short + (self.target_short - self.current_short) * speed
	end
	
	if self.hands[1] then
		self.hands[1]:GetAnimState():SetPercent("hand1", self.current_short % 1)
	end
	if self.hands[2] then
		self.hands[2]:GetAnimState():SetPercent("hand2", self.current_long % 1)
	end
	
	--	Tic, Tac, Tic, Tac
	
	local short_p = self.current_short % 1
	local long_p = self.current_long % 1
	
	local delta_short = math.abs(short_p - (self.last_short_percent or short_p))
	local delta_long = math.abs(long_p - (self.last_long_percent or long_p))
	
	self.delta_accum_short = (self.delta_accum_short or 0) + delta_short
	self.delta_accum_long = (self.delta_accum_long or 0) + delta_long
	self.tac = self.tac or false
	
	if not self.rewinding and (self.delta_accum_short >= TIC_THRESHOLD or self.delta_accum_long >= TIC_THRESHOLD) then
		local sound = "polarsounds/timefreeze/clock_"..(self.tac and "tac" or "tic")
		
		-- The sound is quieter if we aren't at the start or the end
		TheFrontEnd:GetSound():PlaySoundWithParams(sound, {clock = self.percent}, 0.05 + 0.2 * math.abs(2 * self.percent - 1))
		self.tac = not self.tac
		
		self.delta_accum_short = 0
		self.delta_accum_long = 0
	end
	
	self.last_short_percent = short_p
	self.last_long_percent = long_p
end

return WandaTimeFreezeOver