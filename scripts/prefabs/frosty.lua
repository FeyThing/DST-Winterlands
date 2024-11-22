local assets = {
    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/spider_build.zip")
}

local prefabs = {
    "monstermeat"
}

local RETARGET_MUST_TAGS = { "_combat", "character" }
local RETARGET_CANT_TAGS = { "prey", "smallcreature", "INLIMBO" }
local function RetargetFn(inst)
    return FindEntity(inst, TUNING.FROSTY_TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
    end,
    RETARGET_MUST_TAGS,
    RETARGET_CANT_TAGS)
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function CalcSanityAura(inst)
    return inst.components.combat.target and -TUNING.SANITYAURA_HUGE or -TUNING.SANITYAURA_LARGE
end

local brain = require "brains/frostybrain"

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(1.5, .5)
    inst.Transform:SetFourFaced()

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("scarytoprey")

    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild("spider_build")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = TUNING.FROSTY_STAGE1_WALK_SPEED
    
    inst:AddComponent("drownable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot("monstermeat", 1)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.FROSTY_STAGE1_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.FROSTY_STAGE1_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.FROSTY_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat.hiteffectsymbol = "body"

    inst:AddComponent("knownlocations")

    inst:AddComponent("inspectable")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:SetStateGraph("SGfrosty")

    inst:SetBrain(brain)

    return inst
end

return Prefab("frosty", fn, assets, prefabs)