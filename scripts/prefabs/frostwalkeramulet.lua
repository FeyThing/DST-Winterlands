local assets = {
	Asset("ANIM", "anim/torso_frostwalker_amulet.zip"),
}

local ICE_FORMING_BLOCKER_TAGS = { "shadecanopy", "crabking", "boat" }
local function FormIceBridge(inst, owner)
    if TheWorld.components.polarice_manager == nil then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    local ox, oy = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    for x = -1, 1 do
        for y = -1, 1 do
            local tx, ty = ox + x, oy + y
            local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(tx, ty)
            if next(TheSim:FindEntities(cx, cy, cz, 10, nil, nil, ICE_FORMING_BLOCKER_TAGS)) == nil then
                local tile = TheWorld.Map:GetTile(tx, ty)
                if TileGroupManager:IsOceanTile(tile) or tile == WORLD_TILES.POLAR_ICE then
                    TheWorld.components.polarice_manager:CreateTemporaryIceAtTile(tx, ty, TUNING.FROSTWALKERAMULET_ICE_STAY_TIME)
                end
            end
        end
    end
end

local function OnEquip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideSymbol("swap_body", skin_build or "torso_frostwalker_amulet", "swap_amulet")
	else
		owner.AnimState:OverrideSymbol("swap_body", "torso_frostwalker_amulet", "swap_amulet")
	end
	
	if inst.icebrigde_task then
		inst.icebrigde_task:Cancel()
		inst.icebrigde_task = nil
	end
	inst.icebrigde_task = inst:DoPeriodicTask(0.25, function() FormIceBridge(inst, owner) end)
	
	if owner.components.slipperyfeet then
		owner.components.slipperyfeet.threshold = owner.components.slipperyfeet.threshold + TUNING.FROSTWALKERAMULET_SLIPPINESS
	end
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
end

local function OnUnequip(inst, owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end
	owner.AnimState:ClearOverrideSymbol("swap_body")
	
	if inst.icebrigde_task then
		inst.icebrigde_task:Cancel()
		inst.icebrigde_task = nil
	end
	
	if owner.components.slipperyfeet then
		owner.components.slipperyfeet.threshold = owner.components.slipperyfeet.threshold - TUNING.FROSTWALKERAMULET_SLIPPINESS
	end
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

local function OnLanded(inst)
    if TheWorld.components.polarice_manager == nil then
        return
    end
    
    if inst.landed_task then
        inst.landed_task:Cancel()
        inst.landed_task = nil
    end

    inst.landed_task = inst:DoPeriodicTask(0.25, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
        local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(tx, ty)
        if next(TheSim:FindEntities(cx, cy, cz, 10, nil, nil, ICE_FORMING_BLOCKER_TAGS)) == nil then
            local tile = TheWorld.Map:GetTile(tx, ty)
            if TileGroupManager:IsOceanTile(tile) or tile == WORLD_TILES.POLAR_ICE then
                TheWorld.components.polarice_manager:CreateTemporaryIceAtTile(tx, ty, TUNING.FROSTWALKERAMULET_ICE_STAY_TIME)
            end
        end
    end)
end

local function OnNoLongerLanded(inst)
    if inst.landed_task then
        inst.landed_task:Cancel()
        inst.landed_task = nil
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("torso_frostwalker_amulet")
	inst.AnimState:SetBuild("torso_frostwalker_amulet")
	inst.AnimState:PlayAnimation("idle")
	
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

    inst:ListenForEvent("on_landed", OnLanded)
    inst:ListenForEvent("on_no_longer_landed", OnNoLongerLanded)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("frostwalkeramulet", fn, assets)