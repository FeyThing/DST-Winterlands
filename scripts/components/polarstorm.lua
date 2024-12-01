return Class(function(self, inst)
    assert(TheWorld.ismastersim, "Polar Storm should not exist on client")
    
	-- [ Public fields ] --
    self.inst = inst

	-- [ Private fields ] --
    local _polarstormactive = false

    local _blizzard_cooldown_min = TUNING.POLAR_STORM_COOLDOWN_MIN
    local _blizzard_cooldown_max = TUNING.POLAR_STORM_COOLDOWN_MAX
    local _blizzard_length_min = TUNING.POLAR_STORM_LENGTH_MIN
    local _blizzard_length_max = TUNING.POLAR_STORM_LENGTH_MAX

    local _blizzard_cd_task
    local _blizzard_time_task
    
	-- [ Functions ] --
    local function StartBlizzard()
        if _polarstormactive then
            return
        end

        _polarstormactive = true
        inst:PushEvent("ms_stormchanged", { stormtype = STORM_TYPES.POLARSTORM, setting = _polarstormactive })
    end

    local function StopBlizzard()
        if not _polarstormactive then
            return
        end

        _polarstormactive = false
        inst:PushEvent("ms_stormchanged", { stormtype = STORM_TYPES.POLARSTORM, setting = _polarstormactive })
    end

    local function RestartTasks()
        if _blizzard_cd_task then
            _blizzard_cd_task:Cancel()
            _blizzard_cd_task = nil
        end

        if _blizzard_time_task then
            _blizzard_time_task:Cancel()
            _blizzard_time_task = nil
            StopBlizzard()
        end
    end

	-- [ Initialization ] --
    function self:OnPostInit()
        if _blizzard_cd_task == nil and _blizzard_time_task == nil then
            self:RequeueBlizzard(math.random(_blizzard_cooldown_min, _blizzard_cooldown_max))
        end
    end

    -- [ Methods ] --
    function self:RequeueBlizzard(cooldown)
        RestartTasks()

        _blizzard_cd_task = inst:DoTaskInTime(cooldown, function()
            StartBlizzard()
            _blizzard_time_task = inst:DoTaskInTime(math.random(_blizzard_length_min, _blizzard_length_max), function()
                StopBlizzard()
                self:RequeueBlizzard(math.random(_blizzard_cooldown_min, _blizzard_cooldown_max))
            end)
        end)
    end

    function self:PushBlizzard(length)
        RestartTasks()
        
        StartBlizzard()
        _blizzard_time_task = inst:DoTaskInTime(length, function()
            StopBlizzard()
            self:RequeueBlizzard(math.random(_blizzard_cooldown_min, _blizzard_cooldown_max))
        end)
    end
    
    function self:IsInPolarStorm(ent)
        return self:GetPolarStormLevel(ent) ~= 0
    end
    
    function self:GetPolarStormLevel(ent)
        local stormlevel = (ent and self:IsPolarStormActive() and TheWorld.components.polarsnow_manager) and
        TheWorld.components.polarsnow_manager:GetDataAtPoint(ent.Transform:GetWorldPosition()) or
        0

        local x, y, z = ent.Transform:GetWorldPosition()
        local pillars = TheSim:FindEntities(x, y, z, TUNING.SHADE_POLAR_RANGE, { "icecaveshelter" })
        local minsq = TUNING.SHADE_POLAR_RANGE * TUNING.SHADE_POLAR_RANGE
        for i, pillar in ipairs(pillars) do
            local px, py, pz = pillar.Transform:GetWorldPosition()
            if distsq(x, z, px, pz) <= minsq then
                minsq = distsq(x, z, px, pz)
            end
        end

        return stormlevel * math.clamp((math.sqrt(minsq) - TUNING.SHADE_POLAR_RANGE + TILE_SCALE) / TILE_SCALE, 0.2, 1)
    end
    
    function self:IsPolarStormActive()
        return _polarstormactive
    end

    -- [ Save / Load ] --
    function self:OnSave()
        if _blizzard_time_task then -- If (for some reason) both timers exist prioritize blizzard time left
            return { blizzard_time_left = GetTaskRemaining(_blizzard_time_task) }
        elseif _blizzard_cd_task then
            return { blizzard_cd_left = GetTaskRemaining(_blizzard_cd_task) }
        end
    end

    function self:OnLoad(data)
        if data then
            if data.blizzard_time_left then
                self:PushBlizzard(data.blizzard_time_left)
            elseif data.blizzard_cd_left then
                self:RequeueBlizzard(data.blizzard_cd_left)
            end
        end
    end
end)