local assets = {
	Asset("ANIM", "anim/polar_throne.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.5)
	
	inst.AnimState:SetBank("polar_throne")
	inst.AnimState:SetBuild("polar_throne")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("polarthrone")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("polar_throne", fn, assets)