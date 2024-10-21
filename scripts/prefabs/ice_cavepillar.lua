local assets = {
	Asset("ANIM", "anim/pillar_icecave.zip"),
	Asset("SCRIPT", "scripts/prefabs/icecavepillarshadow.lua")
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst,2)
		
	inst.AnimState:SetBank("pillar_icecave")
	inst.AnimState:SetBuild("pillar_icecave")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	inst:AddTag("NOCLICK")
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("distancefade")
		inst.components.distancefade:Setup(15, 25)
		
		inst:AddComponent("icecavepillarshade")
		inst.components.icecavepillarshade.range = math.floor(TUNING.SHADE_CANOPY_RANGE / 8)
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	
	return inst
end

return Prefab("ice_cavepillar", fn, assets)