local assets = {
    Asset("ANIM", "anim/deer_ice_circle.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deer_ice_circle")
    inst.AnimState:SetBuild("deer_ice_circle")
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetScale(2, 2)

    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("FX")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("colourtweener")

    inst.persists = false

    inst:DoTaskInTime(3, function()
        inst.components.colourtweener:StartTween({ 1, 1, 1, 0.5 }, 2)
    end)

    inst:DoTaskInTime(5, function()
        inst.AnimState:PlayAnimation("pst")
    end)

    return inst
end

return Prefab("polar_frostaura", fn, assets)