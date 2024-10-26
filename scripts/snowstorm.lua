AddSimPostInit(function()
    if GLOBAL.TheWorld.components.snowstorm_manager then
        GLOBAL.TheWorld.components.snowstorm_manager:OnLoad()
    end
end)

AddPrefabPostInit("forest", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("snowstorm_manager")
    end
end)

AddPrefabPostInit("player_classified", function(inst)
    inst.snowstormlevel = GLOBAL.net_float(inst.GUID, "snowstormlevel", "snowstormleveldirty")

    inst:DoStaticTaskInTime(0, function(inst)
        inst:ListenForEvent("snowstormleveldirty", function(inst)
            if not GLOBAL.TheWorld.ismastersim then
                inst._parent._snowfx.particles_per_tick = 20 * inst.snowstormlevel:value()
            end
        end)
    end)
end)

local function OnUpdate(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local snowstormlevel = GLOBAL.TheWorld.components.snowstorm_manager:GetAtPoint(x, y, z)
    inst.player_classified.snowstormlevel:set(snowstormlevel)
end

AddPlayerPostInit(function(inst)
    if not inst.components.updatelooper then
        inst:AddComponent("updatelooper")
    end

    if not GLOBAL.TheNet:IsDedicated() then
        inst._snowfx = GLOBAL.SpawnPrefab("snowstorm_snow")
        inst._snowfx.entity:SetParent(inst.entity)
        inst._snowfx.particles_per_tick = 0
        inst._snowfx:PostInit()
    end

    if GLOBAL.TheWorld.ismastersim then
        inst.components.updatelooper:AddOnUpdateFn(OnUpdate)
    end
end)

local Weather = require("components/weather")
local old_Weather_ctor = Weather._ctor
Weather._ctor = function(self, ...)
    old_Weather_ctor(self, ...)

    local old_OnUpdate = self.OnUpdate
    self.OnUpdate = function(...)
        old_OnUpdate(...)

        if GLOBAL.ThePlayer and GLOBAL.ThePlayer.player_classified.snowstormlevel:value() ~= 0 then
            if GLOBAL.TheWorld.SoundEmitter:PlayingSound("rain") then
                -- GLOBAL.TheWorld.SoundEmitter:SetParameter("rain", "intensity", 0) -- Does "rain" even have the intensity parameter???
                GLOBAL.TheWorld.SoundEmitter:SetVolume("rain", 0)
            end

            if GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("treerainsound") then
                GLOBAL.TheFocalPoint.SoundEmitter:SetParameter("treerainsound", "intensity", 0)
            end

            if GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("umbrellarainsound") then
                GLOBAL.TheFocalPoint.SoundEmitter:SetVolume("umbrellarainsound", 0)
            end

            if GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("barriersound") then
                GLOBAL.TheFocalPoint.SoundEmitter:SetVolume("barriersound", 0)
            end
        else
            if GLOBAL.TheWorld.SoundEmitter:PlayingSound("rain") then
                GLOBAL.TheWorld.SoundEmitter:SetVolume("rain", 1)
            end

            if GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("umbrellarainsound") then
                GLOBAL.TheFocalPoint.SoundEmitter:SetVolume("umbrellarainsound", 1)
            end

            if GLOBAL.TheFocalPoint.SoundEmitter:PlayingSound("barriersound") then
                GLOBAL.TheFocalPoint.SoundEmitter:SetVolume("barriersound", 1)
            end
        end
    end
end

local function DisableParticlesInWinterlands(inst)
    if not inst.components.updatelooper then
        inst:AddComponent("updatelooper")
    end

    if not GLOBAL.TheWorld.ismastersim then
        inst.components.updatelooper:AddOnUpdateFn(function()
            if GLOBAL.ThePlayer and GLOBAL.ThePlayer.player_classified.snowstormlevel:value() ~= 0 then
                inst.particles_per_tick = 0

                if inst.splashes_per_tick ~= nil then
                    inst.splashes_per_tick = 0
                end
            end
        end)
    end
end

-- TODO: rain (and probably also snow) particles are sometimes present on reset even when in winterlands (c_reset())

AddPrefabPostInit("snow", DisableParticlesInWinterlands)
AddPrefabPostInit("rain", DisableParticlesInWinterlands)

local Moisture = require("components/moisture")
local old_Moisture_GetMoistureRateAssumingRain = Moisture._GetMoistureRateAssumingRain
Moisture._GetMoistureRateAssumingRain = function(self, ...)
    if self.inst.player_classified.snowstormlevel:value() ~= 0 then
        return 0
    end
    
    return old_Moisture_GetMoistureRateAssumingRain(self, ...)
end