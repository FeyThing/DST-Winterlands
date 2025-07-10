local ENV = env
GLOBAL.setfenv(1, GLOBAL)

for prefab, _ in pairs(TUNING.POLARBEAR_TREASURES) do
    ENV.AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then
            return
        end

        if not inst.components.tradable then
            inst:AddComponent("tradable")
        end
    end)
end