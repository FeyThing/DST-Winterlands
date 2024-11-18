local assets = {
    Asset("ANIM", "anim/amulets.zip"),
    Asset("ANIM", "anim/torso_amulets.zip")
}

local function FormIceBridge(inst, owner)
    if TheWorld.components.polarice_manager == nil then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    local ox, oy = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    for x = -1, 1 do
        for y = -1, 1 do
            local tx, ty = ox + x, oy + y
            local tile = TheWorld.Map:GetTile(tx, ty)
            if TileGroupManager:IsOceanTile(tile) or tile == WORLD_TILES.POLAR_ICE then
                TheWorld.components.polarice_manager:CreateTemporaryIceAtTile(tx, ty, TUNING.FROSTWALKERAMULET_ICE_STAY_TIME)
            end
        end
    end
end

local function OnEquip(inst, owner)
    if inst.icebrigde_task then
        inst.icebrigde_task:Cancel()
        inst.icebrigde_task = nil
    end

    inst.icebrigde_task = inst:DoPeriodicTask(0.25, function() FormIceBridge(inst, owner) end)

    owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "blueamulet")

    if inst.components.fueled then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnequip(inst, owner)
    if inst.icebrigde_task then
        inst.icebrigde_task:Cancel()
        inst.icebrigde_task = nil
    end

    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function OnEquipToModel(inst, owner, from_ground)
    inst:RemoveEventCallback("attacked", inst.freezefn, owner)

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amulets")
    inst.AnimState:SetBuild("amulets")
    inst.AnimState:PlayAnimation("blueamulet")
    inst.scrapbook_anim = "blueamulet"

    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    inst.components.equippable.is_magic_dapperness = true
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.MAGIC
    inst.components.fueled:InitializeFuelLevel(TUNING.BLUEAMULET_FUEL)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)

    inst:AddComponent("inventoryitem")

	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.AMULET_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("frostwalkeramulet", fn, assets)