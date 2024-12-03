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

local ret = {}
for k = 1, NUM_POLARTRINKETS do
	table.insert(ret, MakeTrinket(k))
end

return unpack(ret)