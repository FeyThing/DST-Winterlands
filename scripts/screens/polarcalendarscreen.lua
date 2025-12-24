local Screen = require "widgets/screen"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

local TEMPLATES = require "widgets/redux/templates"

local clickables = {
	{
		x = -290,
		y = 355,
		w = 90,
		h = 120,
		tooltip = STRINGS.POLAR_CALENDAR.DAY1_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/calendar/creak", 0.3}},
	},
	{
		x = -63,
		y = 180,
		w = 90,
		h = 120,
		tooltip = STRINGS.POLAR_CALENDAR.DAY2_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/calendar/creak", 0.4}},
	},
	{
		x = 78,
		y = 335,
		w = 90,
		h = 120,
		tooltip = STRINGS.POLAR_CALENDAR.DAY3_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/calendar/clank", 0.5}},
	},
	{
		x = -165,
		y = 375,
		w = 90,
		h = 110,
		tooltip = STRINGS.POLAR_CALENDAR.DAY4_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/calendar/swoop", 0.2}, {"polarsounds/calendar/hit_snow", 0.9}},
	},
	{
		x = 220,
		y = 185,
		w = 130,
		h = 130,
		tooltip = STRINGS.POLAR_CALENDAR.DAY5_TOOLTIP,
		sounds = {{"polarsounds/calendar/knock"}, {"polarsounds/calendar/creak", 0.6}},
	},
	{
		x = -40,
		y = 367,
		w = 90,
		h = 110,
		tooltip = STRINGS.POLAR_CALENDAR.DAY6_TOOLTIP,
		sounds = {{"polarsounds/calendar/creak"}},
	},
	{
		x = -290,
		y = 210,
		w = 90,
		h = 110,
		tooltip = STRINGS.POLAR_CALENDAR.DAY7_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/calendar/shadowhand_pick", 0.7}, {"polarsounds/calendar/pop", 1}},
	},
	{
		x = 78,
		y = 165,
		w = 90,
		h = 110,
		tooltip = STRINGS.POLAR_CALENDAR.DAY8_TOOLTIP,
		sounds = {{"polarsounds/calendar/pop"}, {"polarsounds/calendar/clank", 0.7}},
	},
	{
		x = -175,
		y = 210,
		w = 90,
		h = 110,
		tooltip = STRINGS.POLAR_CALENDAR.DAY9_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/calendar/swoop", 0.1}},
	},
	{
		x = 205,
		y = 355,
		w = 130,
		h = 130,
		tooltip = STRINGS.POLAR_CALENDAR.DAY10_TOOLTIP,
		sounds = {{"polarsounds/calendar/knock"}, {"polarsounds/calendar/creak", 0.6}},
	},
	{
		x = 465,
		y = 415,
		w = 110,
		h = 100,
		tooltip = STRINGS.POLAR_CALENDAR.DAY11_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/arctic_fools/stick_fish", 0.9}},
	},
	{
		x = -450,
		y = 10,
		w = 100,
		h = 100,
		tooltip = STRINGS.POLAR_CALENDAR.DAY12_TOOLTIP,
		sounds = {{"polarsounds/calendar/step_snow"}, {"polarsounds/calendar/hit_snow", 0.35}, {"polarsounds/calendar/gift_open", 0.6}},
	},
	{
		x = 720,
		y = 35,
		w = 100,
		h = 100,
		tooltip = STRINGS.POLAR_CALENDAR.DAY13_TOOLTIP,
		sounds = {{"polarsounds/calendar/hit_snow"}, {"polarsounds/calendar/gift_open", 0.6}, {"polarsounds/calendar/pop", 0.7}},
	},
	{
		x = -310,
		y = 680,
		w = 120,
		h = 120,
		tooltip = STRINGS.POLAR_CALENDAR.DAY14_TOOLTIP,
		sounds = {{"polarsounds/calendar/step_snow"}, {"polarsounds/calendar/hit_snow", 0.4}, {"polarsounds/calendar/swoop", 0.6}, {"polarsounds/calendar/gift_open", 0.8}},
	},
	{
		x = -500,
		y = 620,
		w = 120,
		h = 120,
		tooltip = STRINGS.POLAR_CALENDAR.DAY15_TOOLTIP,
		sounds = {{"polarsounds/calendar/hit_snow"}, {"polarsounds/calendar/swoop", 0.1}, {"polarsounds/calendar/gift_open", 0.8}},
	},
	{
		x = -390,
		y = 400,
		w = 120,
		h = 80,
		tooltip = STRINGS.POLAR_CALENDAR.DAY16_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/arctic_fools/stick_fish", 1}},
	},
	{
		x = 170,
		y = 0,
		w = 120,
		h = 100,
		tooltip = STRINGS.POLAR_CALENDAR.DAY17_TOOLTIP,
		sounds = {{"polarsounds/calendar/gift_open"}},
	},
	{
		x = 570,
		y = 230,
		w = 90,
		h = 130,
		tooltip = STRINGS.POLAR_CALENDAR.DAY18_TOOLTIP,
		sounds = {{"polarsounds/calendar/tree_chop"}, {"polarsounds/calendar/shadowhand_pick", 0.4}, {"polarsounds/calendar/hit_snow", 0.6}},
	},
	{
		x = -485,
		y = 200,
		w = 120,
		h = 90,
		tooltip = STRINGS.POLAR_CALENDAR.DAY19_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/arctic_fools/stick_fish", 0.6}},
	},
	{
		x = -140,
		y = 20,
		w = 150,
		h = 150,
		tooltip = STRINGS.POLAR_CALENDAR.DAY20_TOOLTIP,
		sounds = {{"polarsounds/calendar/hit_snow"}, {"polarsounds/calendar/pop", 0.3}, {"polarsounds/calendar/gift_open", 0.3}, {"polarsounds/calendar/hit_snow", 0.6}},
	},
	{
		x = 335,
		y = 210,
		w = 110,
		h = 70,
		tooltip = STRINGS.POLAR_CALENDAR.DAY21_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/arctic_fools/stick_fish", 0.6}},
	},
	{
		x = 540,
		y = 55,
		w = 100,
		h = 100,
		tooltip = STRINGS.POLAR_CALENDAR.DAY22_TOOLTIP,
		sounds = {{"polarsounds/calendar/step_snow", 0.1}, {"polarsounds/calendar/step_snow", 0.5}, {"polarsounds/calendar/gift_open", 1.1}, {"polarsounds/calendar/pop", 1.1}},
	},
	{
		x = -365,
		y = 110,
		w = 100,
		h = 100,
		tooltip = STRINGS.POLAR_CALENDAR.DAY23_TOOLTIP,
		sounds = {{"polarsounds/calendar/touch"}, {"polarsounds/arctic_fools/swoop", 0.1}, {"polarsounds/arctic_fools/stick_fish", 0.6}},
	},
	{
		x = 675,
		y = 310,
		w = 90,
		h = 130,
		tooltip = STRINGS.POLAR_CALENDAR.DAY24_TOOLTIP,
		sounds = {{"polarsounds/calendar/tree_chop"}, {"polarsounds/calendar/tree_fall", 0.5}, {"polarsounds/calendar/shadowhand_pick", 0.7}, {"polarsounds/calendar/step_snow", 1.1}},
	},
	{
		x = -560,
		y = 60,
		w = 160,
		h = 190,
		tooltip = STRINGS.POLAR_CALENDAR.DAY25_TOOLTIP,
		sounds = {{"polarsounds/calendar/step_snow"}, {"polarsounds/calendar/hit_snow", 0.3}, {"polarsounds/calendar/step_snow", 0.6}},
	}
}

