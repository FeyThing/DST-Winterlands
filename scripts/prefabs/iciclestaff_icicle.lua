local assets = {
	Asset("ANIM", "anim/iciclestaff_icicle.zip")
}

local prefabs = {
    "iciclestaff_icicle_break_fx"
}

local function Break(inst)
    local x, y, z = inst.Transform:GetWorldPosition()

    if TheWorld.Map:IsOceanAtPoint(x, 0, z) then
        SpawnPrefab("splash_sink").Transform:SetPosition(x, 0, z)
    end

    SpawnPrefab("iciclestaff_icicle_break_fx").Transform:SetPosition(x, 0, z)
    inst:Remove()
end

local MUST_TAGS = { "_combat" }
local CANT_TAGS = { "INLIMBO", "playerghost" }
local function DoDamage(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, 3, MUST_TAGS, CANT_TAGS)
    for i, ent in ipairs(ents) do
        if ent:IsValid() then
            if ent:HasTag("player") and not TheNet:GetPVPEnabled() and ent ~= inst.owner then
                -- continue
            else
                ent.components.combat:GetAttacked(inst, TUNING.ICICLESTAFF_DAMAGE)
            end
        end
    end

    Break(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("iciclestaff_icicle")
    inst.AnimState:SetBuild("iciclestaff_icicle")
    inst.AnimState:PlayAnimation("fall")

    inst.AnimState:SetScale(0.5, 0.65)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.owner = nil

    inst:ListenForEvent("animover", DoDamage)
    inst:DoTaskInTime(0.5, inst.Remove)

    return inst
end

return Prefab("iciclestaff_icicle", fn, assets, prefabs)