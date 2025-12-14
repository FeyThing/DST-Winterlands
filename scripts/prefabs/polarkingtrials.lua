local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0, inst.Remove)

    return inst
end

local trial_names = {
    "trial_fist_fight",
    "trial_endurence_fight",
    "trial_all_out_rumble"
}

local prefabs = {  }
for _, trial in ipairs(trial_names) do
    table.insert(prefabs, Prefab(trial, fn))
end

return unpack(prefabs)