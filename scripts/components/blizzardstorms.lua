return Class(function(self, inst)
    assert(TheWorld.ismastersim, "Blizzard Storms should not exist on client")
    
	-- [ Public fields ] --
    self.inst = inst

	-- [ Private fields ] --
    local _worldstate = TheWorld.state
    local _blizzardstormactive = false
    local _israining = false
    
	-- [ Functions ] --
    local function ShouldActivateBlizzardStorm()
        return _israining
    end
    
    local function ToggleBlizzardStorm()
        if _blizzardstormactive ~= ShouldActivateBlizzardStorm() then
            _blizzardstormactive = not _blizzardstormactive
            inst:PushEvent("ms_stormchanged", { stormtype = STORM_TYPES.BLIZZARDSTORM, setting = _blizzardstormactive })
        end
    end
    
    local function OnIsRaining(src, data)
        _israining = data
        ToggleBlizzardStorm()
    end
    
	-- [ Initialization ] --
    inst:WatchWorldState("israining", OnIsRaining)
    
    -- [ Post initialization ] --
    function self:OnPostInit()
        OnIsRaining(inst, _worldstate.israining)
    end

    -- [ Methods ] --
    function self:IsInBlizzardStorm(ent)
        return self:GetBlizzardStormLevel(ent) ~= 0
    end
    
    function self:GetBlizzardStormLevel(ent)
        return (ent and self:IsBlizzardStormActive() and TheWorld.components.snowstorm_manager) and
        TheWorld.components.snowstorm_manager:GetDataAtPoint(ent.Transform:GetWorldPosition()) or
        0
    end
    
    function self:IsBlizzardStormActive()
        return _blizzardstormactive
    end
end)