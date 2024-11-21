AddPrefabPostInit("antlion_sinkhole", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    inst:Hide() -- Fix for the 1st frame that shows the sinkhole when it spawns

    if GLOBAL.TheWorld.components.polarice_manager then
        inst:DoTaskInTime(0, function(inst) -- Delay by 1 frame so the position is set
            local x, y, z = inst.Transform:GetWorldPosition()
            local tx, ty = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
            local tile = GLOBAL.TheWorld.Map:GetTile(tx, ty)
            if tile == GLOBAL.WORLD_TILES.POLAR_ICE then
                GLOBAL.TheWorld.components.polarice_manager:StartDestroyingIceAtTile(tx, ty, false)
                inst:Remove()
            else
                inst:Show()
            end
        end)
    end
end)