local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddPrefabPostInit("antlion_sinkhole", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	-- TODO: Clear High Snow in area, change ice breaking to a wider tiles scan
	inst:Hide() -- Fix for the 1st frame that shows the sinkhole when it spawns
	
	if TheWorld.components.polarice_manager then
		inst:DoTaskInTime(0, function(inst) -- Delay by 1 frame so the position is set
			local x, y, z = inst.Transform:GetWorldPosition()
			local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
			local tile = TheWorld.Map:GetTile(tx, ty)
			
			if tile == WORLD_TILES.POLAR_ICE then
				TheWorld.components.polarice_manager:StartDestroyingIceAtTile(tx, ty, TUNING.POLAR_ICEGEN_DEFAULT_HOLE_TIME, nil, "ice")
				inst:Remove()
			else
				inst:Show()
			end
		end)
	end
end)