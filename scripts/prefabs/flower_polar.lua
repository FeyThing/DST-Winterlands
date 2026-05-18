local assets = {
	Asset("ANIM", "anim/flowers_polar.zip"),
	Asset("ANIM", "anim/swap_flower_polar.zip"),
}

local assets_item = {
	Asset("ANIM", "anim/flower_petals_polar.zip"),
	Asset("ANIM", "anim/meat_rack_food_polar.zip"),
}

local names = {"f1","f2","f3","f4","f5","f6","f7","f8"}

local function OnLoad_PostPopulating(inst)
	local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(inst.Transform:GetWorldPosition())
	
	if TheWorld.components.polarsnow_manager and TheWorld.components.polarsnow_manager:IsOriginalSnowTile(tx, ty) then
		TheWorld.num_polarflowers = (TheWorld.num_polarflowers or 0) + 1
	end
end

local function OnSave(inst, data)
	data.anim = inst.animname
	data.hue = inst.hue
	data.scale = inst.scale
end

local function OnLoad(inst, data)
	if data then
		if data.anim then
			inst.animname = data.anim
			inst.AnimState:PlayAnimation(inst.animname)
		end
		if data.hue then
			inst.hue = data.hue
			inst.AnimState:SetHue(inst.hue)
		end
		if data.scale then
			inst.scale = data.scale
			inst.AnimState:SetScale(inst.scale, 1.2)
		end
	end
	
	inst:DoTaskInTime(1, OnLoad_PostPopulating)
end

local function OnPickedFn(inst, picker)
	if picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end
end

local function OnRemoved(inst)
	--Crocus only regrow outside of the Winterlands (manually placed Tundra tiles), inside, we wait for the next melt-over bloom
	local tx, ty = TheWorld.Map:GetTileCoordsAtPoint(inst.Transform:GetWorldPosition())
	local regrow = not (TheWorld.components.polarsnow_manager and TheWorld.components.polarsnow_manager:IsOriginalSnowTile(tx, ty))
	
	if not regrow then
		TheWorld.num_polarflowers = math.max(0, (TheWorld.num_polarflowers or 0) - 1)
	end
	
	if regrow and inst.persists and not inst:HasTag("fire") then
		TheWorld:PushEvent("ms_growpolarflower_at", {pt = inst:GetPosition(), overtime = true})
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("flowers_polar")
	inst.AnimState:SetBuild("flowers_polar")
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("flower")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.animname = names[math.random(#names)]
	inst.AnimState:PlayAnimation(inst.animname)
	
	inst:AddComponent("colourtweener")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("petals_polar")
	inst.components.pickable.onpickedfn = OnPickedFn
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.quickpick = true
	inst.components.pickable.wildfirestarter = true
	
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	
	MakeHauntableIgnite(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("onremove", OnRemoved)
	
	inst.hue = GetRandomMinMax(0.9, 1.1)
	inst.AnimState:SetHue(inst.hue)
	
	inst.scale = math.random() > 0.5 and 1.2 or -1.2
	inst.AnimState:SetScale(inst.scale, 1.2)
	
	return inst
end

local function item()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("flower_petals_polar")
	inst.AnimState:SetBuild("flower_petals_polar")
	inst.AnimState:PlayAnimation("anim")
	
	inst:AddTag("cattoy")
	inst:AddTag("dryable")
	inst:AddTag("vasedecoration")
	
	inst.pickupsound = "vegetation_grassy"
	
	MakeInventoryFloatable(inst, "med", nil, 0.8)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("colourtweener")
	
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("petals_polar_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst.components.dryable:SetBuildFile("meat_rack_food_polar")
	inst.components.dryable:SetDriedBuildFile("meat_rack_food_polar")
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.TINY_FUEL
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -TUNING.HEALING_MEDSMALL
	inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.VEGGIE
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
	inst:AddComponent("snowmandecor")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("upgrader")
	inst.components.upgrader.upgradetype = UPGRADETYPES.GRAVESTONE
	
	inst:AddComponent("vasedecoration")
	
	MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
	MakeSmallPropagator(inst)
	
	MakeHauntableLaunchAndIgnite(inst)
	
	return inst
end

return Prefab("flower_polar", fn, assets),
	Prefab("petals_polar", item, assets_item)