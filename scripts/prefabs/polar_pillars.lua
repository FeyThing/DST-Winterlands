local assets = {
	Asset("ANIM", "anim/pillar_icecave.zip"),
	Asset("SCRIPT", "scripts/prefabs/polarcaveshadow.lua"),
}

local assets_small = {
	Asset("ANIM", "anim/pillar_ice_med.zip"),
}

local function GetPolarMistRange(inst)
	return math.random(4, 8)
end

local function commonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2.5)
	
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	local scale = math.random() > 0.5 and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	return inst
end

local function shadefn()
	local inst = commonfn()
	
	inst.AnimState:SetBank("pillar_icecave")
	inst.AnimState:SetBuild("pillar_icecave")
	inst.AnimState:PlayAnimation("idle")
	
	inst.MiniMapEntity:SetIcon("pillar_polarcave.png")
	
	if not TheNet:IsDedicated() then
		inst:AddComponent("distancefade")
		inst.components.distancefade:Setup(15, 25)
		
		inst:AddComponent("polarcaveshade")
	end
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("polarmistemitter")
	inst.components.polarmistemitter:StartMisting()
	inst.components.polarmistemitter.rate = 0.1
	inst.components.polarmistemitter.radius = GetPolarMistRange
	inst.components.polarmistemitter.scale = 5
	inst.components.polarmistemitter.speed = 0.6
	inst.components.polarmistemitter.maxmist = 15
	inst.components.polarmistemitter.maxmist_range = 8
	
	return inst
end

local function smallfn()
	local inst = commonfn()
	
	inst.AnimState:SetBank("pillar_ice_med")
	inst.AnimState:SetBuild("pillar_ice_med")
	inst.AnimState:PlayAnimation("idle")
	
	inst.MiniMapEntity:SetIcon("pillar_polar.png")
	
	return inst
end

return Prefab("pillar_polarcave", shadefn, assets),
	Prefab("pillar_polar", smallfn, assets_small)