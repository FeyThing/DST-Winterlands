local PolarStormWatcher = Class(function(self, inst)
    self.inst = inst
	self.enabled = false
    self.polarstormspeedmult = TUNING.SANDSTORM_SPEED_MOD

	if TheWorld.components.polarstorm then
		inst:ListenForEvent("ms_stormchanged", function(src, data)
			if data.stormtype == STORM_TYPES.POLARSTORM then
				self:TogglePolarStorm(data.setting)
			end
		end, TheWorld)

		if TheWorld.components.polarstorm:IsPolarStormActive() then
			self:TogglePolarStorm(true)
		end
	end
end)

local function UpdatePolarStormWalkSpeed(inst)
    inst.components.polarstormwatcher:UpdatePolarStormWalkSpeed()
end

local function AddPolarStormWalkSpeedListeners(inst)
    inst:ListenForEvent("gogglevision", UpdatePolarStormWalkSpeed)
    inst:ListenForEvent("ghostvision", UpdatePolarStormWalkSpeed)
    inst:ListenForEvent("mounted", UpdatePolarStormWalkSpeed)
    inst:ListenForEvent("dismounted", UpdatePolarStormWalkSpeed)
end

local function RemovePolarStormWalkSpeedListeners(inst)
    inst:RemoveEventCallback("gogglevision", UpdatePolarStormWalkSpeed)
    inst:RemoveEventCallback("ghostvision", UpdatePolarStormWalkSpeed)
    inst:RemoveEventCallback("mounted", UpdatePolarStormWalkSpeed)
    inst:RemoveEventCallback("dismounted", UpdatePolarStormWalkSpeed)
    inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "polarstorm")
end

function PolarStormWatcher:OnRemoveFromEntity()
	if self.enabled and self.polarstormspeedmult < 1 then
		RemovePolarStormWalkSpeedListeners(self.inst)
	end
end

function PolarStormWatcher:TogglePolarStorm(active)
	active = active or false
	if self.enabled ~= active then
		if self.polarstormspeedmult < 1 then
			if active then
				AddPolarStormWalkSpeedListeners(self.inst)
			else
				RemovePolarStormWalkSpeedListeners(self.inst)
			end
		end

		self.enabled = active

		if active then
			self:UpdatePolarStormLevel()
		end
	end
end

function PolarStormWatcher:SetPolarStormSpeedMultiplier(mult)
    mult = math.clamp(mult, 0, 1)
    if self.polarstormspeedmult ~= mult then
		if self.enabled then
			if mult >= 1 then
				RemovePolarStormWalkSpeedListeners(self.inst)
			elseif self.polarstormspeedmult >= 1 then
				AddPolarStormWalkSpeedListeners(self.inst)
			end
		end

		self.polarstormspeedmult = mult

		if self.enabled then
			self:UpdatePolarStormWalkSpeed()
		end
    end
end

function PolarStormWatcher:UpdatePolarStormLevel()
	local level = self:GetPolarStormLevel()
	self:UpdatePolarStormWalkSpeed_Internal(level)
	self.inst:PushEvent("blizzardstormlevel", { level = level })
end

function PolarStormWatcher:UpdatePolarStormWalkSpeed()
	self:UpdatePolarStormWalkSpeed_Internal(self:GetPolarStormLevel())
end

function PolarStormWatcher:UpdatePolarStormWalkSpeed_Internal(level)
    if level and self.polarstormspeedmult < 1 then
        if level < TUNING.SANDSTORM_FULL_LEVEL or
		self.inst.components.playervision:HasGoggleVision() or
		self.inst.components.playervision:HasGhostVision() or
		self.inst.components.rider:IsRiding() then
            self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "polarstorm")
        else
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "polarstorm", self.polarstormspeedmult)
        end
    end
end

function PolarStormWatcher:GetPolarStormLevel()
    if self.inst.components.stormwatcher then
        return self.inst.components.stormwatcher:GetStormLevel(STORM_TYPES.POLARSTORM)
    end

    return nil
end

return PolarStormWatcher