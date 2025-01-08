local assets = {
	Asset("ANIM", "anim/polar_throne.zip"),
}

local assets_gifts = {
	Asset("ANIM", "anim/polar_throne_gifts.zip"),
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.5)
	
	inst.DynamicShadow:SetSize(2, 1)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("polar_throne")
	inst.AnimState:SetBuild("polar_throne")
	inst.AnimState:PlayAnimation("idle")
	
	--inst:AddTag("faced_chair")
	inst:AddTag("polarthrone")
	inst:AddTag("rotatableobject")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "polar_throne._snowblockrange")
	inst._snowblockrange:set(5)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.Transform:SetRotation(math.random() * 360)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("savedrotation")
	inst.components.savedrotation.dodelayedpostpassapply = true
	
	--inst:AddComponent("sittable") TODO: could be nice for later, but it will not be too simple
	
	MakeHauntableLaunch(inst)
	
	return inst
end

--

local NUM_VARS = 3

local function gifts()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.3)
	
	inst.AnimState:SetBank("polar_throne_gifts")
	inst.AnimState:SetBuild("polar_throne_gifts")
	inst.AnimState:PlayAnimation("idle"..math.random(NUM_VARS))
	
	inst:AddTag("thronegift")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "polar_throne_gifts._snowblockrange")
	inst._snowblockrange:set(4)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	local color = 0.7 + math.random() * 0.3
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	local scale = 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	-- Make non portable unwrappable?
	
	inst:AddComponent("inspectable")
	
	--MakeHauntableLaunch(inst) TODO: Use on haunt?
	
	return inst
end

return Prefab("polar_throne", fn, assets),
	Prefab("polar_throne_gifts", gifts, assets_gifts)