local function MakeIcon(id, tooltip, self)
	local icon = UIAnim()
	icon:GetAnimState():SetBank("polarcalendar_icons")
	icon:GetAnimState():SetBuild("polarcalendar_icons")
	
	icon.base_x = clickables[id].x
	icon.base_y = clickables[id].y
	icon:SetPosition(icon.base_x, icon.base_y)

	icon.focus_scale = 0.50
	icon.normal_scale = 0.45
	icon:SetScale(icon.normal_scale)
	
	icon.bounce_phase = math.random() * 2 * PI
	icon.bounce_speed = 1 + math.random() * 0.5
	
	icon.OnGainFocus = function()
		icon:SetScale(icon.focus_scale)
		tooltip:SetString(clickables[id].tooltip.str)
		tooltip.title:SetString(clickables[id].tooltip.title)
		tooltip:Show()
	end
	icon.OnLoseFocus = function()
		icon:SetScale(icon.normal_scale)
		tooltip:Hide()
		tooltip.title:SetString("")
		
		if not HasPassedCalendarDay(self.active_clickable_day + 1) and self.active_clickable_day <= 24 then
			tooltip:SetString(STRINGS.POLAR_CALENDAR.SEE_YA)
			tooltip:Show()
		end
	end
	
	return icon
end

local PolarCalendarScreen = Class(Screen, function(self, owner)
	self.owner = owner
	Screen._ctor(self, "PolarCalendarScreen")

	local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
	black.image:SetVRegPoint(ANCHOR_MIDDLE)
	black.image:SetHRegPoint(ANCHOR_MIDDLE)
	black.image:SetVAnchor(ANCHOR_MIDDLE)
	black.image:SetHAnchor(ANCHOR_MIDDLE)
	black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
	black.image:SetTint(0, 0, 0, 0.6)
	black:SetOnClick(function() TheFrontEnd:PopScreen() end)
	black:SetHelpTextMessage("")

	self.root = self:AddChild(Widget("root"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.calendar = self.root:AddChild(UIAnim())
	self.calendar:GetAnimState():SetBank("polarcalendar")
	self.calendar:GetAnimState():SetBuild("polarcalendar")
	self.calendar:SetScale(0.7)
	self.calendar:SetPosition(-35, -230)
	
	self.tooltip = self.root:AddChild(Text(UIFONT, 32, ""))
	self.tooltip:SetPosition(0, -360)
	self.tooltip:SetHAlign(ANCHOR_MIDDLE)
	self.tooltip:SetVAlign(ANCHOR_TOP)
	self.tooltip:SetRegionSize(900, 160)
	self.tooltip:EnableWordWrap(true)
	self.tooltip:Hide()

	self.tooltip.title = self.tooltip:AddChild(Text(UIFONT, 40, ""))
	self.tooltip.title:SetPosition(0, 100)
	self.tooltip.title:SetHAlign(ANCHOR_MIDDLE)
	self.tooltip.title:SetVAlign(ANCHOR_MIDDLE)
	self.tooltip.title:SetRegionSize(400, 80)
	self.tooltip.title:EnableWordWrap(false)
	
	TheSim:GetPersistentString("winterlands_adventday", function(success, day)
		if success then
			self.active_clickable_day = tonumber(day)
		else
			self.active_clickable_day = 1
		end
	end)

	self.calendar:GetAnimState():PlayAnimation(tostring(self.active_clickable_day - 1))

	self.icons = {  }
	self.numbers = {  }

	self:RedrawIcons()
	self:RedrawNumbers()

	self:InitClickable(true)

	self.default_focus = self.calendar
	
	TheFrontEnd:GetSound():PlaySound("polarsounds/music/winters_feast_calendar", "all_i_want_for_kleismass")
	SetAutopaused(true)
	
	--
	
	self.reset_btn = self.root:AddChild(ImageButton("images/ui.xml", "button_large.tex", "button_large_over.tex", "button_large_disabled.tex",
		self.active_clickable_day >= 25 and "button_large_onclick.tex" or "button_large_disabled.tex"))
	
	self.reset_btn:SetPosition(120, 70)
	self.reset_btn:SetVAnchor(ANCHOR_BOTTOM)
	self.reset_btn:SetHAnchor(ANCHOR_LEFT)
	self.reset_btn:AddChild(Text(HEADERFONT, 35, STRINGS.POLAR_CALENDAR.RESET))
	
	self.reset_btn:SetOnClick(function()
		self:ResetCalendar()
	end)
	self.reset_btn.OnGainFocus = function()
		if self.active_clickable_day >= 25 then
			self.tooltip:SetString(STRINGS.POLAR_CALENDAR.RESET_TOOLTIP)
			self.tooltip:Show()
		end
	end
	self.reset_btn.OnLoseFocus = function()
		if self.active_clickable_day >= 25 then
			self.tooltip.title:SetString("")
			self.tooltip:Hide()
		end
	end
	self:SetResetEnabled(self.active_clickable_day >= 25)
end)

local function OnCalendarAnimOver(inst)
	local self = inst.widget.parent.parent
	local icon = MakeIcon(self.active_clickable_day - 1, self.tooltip, self)
	
	icon:GetAnimState():PlayAnimation("icon"..tostring(self.active_clickable_day - 1))
	inst.widget:AddChild(icon)
	table.insert(self.icons, icon)
	
	if inst.pointer and inst.playgiftsound then
		inst.pointer:GetAnimState():PlayAnimation("active_pre")
		inst.pointer:GetAnimState():PushAnimation("active_loop")
		inst.pointer:SetScale(2, 2)
		
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/Together_HUD/skin_tab_active")
		inst.playgiftsound = nil
	end
	inst:RemoveEventCallback("animover", OnCalendarAnimOver)
end

function PolarCalendarScreen:InitClickable(initial)
	if not HasPassedCalendarDay(self.active_clickable_day) then
		if initial then
			self.tooltip:SetString(STRINGS.POLAR_CALENDAR.SEE_YA)
			self.tooltip:Show()
		end
		
		return
	end
	
	local pointer = self.calendar:AddChild(UIAnim())
	local btn = self.calendar:AddChild(ImageButton("images/global.xml", "square.tex"))
	local data = clickables[self.active_clickable_day]
	
	pointer:GetAnimState():SetBank("tab_gift")
	pointer:GetAnimState():SetBuild("tab_gift")
	pointer:GetAnimState():PlayAnimation("active_loop", true)
	pointer:GetAnimState():HideSymbol("GIFT")
	pointer:GetAnimState():HideSymbol("frame")
	pointer:GetAnimState():SetScale(1.5, 1.5)
	pointer:SetClickable(false)
	pointer:SetPosition(data.x, data.y)
	pointer:Hide()
	pointer.inst:ListenForEvent("calendar_reset", function() pointer:Kill() end, self.inst)
	
	btn:SetPosition(data.x, data.y)
	btn:SetOnClick(function()
		self:RedrawIcons() -- In case someone spam clicks the tiles
		self:PlayTileSounds(clickables[self.active_clickable_day].sounds)
		
		self.calendar.inst:RemoveEventCallback("animover", OnCalendarAnimOver)
		self.calendar:GetAnimState():PlayAnimation(tostring(self.active_clickable_day - 1).."to"..tostring(self.active_clickable_day))
		
		pointer:GetAnimState():PlayAnimation("active_pst")
		TheFrontEnd:GetSound():KillSound("gift_idle")
		self.calendar.inst.playgiftsound = true
		self.calendar.inst.pointer = pointer
		
		self.calendar.inst:ListenForEvent("animover", OnCalendarAnimOver)
		btn:Kill()
		
		self.active_clickable_day = self.active_clickable_day + 1
		TheSim:SetPersistentString("winterlands_adventday", tostring(self.active_clickable_day), false)

		self:RedrawNumbers()

		if self.active_clickable_day <= FINAL_ADVENT_DAY then
			self:InitClickable()
		else
			self:SetResetEnabled(true)
		end
	end)
	btn:SetOnGainFocus(function()
		pointer:GetAnimState():PlayAnimation("active_pre")
		pointer:GetAnimState():PushAnimation("active_loop")
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/Together_HUD/player_recieves_gift_idle", "gift_idle")
		
		pointer:ScaleTo(1, 1.5, 1)
		pointer:Show()
	end)
	btn:SetOnLoseFocus(function()
		pointer:GetAnimState():PlayAnimation("active_pst")
		TheFrontEnd:GetSound():KillSound("gift_idle")
		
		pointer:ScaleTo(1.5, 0, 0.5, function()
		--	pointer:Hide()
		end)
	end)
	
	btn:SetHelpTextMessage("")
	btn.scale_on_focus = false

	btn.image:SetTint(0, 0, 0, 0)
	btn.image:ScaleToSize(clickables[self.active_clickable_day].w, clickables[self.active_clickable_day].h)
end

function PolarCalendarScreen:RedrawIcons()
	for i, icon in ipairs(self.icons) do
		icon:Kill()
	end

	self.icons = {  }

	for i, data in ipairs(clickables) do
		if i > self.active_clickable_day - 1 then
			break
		end

		local icon = MakeIcon(i, self.tooltip, self)
		icon:GetAnimState():PlayAnimation("icon"..tostring(i).."_idle")

		self.calendar:AddChild(icon)
		table.insert(self.icons, icon)
	end
end

function PolarCalendarScreen:RedrawNumbers()
	for i, number in ipairs(self.numbers) do
		number:Kill()
	end

	self.numbers = {  }

	for i, data in ipairs(clickables) do
		if i >= self.active_clickable_day then
			local num = Text(UIFONT, 52, tostring(i))
			num:SetClickable(false)
			num:SetHAlign(ANCHOR_MIDDLE)
			num:SetVAlign(ANCHOR_MIDDLE)
			num:SetPosition(data.x, data.y)
			self.calendar:AddChild(num)

			table.insert(self.numbers, num)
		end
	end
end

function PolarCalendarScreen:PlayTileSounds(sounds)
	for i, data in ipairs(sounds or {}) do
		local sound = data[1]
		local delay = data[2] or 0
		
		if delay <= 0 then
			TheFrontEnd:GetSound():PlaySound(sound)
		else
			self.inst:DoTaskInTime(delay, function()
				TheFrontEnd:GetSound():PlaySound(sound)
			end)
		end
	end
end

function PolarCalendarScreen:OnDestroy()
	TheFrontEnd:GetSound():KillSound("all_i_want_for_kleismass")
	SetAutopaused(false)
	
	PolarCalendarScreen._base.OnDestroy(self)
end

function PolarCalendarScreen:OnUpdate(dt)
	if not self.icons then return end
	
	self.time = (self.time or 0) + dt
	
	for i, icon in ipairs(self.icons) do
		local t = self.time * icon.bounce_speed + icon.bounce_phase
		local yoff = math.sin(t) * 6
		
		icon:SetPosition(icon.base_x, icon.base_y + yoff)
	end
end


function PolarCalendarScreen:OnBecomeInactive()
	PolarCalendarScreen._base.OnBecomeInactive(self)
end

function PolarCalendarScreen:OnBecomeActive()
	PolarCalendarScreen._base.OnBecomeActive(self)
end

function PolarCalendarScreen:SetResetEnabled(enabled)
	if not self.reset_btn then
		return
	end
	
	if enabled then
		self.reset_btn:SetTextures("images/ui.xml", "button_large.tex", "button_large_over.tex", "button_large_disabled.tex", "button_large_onclick.tex")
		self.reset_btn.image:SetTexture("images/ui.xml", "button_large.tex")
	else -- Can also reset but not showcased
		self.reset_btn:SetTextures("images/ui.xml", "button_large_disabled.tex", "button_large_disabled.tex", "button_large_disabled.tex", "button_large_disabled.tex")
		self.reset_btn.image:SetTexture("images/ui.xml", "button_large_disabled.tex")
	end
end

function PolarCalendarScreen:ResetCalendar()
	if self.active_clickable_day <= 1 then
		return
	end
	
	local swirl = self:AddChild(UIAnim())
	swirl:GetAnimState():SetBank("spawn_fx")
	swirl:GetAnimState():SetBuild("puff_spawning")
	swirl:GetAnimState():PlayAnimation("large", true)
	swirl:GetAnimState():SetBloomEffectHandle("shaders/anim.ksh")
	swirl:GetAnimState():SetScale(10000, 10000)
	swirl:GetAnimState():SetAddColour(0, 0, 0.2, 1)
	swirl:SetVAnchor(ANCHOR_MIDDLE)
	swirl:SetHAnchor(ANCHOR_MIDDLE)
	swirl:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
	swirl:SetPosition(0, -350)
	swirl:SetClickable(false)
	swirl.inst:ListenForEvent("animover", function() swirl:Kill() end)
	
	TheFrontEnd:GetSound():PlaySound("polarsounds/calendar/swirl")
	
	self.inst:DoTaskInTime(0.5, function()
		self.active_clickable_day = 1
		TheSim:SetPersistentString("winterlands_adventday", "1", false)
		
		self.calendar.inst:RemoveEventCallback("animover", OnCalendarAnimOver)
		self.calendar:GetAnimState():PlayAnimation("0", true)
		self.inst:PushEvent("calendar_reset")
		
		self:RedrawIcons()
		self:RedrawNumbers()
		self:InitClickable(true)
		self:SetResetEnabled(false)
	end)
end

function PolarCalendarScreen:OnControl(control, down)
	if PolarCalendarScreen._base.OnControl(self, control, down) then return true end

	if not down and (control == CONTROL_MENU_BACK or control == CONTROL_CANCEL) then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
		TheFrontEnd:PopScreen()
		return true
	end

	return false
end

function PolarCalendarScreen:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {  }

	table.insert(t,  TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)

	return table.concat(t, "  ")
end

return PolarCalendarScreen