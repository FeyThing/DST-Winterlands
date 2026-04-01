function PickRandomPolarTrinket()
	return "polartrinket_"..math.random(NUM_POLARTRINKETS)
end

local assets = {
	Asset("ANIM", "anim/polartrinkets.zip"),
}

local SMALLFLOATS = {
	[1] = {0.7, 0.1},
	[2] = {0.7, 0.1},
}

local function MakeTrinket(num)
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("polartrinkets")
		inst.AnimState:SetBuild("polartrinkets")
		inst.AnimState:PlayAnimation(tostring(num))
		
		inst:AddTag("molebait")
		inst:AddTag("cattoy")
		if num <= 2 then
			inst:AddTag("snowhidden")
		end
		
		MakeInventoryFloatable(inst)
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("inventoryitem")
		
		if SMALLFLOATS[num] ~= nil then
			inst.components.floater:SetScale(SMALLFLOATS[num][1])
			inst.components.floater:SetVerticalOffset(SMALLFLOATS[num][2])
		end
		
		inst:AddComponent("tradable")
		inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.POLARTRINKETS[num] or 3
		inst.components.tradable.rocktribute = math.ceil(inst.components.tradable.goldvalue / 3)
		
		MakeHauntableLaunchAndSmash(inst)
		
		inst:AddComponent("bait")
		
		return inst
	end
	
	return Prefab("polartrinket_"..tostring(num), fn, assets, prefabs)
end

--	Special Gnome Spawner (for rare village biome), extra gnome types can spawn if 'Gnome Place Like Gnome' is up !

local VALID_GNOMES = {
	polartrinket_1 	= 3, 	-- Snuggy Gnome
	polartrinket_2 	= 2, 	-- Snuggy Gnomette
	trinket_4 		= 4, 	-- Gnome
	trinket_13 		= 3, 	-- Gnomette
	
	beret_gnome 				= 1,
	derp_gnome 					= 1,
	derp_gnomette 				= 1,
	mod_cherryforest_gnomette 	= 0.5,
	ice_gnome 					= 4,
	ice_gnomette 				= 3,
	potted_gnome 				= 0.5,
	raincoat_gnomette 			= 1,
}

local function OnInit(inst)
	local gnominees = {}
	for k, v in pairs(VALID_GNOMES) do
		if PrefabExists(k) then
			gnominees[k] = v
		end
	end
	
	local gnome = SpawnPrefab(weighted_random_choice(gnominees))
	if gnome then
		gnome.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	
	inst:Remove()
end

local function gnomespawner()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:DoTaskInTime(0.1, OnInit)
	
	inst.persists = false
	
	return inst
end

local ret = {}
for k = 1, NUM_POLARTRINKETS do
	table.insert(ret, MakeTrinket(k))
end

table.insert(ret, Prefab("polargnomespawner", gnomespawner))

return unpack(ret)