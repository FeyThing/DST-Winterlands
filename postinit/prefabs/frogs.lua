local prefabs = {
    "frog",
    "lunarfrog"
}

for i, prefab in ipairs(prefabs) do
    AddPrefabPostInit(prefab, function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        inst:DoTaskInTime(0, function(inst) -- LukaS: Will this be enough?
            local x, y, z = inst.Transform:GetWorldPosition()

            if GLOBAL.next(GLOBAL.TheSim:FindEntities(x, 0, z, GLOBAL.TUNING.SHADE_POLAR_RANGE, { "icecaveshelter" })) ~= nil then
                if y > 30 then
                    inst:Remove()
                end
            end
        end)
    end)
end