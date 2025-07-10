local function OnInit(inst)
	if TheWorld.components.polarice_manager then
		TheWorld.components.polarice_manager:CreateIceAtPoint(inst.Transform:GetWorldPosition())
	end
	
	inst:Remove()
end

local function fn()
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