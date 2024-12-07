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

local MUST_TAGS = { "_combat" }
local CANT_TAGS = { "INLIMBO", "playerghost", "player" }
local function DoFrostAura(inst, target, pos, doer)
    if doer then
        if doer.components.sanity then
            doer.components.sanity:DoDelta(-TUNING.ICICLESTAFF_SANITY_COST)
        end

        local x, y, z = doer.Transform:GetWorldPosition()
        SpawnPrefab("polar_frostaura").Transform:SetPosition(x, y, z)
        SpawnPrefab("groundpoundring_fx").Transform:SetPosition(x, y, z)
        inst.SoundEmitter:PlaySound("dontstarve/common/break_iceblock")

        local ents = TheSim:FindEntities(x, 0, z, 12, MUST_TAGS, CANT_TAGS)
        for i, ent in ipairs(ents) do
            if ent:IsValid() and ent.components.freezable and not ent:HasTag("player") then
                ent.components.freezable:AddColdness(10, TUNING.FROSTAURASTAFF_FREEZE_TIME) -- Very high freeze value
            end
        end

        if TheWorld.components.polarice_manager then
            
        end
    
        inst.components.finiteuses:Use(1)

        return true
    end

    return false
end

local function OnFinished(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner and owner.SoundEmitter then
        owner.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    end

    inst:Remove()
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
    -- inst.scrapbook_specialinfo = "FROSTAURA_STAFF"

    local floater_swap_data = {
        sym_build = "swap_staffs",
        sym_name = "swap_bluestaff",
        bank = "staffs",
        anim = "bluestaff"
    }

    MakeInventoryFloatable(inst, "med", 0.1, { 0.8, 0.4, 0.8 }, true, -13, floater_swap_data)

    inst:AddTag("shadowlevel")
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("frostaurastaff")

    inst.entity:SetPristine()

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
    inst.components.finiteuses:SetMaxUses(TUNING.FROSTAURASTAFF_USES)
    inst.components.finiteuses:SetUses(TUNING.FROSTAURASTAFF_USES)
    inst.components.finiteuses:SetOnFinished(OnFinished)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(DoFrostAura)
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseonpoint_water = true
    inst.components.spellcaster.can_cast_fn = function(doer, target, pos) return true end

    inst:AddComponent("shadowlevel")
    inst.components.shadowlevel:SetDefaultLevel(TUNING.STAFF_SHADOW_LEVEL)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("frostaurastaff", fn, assets, prefabs)