return Class(function(self, inst)
    assert(TheWorld.ismastersim, "Polar Storm should not exist on client")
    
	-- [ Public fields ] --
    self.inst = inst

	-- [ Private fields ] --
    local _worldstate = TheWorld.state
    local _polarstormactive = false
    local _israining = false
    
	-- [ Functions ] --
    local function ShouldActivatePolarStorm()
        return _israining
    end
    
    local function TogglePolarStorm()
        if _polarstormactive ~= ShouldActivatePolarStorm() then
            _polarstormactive = not _polarstormactive
            inst:PushEvent("ms_stormchanged", { stormtype = STORM_TYPES.POLARSTORM, setting = _polarstormactive })
        end
    end
    
    local function OnIsRaining(src, data)
        _israining = data
        TogglePolarStorm()
    end
    
	-- [ Initialization ] --
    inst:WatchWorldState("israining", OnIsRaining)
    
    -- [ Post initialization ] --
    function self:OnPostInit()
        OnIsRaining(inst, _worldstate.israining)
    end

    -- [ Methods ] --
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
end)