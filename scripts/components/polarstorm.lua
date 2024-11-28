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
        return (ent and self:IsPolarStormActive() and TheWorld.components.polarsnow_manager) and
        TheWorld.components.polarsnow_manager:GetDataAtPoint(ent.Transform:GetWorldPosition()) or
        0
    end
    
    function self:IsPolarStormActive()
        return _polarstormactive
    end
end)