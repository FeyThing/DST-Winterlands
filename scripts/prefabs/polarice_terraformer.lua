local function OnInit(inst)
	if TheWorld.components.polarice_manager then
		local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(inst.Transform:GetWorldPosition())
		
		TheWorld.components.polarice_manager:SetIceLevelAtTile(tx, ty, 1)
		TheWorld.components.polarice_manager:CreateIceAtTile(tx, ty, nil, true)
	end
	
	inst:Remove()
end

local function fn() -- Used in some setpieces to force non-melting Ice Tiles to generate outside of the Winterlands
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	inst:DoTaskInTime(0, OnInit)
	
	return inst
end

return Prefab("polarice_terraformer", fn)