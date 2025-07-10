local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local function TryCompass(self)
	SendModRPCToServer(GetModRPC("Winterlands", "PolarCaveEntrance_GetPos"), self.owner)
	
	if self.owner.replica.inventory then
		local equipment = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		
		if equipment and equipment:HasTag("chillycompass") then
			self:OpenCompass()
			
			return true
		end
	end
	self:CloseCompass()
	
	return false
end

local HudCompass_Polar = Class(Widget, function(self, owner, isattached)
	Widget._ctor(self, "Hud Compass Polar")
	self:SetClickable(false)
	self.owner = owner
	
	self.isattached = isattached
	self.pt = Vector3(0, 0, 0)
	
	self.bg = self:AddChild(UIAnim())
	
	self.needle = self:AddChild(UIAnim())
	self.needle:GetAnimState():SetBank("compass_polar")
	self.needle:GetAnimState():SetBuild("compass_polar")
	self.needle:GetAnimState():PlayAnimation("ui_arrow", true)
	
	if isattached then
		self.bg:GetAnimState():SetBank("compass_polar")
		self.bg:GetAnimState():SetBuild("compass_polar")
		self.bg:GetAnimState():PlayAnimation("hidden")

		self.needle:SetPosition(0, 107, 0)
		self.needle:Hide()
	else
		self.bg:GetAnimState():SetBank("compass_polar")
		self.bg:GetAnimState():SetBuild("compass_polar")
		self.bg:GetAnimState():PlayAnimation("ui")
	end
	
	self:Hide()
	
	self.displayheading = 0
	self.currentheading = 0
	self.offsetheading = 0
	self.forceperdegree = 0.005 * TUNING.COMPASS_POLAR_WOBBLE_MOD
	self.headingvel = 0
	self.damping = 0.98
	self.easein = 0
	
	self.inst:ListenForEvent("polarcave_compass_get_position", function(inst, data)
		self.pt = data and data.pt or self.pt
	end, self.owner)
	self.inst:ListenForEvent("refreshinventory", function(inst)
		TryCompass(self)
	end, self.owner)
	self.inst:ListenForEvent("equip", function(inst, data)
		if data.item and data.item:HasTag("chillycompass") then
			self:OpenCompass()
		end
	end, self.owner)
	self.inst:ListenForEvent("unequip", function(inst, data)
		if data.eslot == EQUIPSLOTS.HANDS then
			self:CloseCompass()
		end
	end, self.owner)
	self.inst:ListenForEvent("inventoryclosed", function()
		self:CloseCompass()
	end, self.owner)
	
	self.isopen = false
	self.istransitioning = false
	self.wantstoclose = false
	
	self.ontransout = function(bginst)
		self.inst:RemoveEventCallback("animover", self.ontransout, bginst)
		self.istransitioning = false
		self.bg:GetAnimState():PlayAnimation("ui")
		self.needle:Show()
		self:StartUpdating()
	end
	self.ontransin = function(bginst)
		self.inst:RemoveEventCallback("animover", self.ontransin, bginst)
		self.istransitioning = false
		self.bg:GetAnimState():PlayAnimation("hidden")
		self:Hide()
	end
	
	TryCompass(self)
end)

local mastercompass = nil

local function OnRemoveMaster(inst)
	if inst == mastercompass.inst then
		mastercompass = nil
	end
end

function HudCompass_Polar:SetMaster()
	if mastercompass and mastercompass ~= self then
		mastercompass.inst:RemoveEventCallback("onremove", OnRemoveMaster)
	end
	mastercompass = self
	
	self.inst:ListenForEvent("onremove", OnRemoveMaster)
end

function HudCompass_Polar:CopyMasterNeedle()
	self.displayheading = mastercompass.displayheading
	self.currentheading = mastercompass.currentheading
	self.offsetheading = mastercompass.offsetheading
	self.headingvel = mastercompass.headingvel
	self.easein = mastercompass.easin
end

