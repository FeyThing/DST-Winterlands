local SNOWWAVE_ITEMS = {
	rocks = 1.5,
	flint = 1,
	twigs = 0.5,
	pinecone = 0.25,
	goldnugget = 0.25,
	nitre = 0.25,
}

local BLOCKER_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker", "character", "structure", "wall", "plant", "_inventoryitem"}

local function SnowHasSpace(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 6, nil, nil, BLOCKER_TAGS) == 0
		and TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
end

local function SpawnSnowItem(inst)
	if inst.snowitem then
		return
	end
	
	local pt = inst:GetPosition()
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, 6, 16, false, true, SnowHasSpace)
	
	if offset then
		local items = deepcopy(inst.snowwave_items)
		for i, v in ipairs(AllPlayers) do
			if v.components.builder and not v.components.builder:KnowsRecipe("polar_brazier_item") and v.components.builder:CanLearn("polar_brazier_item") then
				items["polar_brazier_item_blueprint"] = TUNING.POLAR_BRAZIER_BLUEPRINT_CHANCE
			end
		end
		
		local x, y, z = (pt + offset):Get()
		local item = weighted_random_choice(items)
		inst.snowitem = SpawnPrefab(item)
		inst.snowitem.Transform:SetPosition(x, y, z)
		
		inst.Transform:SetPosition(x, y, z)
		
		inst:ListenForEvent("onpickup", inst.onsnowitempicked, inst.snowitem)
		inst:ListenForEvent("onremove", inst.onsnowitempicked, inst.snowitem)
	end
end

local function OnSave(inst, data)
	local ents = {}
	
	data.canspawnsnowitem = inst.can_spawn_snowitem
	if inst.snowitem then
		data.snowitem_id = inst.snowitem.GUID
		table.insert(ents, data.snowitem_id)
	end
	
	return ents
end

local function OnLoadPostPass(inst, newents, savedata)
	if savedata then
		if savedata.snowitem_id and newents[savedata.snowitem_id] then
			inst.snowitem = newents[savedata.snowitem_id].entity
			
			if inst.snowitem and inst.snowitem:IsValid() then
				inst:ListenForEvent("onpickup", inst.onsnowitempicked, inst.snowitem)
				inst:ListenForEvent("onremove", inst.onsnowitempicked, inst.snowitem)
			end
		elseif savedata.canspawnsnowitem then
			inst:SpawnSnowItem()
		end
	end
end

local function OnSnowItemPicked(inst, item, data)
	inst:RemoveEventCallback("onpickup", inst.onsnowitempicked, inst.snowitem)
	inst:RemoveEventCallback("onremove", inst.onsnowitempicked, inst.snowitem)
	
	inst.snowitem = nil
end

local function OnPolarstormChanged(inst, active)
	if active then
		inst.can_spawn_snowitem = true
	elseif inst.can_spawn_snowitem then
		inst:SpawnSnowItem()
		inst.can_spawn_snowitem = nil
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("snowitemrespawner")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.snowwave_items = SNOWWAVE_ITEMS
	
	inst.onsnowitempicked = function(item, data)
		OnSnowItemPicked(inst, item, data)
	end
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SpawnSnowItem = SpawnSnowItem
	
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	
	return inst
end

return Prefab("snowwave_itemrespawner", fn)