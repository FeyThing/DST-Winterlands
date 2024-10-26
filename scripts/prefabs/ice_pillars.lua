local function MakePillar(name, bank, build, anim, loop, height, minimap)
    local assets = {
        Asset("ANIM", "anim/"..build..".zip"),
    }
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddMiniMapEntity()
    
        MakeObstaclePhysics(inst, height or 2)
    
        --inst.MiniMapEntity:SetIcon(minimap..".tex")
    
        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle", true)
    
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
    
        return inst
    end

    return Prefab(name, fn, assets)
end

local function MakeShadePillar(name, bank, build, anim, loop, height, minimap)
    local assets = {
        Asset("ANIM", "anim/"..build..".zip"),
    }
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddMiniMapEntity()
    
        MakeObstaclePhysics(inst, height or 2)
    
        --inst.MiniMapEntity:SetIcon(minimap..".tex")
    
        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle", true)
    
        if not TheNet:IsDedicated() then
            inst:AddComponent("distancefade")
            inst.components.distancefade:Setup(15,25)
    
            inst:AddComponent("icecavepillarshade")
            inst.components.icecavepillarshade.range = math.floor(TUNING.SHADE_CANOPY_RANGE/8)
        end

        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
    
        return inst
    end

    return Prefab(name, fn, assets)
end

return MakePillar("pillar_ice_med", "pillar_ice_med", "pillar_ice_med", "idle", true, 2),
    MakeShadePillar("pillar_icecave", "pillar_icecave", "pillar_icecave", "idle", true, 2)