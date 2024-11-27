local BlizzardStormWatcher = Class(function(self, inst)
    self.inst = inst
	self.enabled = false
    self.blizzardstormspeedmult = TUNING.SANDSTORM_SPEED_MOD

	if TheWorld.components.blizzardstorms then
		inst:ListenForEvent("ms_stormchanged", function(src, data)
			if data.stormtype == STORM_TYPES.BLIZZARDSTORM then
				self:ToggleBlizzardStorm(data.setting)
			end
		end, TheWorld)

		if TheWorld.components.blizzardstorms:IsBlizzardStormActive() then
			self:ToggleBlizzardStorm(true)
		end
	end
end)

local function UpdateBlizzardStormWalkSpeed(inst)
    inst.components.blizzardstormwatcher:UpdateBlizzardStormWalkSpeed()
end

local function AddBlizzardStormWalkSpeedListeners(inst)
    inst:ListenForEvent("gogglevision", UpdateBlizzardStormWalkSpeed)
    inst:ListenForEvent("ghostvision", UpdateBlizzardStormWalkSpeed)
    inst:ListenForEvent("mounted", UpdateBlizzardStormWalkSpeed)
    inst:ListenForEvent("dismounted", UpdateBlizzardStormWalkSpeed)
end

local function RemoveBlizzardStormWalkSpeedListeners(inst)
    inst:RemoveEventCallback("gogglevision", UpdateBlizzardStormWalkSpeed)
    inst:RemoveEventCallback("ghostvision", UpdateBlizzardStormWalkSpeed)
    inst:RemoveEventCallback("mounted", UpdateBlizzardStormWalkSpeed)
    inst:RemoveEventCallback("dismounted", UpdateBlizzardStormWalkSpeed)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "blizzardstorm")
end

function BlizzardStormWatcher:OnRemoveFromEntity()
	if self.enabled and self.blizzardstormspeedmult < 1 then
		RemoveBlizzardStormWalkSpeedListeners(self.inst)
	end
end

function BlizzardStormWatcher:ToggleBlizzardStorm(active)
	active = active or false
	if self.enabled ~= active then
		if self.blizzardstormspeedmult < 1 then
			if active then
				AddBlizzardStormWalkSpeedListeners(self.inst)
			else
				RemoveBlizzardStormWalkSpeedListeners(self.inst)
			end
		end

		self.enabled = active

		if active then
			self:UpdateBlizzardStormLevel()
		end
	end
end

function BlizzardStormWatcher:SetBlizzardStormSpeedMultiplier(mult)
    mult = math.clamp(mult, 0, 1)
    if self.blizzardstormspeedmult ~= mult then
		if self.enabled then
			if mult >= 1 then
				RemoveBlizzardStormWalkSpeedListeners(self.inst)
			elseif self.blizzardstormspeedmult >= 1 then
				AddBlizzardStormWalkSpeedListeners(self.inst)
			end
		end

		self.blizzardstormspeedmult = mult

		if self.enabled then
			self:UpdateBlizzardStormWalkSpeed()
		end
    end
end

function BlizzardStormWatcher:UpdateBlizzardStormLevel()
	local level = self:GetBlizzardStormLevel()
	self:UpdateBlizzardStormWalkSpeed_Internal(level)
	self.inst:PushEvent("blizzardstormlevel", { level = level })
end

function BlizzardStormWatcher:UpdateBlizzardStormWalkSpeed()
	self:UpdateBlizzardStormWalkSpeed_Internal(self:GetBlizzardStormLevel())
end

function BlizzardStormWatcher:UpdateBlizzardStormWalkSpeed_Internal(level)
    if level and self.blizzardstormspeedmult < 1 then
        if level < TUNING.SANDSTORM_FULL_LEVEL or
		self.inst.components.playervision:HasGoggleVision() or
		self.inst.components.playervision:HasGhostVision() or
		self.inst.components.rider:IsRiding() then
            self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "blizzardstorm")
        else
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "blizzardstorm", self.blizzardstormspeedmult)
        end
    end
end

function BlizzardStormWatcher:GetBlizzardStormLevel()
    if self.inst.components.stormwatcher then
        return self.inst.components.stormwatcher:GetStormLevel(STORM_TYPES.BLIZZARDSTORM)
    end

    return nil
end

return BlizzardStormWatcher