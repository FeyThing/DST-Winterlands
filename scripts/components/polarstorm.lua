return Class(function(self, inst)
    assert(TheWorld.ismastersim, "Polar Storm should not exist on client")
    
	-- [ Public fields ] --
    self.inst = inst

	-- [ Private fields ] --
    local _polarstormactive = false
	
	local POLAR_BLIZZARDS_CONFIG = TUNING.POLAR_BLIZZARDS_CONFIG
    local _blizzard_cooldown_min = TUNING.POLAR_STORM_COOLDOWN_MIN
    local _blizzard_cooldown_max = TUNING.POLAR_STORM_COOLDOWN_MAX
    local _blizzard_length_min = TUNING.POLAR_STORM_LENGTH_MIN
    local _blizzard_length_max = TUNING.POLAR_STORM_LENGTH_MAX

    local _blizzard_configs = {
        [-2] = 0,   -- Doesn't really matter, polarstorm is not added to the world if None is selected
        [-1] = 0.5, -- Less
        [0] = 1,    -- Default
        [1] = 2,    -- More
        [2] = 4     -- Most
    }

    local _season = SEASONS.AUTUMN
    local _blizzard_season_mult = {
        autumn = { cooldown_mult = 1,    length_mult = 1 },
        winter = { cooldown_mult = 0.66, length_mult = 1.33 },
        spring = { cooldown_mult = 1,    length_mult = 1.2 },
        summer = { cooldown_mult = 2,    length_mult = 0.66 }
    }
	
    local _blizzard_cd_task
    local _blizzard_time_task
	local _blizzard_start_time
    
	local BLIZZARD_SHELTER_TAGS = {"blizzardprotection"}
	local BLIZZARD_SHELTER_NOT_TAGS = {"INLIMBO"}
	
	-- [ Functions ] --
    local function OnSeasonChange(_, season)
		local curseason = POLARRIFY_MOD_SEASONS[season]
        _season = curseason
		
		if _blizzard_season_mult[curseason] == nil then
			_season = "autumn"
		end
		
        if _blizzard_time_task then -- Update task period
            local timeleft = _blizzard_time_task.period * _blizzard_season_mult[curseason].cooldown_mult
            _blizzard_time_task.period = timeleft
        end

        if _blizzard_cd_task then -- Update task period
            local timeleft = _blizzard_cd_task.period * _blizzard_season_mult[curseason].length_mult
            _blizzard_cd_task.period = timeleft
        end
    end

    local function StartBlizzard()
        if _polarstormactive then
            return
        end

        _polarstormactive = true
		_blizzard_start_time = nil
		
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
    inst:WatchWorldState("season", OnSeasonChange)
    OnSeasonChange(inst, inst.state.season)

    function self:OnPostInit()
        if _blizzard_cd_task == nil and _blizzard_time_task == nil then
            self:RequeueBlizzard(math.random(_blizzard_cooldown_min, _blizzard_cooldown_max) * _blizzard_season_mult[_season].cooldown_mult / _blizzard_configs[POLAR_BLIZZARDS_CONFIG])
        end
    end

    -- [ Methods ] --
    function self:RequeueBlizzard(cooldown) -- Requeues a blizzard to happen after [cooldown], length is random, next blizzard will set the default cooldown
        RestartTasks()
		
		_blizzard_start_time = GetTime() + cooldown
        _blizzard_cd_task = inst:DoTaskInTime(cooldown, function()
            StartBlizzard()
            _blizzard_time_task = inst:DoTaskInTime(math.random(_blizzard_length_min, _blizzard_length_max) * _blizzard_season_mult[_season].length_mult * _blizzard_configs[POLAR_BLIZZARDS_CONFIG], function()
                StopBlizzard()
                self:RequeueBlizzard(math.random(_blizzard_cooldown_min, _blizzard_cooldown_max) * _blizzard_season_mult[_season].cooldown_mult / _blizzard_configs[POLAR_BLIZZARDS_CONFIG])
            end)

            _blizzard_cd_task = nil
        end)
    end

    function self:PushBlizzard(length) -- Forces an instant blizzard of length [length], the next blizzard will roll the default length
        RestartTasks()
        
        StartBlizzard()
        _blizzard_time_task = inst:DoTaskInTime(length, function()
            StopBlizzard()
            self:RequeueBlizzard(math.random(_blizzard_cooldown_min, _blizzard_cooldown_max) * _blizzard_season_mult[_season].cooldown_mult / _blizzard_configs[POLAR_BLIZZARDS_CONFIG])
        end)
    end
    
    function self:IsInPolarStorm(ent)
        return self:GetPolarStormLevel(ent) ~= 0
    end
	
	function self:GetPolarStormLevel(ent)
		local stormlevel = (ent and self:IsPolarStormActive() and TheWorld.components.polarsnow_manager)
			and TheWorld.components.polarsnow_manager:GetDataAtPoint(ent.Transform:GetWorldPosition()) or 0
		
		if stormlevel <= 0 then
			return 0
		end
		
		local x, y, z = ent.Transform:GetWorldPosition()
		local shelters = TheSim:FindEntities(x, y, z, 30, nil, BLIZZARD_SHELTER_NOT_TAGS, BLIZZARD_SHELTER_TAGS)
		
		local minlevel = stormlevel
		for _, shelter in ipairs(shelters) do
			if not (ent.components.fueled and shelter.components.firefx) then
				local px, py, pz = shelter.Transform:GetWorldPosition()
				local shelterrad = shelter.blizzardprotect_rad or 0
				local distancesq = distsq(x, z, px, pz)
				
				if distancesq <= shelterrad * shelterrad then
					local shelterdist = math.sqrt(distancesq)
					local normalizedist = math.clamp(shelterdist / shelterrad, 0, 1)
					
					local shelterlevel = math.clamp(0.2 + (normalizedist^2) * 0.5, 0.2, 1)
					minlevel = math.min(minlevel, shelterlevel)
				end
			end
		end
		
		if minlevel > TUNING.POLAR_STORM_LIGHTER_LEVEL and ent.components.inventory
			and (ent.components.inventory:EquipHasTag("fire") or ent.components.inventory:EquipHasTag("bearhead")) then
			
			minlevel = TUNING.POLAR_STORM_LIGHTER_LEVEL
		end
		
		return minlevel
	end
	
    function self:IsPolarStormActive()
        return _polarstormactive
    end
	
	function self:GetTimeLeft()
		if self:IsPolarStormActive() then
			return _blizzard_time_task and GetTaskRemaining(_blizzard_time_task) or 0
		else
			return _blizzard_cd_task and GetTaskRemaining(_blizzard_cd_task) or 0
		end
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
	
	function self:LongUpdate(dt)
		local time_left = self:GetTimeLeft()
		if time_left == nil or dt == nil or dt < 5 then
			return
		end
		
		local time_updated = time_left - dt
		if _blizzard_time_task then
			self:PushBlizzard(time_updated)
		elseif _blizzard_cd_task then
			self:RequeueBlizzard(time_updated)
		end
	end
end)