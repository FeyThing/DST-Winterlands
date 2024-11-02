AddSimPostInit(function()
    if GLOBAL.TheWorld.components.polarice_manager then
        GLOBAL.TheWorld.components.polarice_manager:OnLoad()
    end
end)

AddPrefabPostInit("forest", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("polarice_manager")
    end
end)