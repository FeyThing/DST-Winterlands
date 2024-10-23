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

    if not GLOBAL.TheWorld.ismastersim then
        inst._snowfx = GLOBAL.SpawnPrefab("snow")
        inst._snowfx.entity:SetParent(inst.entity)
        inst._snowfx.particles_per_tick = 0
    else
        inst.components.updatelooper:AddOnUpdateFn(OnUpdate)
    end
end)