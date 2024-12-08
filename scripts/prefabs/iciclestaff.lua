local assets = {
    Asset("ANIM", "anim/staffs.zip"),
    Asset("ANIM", "anim/swap_staffs.zip")
}

local prefabs = {
    "iciclestaff_icicle"
}

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_bluestaff")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Show("ARM_normal")
    owner.AnimState:Hide("ARM_carry")
end

local function SummonIcicles(inst, target, pos, doer)
    local x, y, z
    if target then
        x, y, z = target.Transform:GetWorldPosition()
    elseif pos then
        x, y, z = pos:Get()
    else
        return false
    end

    if doer and doer.components.sanity then
        doer.components.sanity:DoDelta(-TUNING.ICICLESTAFF_SANITY_COST)
    end

    for i = 0, TUNING.ICICLESTAFF_ICICLES_NUM do
        TheWorld:DoTaskInTime(0.1 * i, function()
            local x2 = 3 - math.random() * 6
            local z2 = 3 - math.random() * 6
    
            local proj = SpawnPrefab("iciclestaff_icicle")
            proj.Transform:SetPosition(x + x2, 0, z + z2)
            proj.owner = doer
        end)
    end
    
    inst.components.finiteuses:Use(1)
end

local function OnFinished(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner.SoundEmitter then
        owner.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    end

    inst:Remove()
end

local function reticuletargetfn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(15, 0.001, 0))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("staffs")
    inst.AnimState:SetBuild("staffs")
    inst.AnimState:PlayAnimation("bluestaff")
    inst.scrapbook_anim = "bluestaff"
    -- inst.scrapbook_specialinfo = "ICICLE_STAFF"

    local floater_swap_data = {
        sym_build = "swap_staffs",
        sym_name = "swap_bluestaff",
        bank = "staffs",
        anim = "bluestaff"
    }

    MakeInventoryFloatable(inst, "med", 0.1, { 0.8, 0.4, 0.8 }, true, -13, floater_swap_data)

    inst:AddTag("shadowlevel")
    inst:AddTag("nopunch")
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("castontargets")

    inst.entity:SetPristine()

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = reticuletargetfn
    inst.components.reticule.ease = true
    inst.components.reticule.ispassableatallpoints = true
    inst.components.reticule.reticuleprefab = "reticuleaoe"
    inst.components.reticule.pingprefab = "reticuleaoeping"
    inst.components.reticule.mouseenabled = true

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("tradable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.ICICLESTAFF_USES)
    inst.components.finiteuses:SetUses(TUNING.ICICLESTAFF_USES)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(SummonIcicles)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.can_cast_fn = function(doer, target, pos) return true end
    inst.components.spellcaster.quickcast = true

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.STAFF_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("iciclestaff", fn, assets, prefabs)