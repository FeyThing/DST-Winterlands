local assets = {
	Asset("ANIM", "anim/polar_flea_egg_sac.zip"),
}

local function SpewFlea(inst)
	inst.num_fleas = inst.num_fleas - 1
	
	if inst.num_fleas > 0 then
		local pt = inst:GetPosition()
		pt.y = pt.y + 1
		
		local baby = SpawnPrefab("polarflea")
		baby.Transform:SetPosition(pt:Get())
		baby.Transform:SetRotation(math.random() * 360)
		baby.Transform:SetScale(TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE, TUNING.POLARFLEA_BABY_SCALE)
		baby.AnimState:OverrideSymbol("shell", "polar_flea", "shell_mini")
		baby.babyflea = true
		
		baby:PushEvent("fleahostkick", {host = inst, pt = pt})
		inst:DoTaskInTime(math.random() * 0.4, SpewFlea)
	else
		ErodeAway(inst)
	end
end

local function OnPickUp(inst)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
end

local function OnDeploy(inst, pt)
	local sack = (inst.components.stackable and inst.components.stackable:Get()) or inst
	sack.num_fleas = TUNING.POLARFLEAEGGSACK_NUM_FLEAS
	
	local owner = sack.components.inventoryitem:GetGrandOwner()
	if owner and owner.components.inventory then
		owner.components.inventory:DropItem(sack)
	end
	sack.AnimState:PlayAnimation("planted", true)
	sack.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
	sack.Transform:SetPosition(pt:Get())
	
	sack.components.inventoryitem.canbepickedup = false
	sack.persists = false
	
	sack:DoTaskInTime(2 + math.random() * 2, SpewFlea)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polar_flea_egg_sac")
	inst.AnimState:SetBuild("polar_flea_egg_sac")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.6, 0.85})
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
	   return inst
	end
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.GENERIC
	inst.components.edible.healthvalue = TUNING.HEALING_LARGE
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.sanityvalue = -TUNING.SANITY_MED
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnPickupFn(OnPickUp)
	
	inst:AddComponent("stackable")
	
	inst:AddComponent("tradable")
	
	inst:AddComponent("upgrader")
	inst.components.upgrader.upgradetype = UPGRADETYPES.POLARFLEA_SACK
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("polarfleaeggsack", fn, assets),
	MakePlacer("polarfleaeggsack_placer", "polar_flea_egg_sac", "polar_flea_egg_sac", "placer")