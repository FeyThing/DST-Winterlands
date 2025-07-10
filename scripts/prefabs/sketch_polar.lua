local assets = {
	Asset("ANIM", "anim/blueprint_sketch.zip"),
}

local SKETCHES = {
	{item = "chesspiece_emperor_penguin_fruity", recipe = "chesspiece_emperor_penguin_fruity_builder", image = "chesspiece_emperor_penguin_fruity_sketch"},
	{item = "chesspiece_emperor_penguin_juggle", recipe = "chesspiece_emperor_penguin_juggle_builder", image = "chesspiece_emperor_penguin_juggle_sketch"},
	{item = "chesspiece_emperor_penguin_magestic", recipe = "chesspiece_emperor_penguin_magestic_builder", image = "chesspiece_emperor_penguin_magestic_sketch"},
	{item = "chesspiece_emperor_penguin_spin", recipe = "chesspiece_emperor_penguin_spin_builder", image = "chesspiece_emperor_penguin_spin_sketch"},
}

local function GetSketchID(item)
	for i, v in ipairs(SKETCHES) do
		if v.item == item then
			return i
		end
	end
end

local function GetSketchIDFromName(name)
	for i, v in ipairs(SKETCHES) do
		if name == subfmt(STRINGS.NAMES.SKETCH, {item = STRINGS.NAMES[string.upper(SKETCHES[i].recipe)]}) then
			return i
		end
	end
end

local function onload(inst, data)
	if not data then
		inst.sketchid = GetSketchIDFromName(inst.components.named.name) or 1
	else
		if data.sketchid then
			inst.sketchid = data.sketchid or 1
		elseif data.sketchitem then
			inst.sketchid = GetSketchID(data.sketchitem) or 1
		end
	end
	
	inst.components.named:SetName(subfmt(STRINGS.NAMES.SKETCH, {item = STRINGS.NAMES[string.upper(SKETCHES[inst.sketchid].recipe)]}))
	if SKETCHES[inst.sketchid].image ~= nil then
		inst.components.inventoryitem.atlasname = POLAR_ATLAS
		inst.components.inventoryitem.imagename = SKETCHES[inst.sketchid].image
	else
		inst.components.inventoryitem.imagename = "sketch"
	end
end

local function onsave(inst, data)
	data.sketchitem = SKETCHES[inst.sketchid].item
end

local function GetRecipeName(inst)
	return SKETCHES[inst.sketchid].recipe
end

local function GetSpecificSketchPrefab(inst)
	return SKETCHES[inst.sketchid].item.."_sketch"
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("blueprint_sketch")
	inst.AnimState:SetBuild("blueprint_sketch")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("_named")
	inst:AddTag("sketch")
	
	inst:SetPrefabName("sketch_polar")
	
	MakeInventoryFloatable(inst, "med", nil, 0.75)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("erasablepaper")
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "sketch"
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("named")
	
	MakeHauntableLaunch(inst)
	
	inst.OnLoad = onload
	inst.OnSave = onsave
	
	inst.sketchid = 1
	
	inst.GetRecipeName = GetRecipeName
	inst.GetSpecificSketchPrefab = GetSpecificSketchPrefab
	
	return inst
end

local function MakeSketchPrefab(sketchid)
	return function()
		local inst = fn()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.sketchid = sketchid
		
		inst.components.named:SetName(subfmt(STRINGS.NAMES.SKETCH, {item = STRINGS.NAMES[string.upper(SKETCHES[sketchid].recipe)]}))
		
		if SKETCHES[sketchid].image ~= nil then
			inst.components.inventoryitem.atlasname = POLAR_ATLAS
			inst.components.inventoryitem.imagename = SKETCHES[sketchid].image
		else
			inst.components.inventoryitem.imagename = "sketch"
		end
		
		return inst
	end
end

local ret = {}
table.insert(ret, Prefab("sketch_polar", fn, assets))
for i, v in ipairs(SKETCHES) do
	table.insert(ret, Prefab(v.item.."_sketch", MakeSketchPrefab(i)))
end

return unpack(ret)