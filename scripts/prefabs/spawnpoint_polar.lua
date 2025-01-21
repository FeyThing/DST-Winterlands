local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	
	inst:AddTag("CLASSIFIED")
	
	TheWorld:PushEvent("ms_registerspawnpoint_polar", inst)
	
	return inst
end

return Prefab("spawnpoint_polar", fn)