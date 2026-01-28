local DECIDUOUSTREE_TAGS = {"birchnut"}
local DECIDUOUSTREE_NOT_TAGS = {"INLIMBO", "stump"}

local SNOWWAVE_ITEMS = {
	rocks = 		{weight = 1.5},
	flint = 		{weight = 1},
	twigs = 		{weight = 0.5},
	pinecone = 		{weight = 0.25},
	goldnugget = 	{weight = 0.25},
	nitre = 		{weight = 0.25},
	
	acorn = {
		weight = 0.75,
		testfn = function(inst)
			local x, y, z = inst.Transform:GetWorldPosition()
			
			return #TheSim:FindEntities(x, y, z, 8, DECIDUOUSTREE_TAGS, DECIDUOUSTREE_NOT_TAGS) > 0
		end,
	},
	
	polar_brazier_item_blueprint = {
		weight = 0.1,
		testfn = function(inst)
			for i, v in ipairs(AllPlayers) do
				if v.components.builder and not v.components.builder:KnowsRecipe("polar_brazier_item") and v.components.builder:CanLearn("polar_brazier_item") then
					return true
				end
			end
			
			return false
		end,
	},
}


local BLOCKER_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker", "character", "structure", "wall", "plant", "_inventoryitem"}
local BLOCKER_NOT_TAGS = {"berrythief", "INLIMBO"}

local function SnowHasSpace(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 6, nil, BLOCKER_NOT_TAGS, BLOCKER_TAGS) == 0
		and TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
end

local function MoveAround(inst)
	local pt = inst:GetPosition()
	local offset = FindWalkableOffset(pt, math.random() * TWOPI, 8, 16, false, true, SnowHasSpace)
	
	if offset then
		local x, y, z = (pt + offset):Get()
		inst.Transform:SetPosition(x, y, z)
	end
	
	return offset ~= nil
end

local function GetRespawnItems(inst)
	local items = {}
	
	for prefab, data in pairs(inst.snowwave_items) do
		if not data.testfn or data.testfn(inst) then
			items[prefab] = data.weight
		end
	end
	
	return items
end

local function SpawnSnowItem(inst)
	if inst.snowitem then
		return
	end
	
	local moved = MoveAround(inst)
	
	if moved then
		local items = inst:GetRespawnItems()
		if next(items) == nil then
			return
		end
		
		local item = weighted_random_choice(items)
		inst.snowitem = SpawnPrefab(item)
		
		if inst.snowitem then
			inst.snowitem.Transform:SetPosition(inst.Transform:GetWorldPosition())
			
			if inst.components.perishable then
				inst.components.perishable:StopPerishing()
			end
			
			inst:ListenForEvent("onpickup", inst.onsnowitempicked, inst.snowitem)
			inst:ListenForEvent("onremove", inst.onsnowitempicked, inst.snowitem)
		end
		
		return item
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
			local spawned = inst:SpawnSnowItem()
			
			if spawned then
				inst.can_spawn_snowitem = nil
			end
		end
	end
end

local function OnSnowItemPicked(inst, item, data)
	if item and item.components.perishable then
		item.components.perishable:StartPerishing()
	end
	
	inst:RemoveEventCallback("onpickup", inst.onsnowitempicked, inst.snowitem)
	inst:RemoveEventCallback("onremove", inst.onsnowitempicked, inst.snowitem)
	
	inst.snowitem = nil
end

local function OnPolarstormChanged(inst, active)
	if active then
		inst.can_spawn_snowitem = true
	elseif inst.can_spawn_snowitem then
		local spawned = inst:SpawnSnowItem()
		
		if spawned then
			inst.can_spawn_snowitem = nil
		end
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
	
	inst.GetRespawnItems = GetRespawnItems
	inst.OnSave = OnSave
	inst.OnLoadPostPass = OnLoadPostPass
	inst.SpawnSnowItem = SpawnSnowItem
	
	inst:ListenForEvent("onwenthome", MoveAround)
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	
	return inst
end

return Prefab("snowwave_itemrespawner", fn)