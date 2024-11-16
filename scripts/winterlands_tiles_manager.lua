-- [ Winterlands Tiles ] --
AddSimPostInit(function()
    if GLOBAL.TheWorld.components.winterlands_manager then
        GLOBAL.TheWorld.components.winterlands_manager:OnLoad()
    end
end)

AddPrefabPostInit("forest", function(inst)
    inst:AddComponent("winterlands_manager")
end)

-- [ Snow Storm Tiles ] --

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
                inst._parent._snowfx.particles_per_tick = 16 * inst.snowstormlevel:value()
            end
        end)
    end)
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

AddPlayerPostInit(function(inst)
    local function OnUpdate(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local snowstormlevel = GLOBAL.TheWorld.components.snowstorm_manager:GetDataAtPoint(x, y, z)
        inst.player_classified.snowstormlevel:set(snowstormlevel)
    end

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
        inst:DoTaskInTime(1, function() -- Delay the first check to make sure the snowstormlevel is synced
            OnUpdate(inst)
            inst.components.updatelooper:AddOnUpdateFn(OnUpdate)
        end)
    end
end)

local function DisableParticlesInWinterlands(inst)
    local function OnUpdate(inst)
        if GLOBAL.ThePlayer and GLOBAL.ThePlayer.player_classified.snowstormlevel:value() ~= 0 then
            inst.particles_per_tick = 0

            if inst.splashes_per_tick ~= nil then
                inst.splashes_per_tick = 0
            end
        end
    end

    if not inst.components.updatelooper then
        inst:AddComponent("updatelooper")
    end

    if not GLOBAL.TheWorld.ismastersim then
        inst:DoTaskInTime(1, function() -- Delay the first check to make sure the snowstormlevel is synced
            OnUpdate(inst)
            inst.components.updatelooper:AddOnUpdateFn(OnUpdate)
        end)
    end
end

AddPrefabPostInit("snow", DisableParticlesInWinterlands)
AddPrefabPostInit("rain", DisableParticlesInWinterlands)
AddPrefabPostInit("pollen", DisableParticlesInWinterlands)

local Moisture = require("components/moisture")
local old_Moisture_GetMoistureRateAssumingRain = Moisture._GetMoistureRateAssumingRain
Moisture._GetMoistureRateAssumingRain = function(self, ...)
    if self.inst.player_classified.snowstormlevel:value() ~= 0 then
        return 0
    end
    
    return old_Moisture_GetMoistureRateAssumingRain(self, ...)
end

-- [ Polar Ice Tiles ] --

AddPrefabPostInit("forest", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("polarice_manager")
    end
end)

local HullHealth = require("components/hullhealth")
local old_OnCollide = HullHealth.OnCollide
HullHealth.OnCollide = function(self, data, ...)
    old_OnCollide(self, data, ...)

    local absolute_hit_normal_overlap_percentage = math.abs(data.hit_dot_velocity)
    local damage_alignment = absolute_hit_normal_overlap_percentage / (data.speed_damage_factor or 1)
    if damage_alignment > 0.258 then -- math.cos(75deg)
        local hit_adjacent_speed = self.inst.components.boatphysics:GetVelocity() * absolute_hit_normal_overlap_percentage
        if hit_adjacent_speed > 2 then
            local dist = (GLOBAL.TILE_SCALE + self.inst.components.walkableplatform.platform_radius) / 2
            local normal = -GLOBAL.Vector3(data.world_normal_on_b_x, data.world_normal_on_b_y, data.world_normal_on_b_z):Normalize()
            local tpos = GLOBAL.Vector3(data.world_position_on_a_x, data.world_position_on_a_y, data.world_position_on_a_z)
            tpos = tpos + normal * dist

            local hit_tile = GLOBAL.TheWorld.Map:GetTileAtPoint(tpos:Get())
            if hit_tile == GLOBAL.WORLD_TILES.POLAR_ICE then
                local tx, ty = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(tpos:Get())
                GLOBAL.TheWorld.components.polarice_manager:DestroyIceAtTile(tx, ty, false)
            end
        end
    end
end