function HudCompass_Polar:OpenCompass()
	if not self.isattached then
		if not self.isopen then
			self.isopen = true
			
			if mastercompass and mastercompass ~= self then
				self:CopyMasterNeedle()
			else
				self.displayheading = self:GetCompassHeading()
				self.currentheading = self.displayheading
				self.offsetheading = 0
				self.headingvel = 0
				self.easein = 1
			end
			
			self.needle:SetRotation(self.displayheading)
			self:StartUpdating()
			self:Show()
		end
		
		return
	elseif self.wantstoclose then
		self.wantstoclose = false
		self.easein = 0
		
		return
	elseif self.isopen then
		return
	end
	
	self.isopen = true
	self.displayheading = 0
	self.currentheading = 0
	self.offsetheading = 0
	self.headingvel = 0
	self.easein = 0
	
	self.needle:SetRotation(0)
	
	if self.istransitioning then
		self.inst:RemoveEventCallback("animover", self.ontransin, self.bg.inst)
	else
		self.istransitioning = true
	end
	
	self.bg:GetAnimState():PlayAnimation("trans_out")
	self.inst:ListenForEvent("animover", self.ontransout, self.bg.inst)
	self:Show()
end

function HudCompass_Polar:CloseCompass()
	if not self.isattached then
		if self.isopen then
			self.isopen = false
			self:StopUpdating()
			self:Hide()
		end
		
		return
	elseif not self.isopen then
		return
	elseif math.abs(self.displayheading) > 1 then
		self.wantstoclose = true
		return
	end
	
	self.isopen = false
	self.wantstoclose = false
	
	if self.istransitioning then
		self.inst:RemoveEventCallback("animover", self.ontransout, self.bg.inst)
	else
		self.istransitioning = true
	end
	
	self:StopUpdating()
	self.needle:Hide()
	self.bg:GetAnimState():PlayAnimation("trans_in")
	self.inst:ListenForEvent("animover", self.ontransin, self.bg.inst)
end

local function NormalizeHeading(heading)
	while heading < -180 do heading = heading + 360 end
	while heading > 180 do heading = heading -360 end
	
	return heading
end

local function EaseHeading(heading0, heading1, k)
	local delta = NormalizeHeading(heading1 - heading0)
	return NormalizeHeading(heading0 + math.clamp(delta * k, -20, 20))
end

function HudCompass_Polar:GetCompassHeading()
	if not self.pt or not self.owner then
		return 0
	end
	
	local x, y, z = self.owner.Transform:GetWorldPosition()
	local dx = self.pt.x - x
	local dz = self.pt.z - z
	
	local camera_heading = TheCamera and TheCamera:GetHeading() or 0
	local target_angle = math.deg(math.atan2(-dx, dz))
	
	return -NormalizeHeading(target_angle - camera_heading - 90)
end

function HudCompass_Polar:OnUpdate(dt)
	if mastercompass and mastercompass ~= self then
		self:CopyMasterNeedle()
		self.needle:SetRotation(self.displayheading)
		return
	end
	
	if self.wantstoclose then
		self.displayheading = EaseHeading(self.displayheading, 0, .5)
		self.needle:SetRotation(self.displayheading)
		self:CloseCompass()
		return
	end
	
	local delta = NormalizeHeading(self:GetCompassHeading() - self.currentheading)
	
	self.headingvel = self.headingvel + delta * self.forceperdegree
	self.headingvel = self.headingvel * self.damping
	self.currentheading = NormalizeHeading(self.currentheading + self.headingvel)
	
	local t = GetTime()
	
	-- Offsets from sanity
	local sanity = self.owner.replica.sanity
	local sanity_t = math.clamp((sanity:IsInsanityMode() and sanity:GetPercent() or (1.0 - sanity:GetPercent())) * 3, 0, 1)
	local sanity_offset = math.sin(t * 0.2) * Lerp(720, 0, sanity_t)
	
	-- Offset from full moon
	local fullmoon_t = TheWorld.state.isfullmoon and math.sin(TheWorld.state.timeinphase * math.pi) or 0
	local fullmoon_offset = math.sin(t * 0.8) * Lerp(0, 720, fullmoon_t)
	
	-- Offset from wobble
	local wobble_offset = math.sin(t * 2) * 5
	
	-- Offsets from, uh, cold
	local chilly_offset = math.sin(t * 5.5) * 29 + math.cos(t * 75) * 20 + math.sin(t * 9.5) * 14
	
	self.offsetheading = EaseHeading(self.offsetheading, wobble_offset + fullmoon_offset + sanity_offset + chilly_offset, 0.5)
	
	self.easein = math.min(1, self.easein + dt)
	self.displayheading = EaseHeading(self.displayheading, self.currentheading + self.offsetheading, self.easein)
	self.needle:SetRotation(self.displayheading)
end

return HudCompass_Polar