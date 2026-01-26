-- There's a possibility Klei adds their own so, watch out for ocean content updates ?

local assets = {
	Asset("ANIM", "anim/boat_ice.zip"),
	Asset("ANIM", "anim/boat_ice_item.zip"),
}

local prefabs = {
	"boat_ice",
}

local sounds = {
	place = "dontstarve_DLC001/common/iceboulder_hit",
	creak = "dontstarve_DLC001/common/iceboulder_hit",
	damage = "dontstarve_DLC001/common/iceboulder_hit",
	sink = "dontstarve_DLC001/common/iceboulder_hit",
	hit = "dontstarve_DLC001/common/iceboulder_hit",
	thunk = "dontstarve_DLC001/common/iceboulder_hit",
	movement = "dontstarve_DLC001/common/iceboulder_hit",
}

--

local function OnDeploy(inst, pt, deployer)
	local boat = SpawnPrefab(inst.deploy_product, inst.linked_skinname, inst.skin_id)
	if not boat then
		return
	end
	
	local boat_hull = boat.components.hull
	
	boat.Physics:SetCollides(false)
	boat.Physics:Teleport(pt.x, 0, pt.z)
	boat.Physics:SetCollides(true)
	
	boat.sg:GoToState("place")
	
	--[[if boat_hull then
		boat_hull:OnDeployed()
	end]]
	
	inst:Remove()
	
	return boat
end

function CLIENT_CanDeployBoat(inst, pt, mouseover, deployer, rotation)
	local inventory = deployer and deployer.replica.inventory
	
	if inventory and inventory:IsFloaterHeld() then
		local hop_range = TUNING.FLOATING_HOP_DISTANCE_PLATFORM - 0.01
		local max_range = inst._boat_radius + hop_range
		local min_range = inst._boat_radius + 0.5
		local dsq = deployer:GetDistanceSqToPoint(pt)
		
		if dsq > max_range * max_range or dsq < min_range * min_range then
			return false
		end
	end
	
	return TheWorld.Map:CanDeployBoatAtPointInWater(pt, inst, mouseover, {
		boat_radius = inst._boat_radius,
		boat_extra_spacing = 0.2,
		min_distance_from_land = 0.2,
	})
end

local function fn()
	local inst = CreateEntity()
	
	inst._custom_candeploy_fn = CLIENT_CanDeployBoat
	inst._boat_radius = TUNING.OCEAN_ICE_RADIUS
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("boat_ice_item")
	inst.AnimState:SetBuild("boat_ice_item")
	inst.AnimState:PlayAnimation("IDLE")
	
	inst:AddTag("boatbuilder")
	inst:AddTag("deploykititem")
	inst:AddTag("frozen")
	inst:AddTag("icebox_valid")
	inst:AddTag("usedeployspacingasoffset")
	inst:AddTag("show_spoilage")
	
	MakeInventoryPhysics(inst)
	
	MakeInventoryFloatable(inst, "med", 0.11)
	
	inst.deploy_product = "boat_ice"
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LARGE)
	inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM)
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.PLACER_DEFAULT)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW + TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	inst:AddComponent("stackable")
	
	MakeHauntableLaunch(inst)
	
	return inst
end

local function ocean_fn()
	local inst = fn()
	
	inst:SetPrefabName("boat_ice_item")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.perishable then
		inst.components.perishable:StopPerishing()
	end
	
	if inst.components.stackable then
		inst.components.stackable:SetStackSize(math.random(2, 4))
	end
	
	return inst
end

--

local function _set_placer_layer(inst)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(2)
	inst.AnimState:SetFinalOffset(7)
end

local function _check_placer_offset(inst, boat_radius)
	local inventory = ThePlayer and ThePlayer.replica.inventory
	
	if inventory and inventory:IsFloaterHeld() then
		local hop_range = TUNING.FLOATING_HOP_DISTANCE_PLATFORM - 0.01
		local offset_range = hop_range - 0.01
		
		inst.components.placer.offset = math.min(inst.components.placer.offset, boat_radius + offset_range)
	end
end

local function placer_postinit(inst)
	_set_placer_layer(inst)
	_check_placer_offset(inst, TUNING.OCEAN_ICE_RADIUS)
	ControllerPlacer_Boat_SpotFinder(inst, TUNING.OCEAN_ICE_RADIUS)
end

return Prefab("boat_ice_item", fn, assets, prefabs),
	Prefab("boat_ice_item_worldgen", ocean_fn, assets),
	MakePlacer("boat_ice_item_placer", "boat_ice", "boat_ice", "idle1", true, false, false, nil, nil, nil, placer_postinit, 4.5)