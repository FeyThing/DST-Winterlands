local prefabs = {
	"farm_plant_icelettuce",
}

local function HasSnowySpace(pt)
	return TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
		and TheWorld.Map:IsDeployPointClear(pt, nil, DEPLOYSPACING_RADIUS[DEPLOYSPACING.MEDIUM])
end

local function SpawnLettuce(inst, pt)
	pt = pt or inst:GetPosition()
	
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, GetRandomMinMax(0, 2), 8, false, true, HasSnowySpace)
	if offset then
		inst.lettuce = SpawnPrefab("farm_plant_icelettuce")
		inst.lettuce.Transform:SetPosition((pt + offset):Get())
		
		inst:ListenForEvent("onremove", inst._onremovelettuce, inst.lettuce)
		
		return inst.lettuce
	end
end

local function OnSave(inst, data)
	local ents = {}
	
	if inst.lettuce then
		data.lettuce_id = inst.lettuce.GUID
		table.insert(ents, data.lettuce_id)
	end
	
	return ents
end

local function OnLoadPostPass(inst, newents, savedata)
	if savedata then
		if savedata.lettuce_id and newents[savedata.lettuce_id] then
			inst.lettuce = newents[savedata.lettuce_id].entity
			
			inst:ListenForEvent("onremove", inst._onremovelettuce, inst.lettuce)
		end
	end
end

local function OnPlowArea_Pre(inst, data)
	if inst.lettuce == nil and data and data.pt and inst:GetDistanceSqToPoint(data.pt:Get()) <= TUNING.ICELETTUCE_REGROWTH_RANGE_SQ
		and data.doer and data.doer:HasTag("character") and math.random() <= TUNING.ICELETTUCE_REGROWTH_CHANCE then
		
		inst:SpawnLettuce(data.pt)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("icelettucespawner")
	inst:AddTag("CLASSIFIED")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SpawnLettuce = SpawnLettuce
	
	inst.OnPlowArea_Pre = function(src, data) OnPlowArea_Pre(inst, data) end
	inst._onremovelettuce = function(lettuce) inst.lettuce = nil end
	
	inst:ListenForEvent("ms_plowarea_pre", inst.OnPlowArea_Pre, TheWorld)
	
	return inst
end

return Prefab("icelettuce_spawner", fn, nil, prefabs)