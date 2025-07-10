local PIECES = {
	{name = "emperor_penguin_fruity", gymweight = 4},
	{name = "emperor_penguin_juggle", gymweight = 4},
	{name = "emperor_penguin_magestic", gymweight = 4},
	{name = "emperor_penguin_spin", gymweight = 4},
}

local MATERIALS = {
	{name = "marble", 		prefab = "marble", 		inv_suffix = ""},
	{name = "stone", 		prefab = "cutstone", 	inv_suffix = "_stone"},
	{name = "moonglass", 	prefab = "moonglass", 	inv_suffix = "_moonglass"},
}

local PHYSICS_RADIUS = 0.45

local function GetBuildName(pieceid, materialid)
	local build = "swap_chesspiece_"..PIECES[pieceid].name
	
	if materialid then
		build = build.."_"..MATERIALS[materialid].name
	end
	
	return build
end

local function SetMaterial(inst, materialid)
	inst.materialid = materialid
	local build = GetBuildName(inst.pieceid, materialid)
	inst.AnimState:SetBuild(build)
	
	inst.components.lootdropper:SetLoot({MATERIALS[materialid].prefab})
	
	inst.components.symbolswapdata:SetData(build, "swap_body")
	
	local inv_image_suffix = (materialid ~= nil and MATERIALS[materialid].inv_suffix) or ""
	inst.components.inventoryitem.imagename = "chesspiece_"..PIECES[inst.pieceid].name..inv_image_suffix
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", GetBuildName(inst.pieceid, inst.materialid), "swap_body")
end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function onworkfinished(inst)
	inst.components.lootdropper:DropLoot()
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")
	inst:Remove()
end

local function onsave(inst, data)
	data.materialid = inst.materialid
end

local function onload(inst, data)
	if data ~= nil then
		SetMaterial(inst, data.materialid or 1)
	end
end

local function makepiece(pieceid, materialid)
	local build = GetBuildName(pieceid, materialid)
	
	local assets = {
		Asset("ANIM", "anim/chesspiece.zip"),
	}
	
	local prefabs = {
		"collapse_small",
		"underwater_salvageable",
		"splash_green",
	}
	
	if materialid then
		table.insert(prefabs, MATERIALS[materialid].prefab)
		table.insert(assets, Asset("ANIM", "anim/"..build..".zip"))
	else
		for m = 1, #MATERIALS do
			local p = "chesspiece_"..PIECES[pieceid].name.."_"..MATERIALS[m].name
			table.insert(prefabs, p)
		end
	end
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		
		MakeHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
		inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)
		
		inst.AnimState:SetBank("chesspiece")
		inst.AnimState:SetBuild("swap_chesspiece_"..PIECES[pieceid].name.."_marble")
		inst.AnimState:PlayAnimation("idle")
		
		inst:AddTag("heavy")
		inst.gymweight = PIECES[pieceid].gymweight or 2
		
		inst:SetPrefabName("chesspiece_"..PIECES[pieceid].name)
		
		if PIECES[pieceid].common_postinit ~= nil then
			PIECES[pieceid].common_postinit(inst)
		end
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("heavyobstaclephysics")
		inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("lootdropper")
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = POLAR_ATLAS
		inst.components.inventoryitem.cangoincontainer = false
		inst.components.inventoryitem:SetSinks(true)
		
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.BODY
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)
		inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(1)
		inst.components.workable:SetOnFinishCallback(onworkfinished)
		
		inst:AddComponent("submersible")
		inst:AddComponent("symbolswapdata")
		inst.components.symbolswapdata:SetData(build, "swap_body")
		
		inst:AddComponent("hauntable")
		inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
		
		inst.OnLoad = onload
		inst.OnSave = onsave
		
		inst.pieceid = pieceid
		if materialid then
			SetMaterial(inst, materialid)
		end
		
		if PIECES[pieceid].master_postinit ~= nil then
			PIECES[pieceid].master_postinit(inst)
		end
		
		return inst
	end
	
	local prefabname = materialid and ("chesspiece_"..PIECES[pieceid].name.."_"..MATERIALS[materialid].name) or ("chesspiece_"..PIECES[pieceid].name)
	return Prefab(prefabname, fn, assets, prefabs)
end

--------------------------------------------------------------------------

local function builderonbuilt(inst, builder)
	local prototyper = builder.components.builder.current_prototyper
	if prototyper ~= nil and prototyper.CreateItem ~= nil then
		prototyper:CreateItem("chesspiece_"..PIECES[inst.pieceid].name)
	else
		local piece = SpawnPrefab("chesspiece_"..PIECES[inst.pieceid].name)
		piece.Transform:SetPosition(builder.Transform:GetWorldPosition())
	end
	
	inst:Remove()
end

local function makebuilder(pieceid)
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		
		inst:AddTag("CLASSIFIED")
		
		inst.persists = false
		
		inst:DoTaskInTime(0, inst.Remove)
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst.pieceid = pieceid
		inst.OnBuiltFn = builderonbuilt
		
		return inst
	end
	
	return Prefab("chesspiece_"..PIECES[pieceid].name.."_builder", fn, nil, {"chesspiece_"..PIECES[pieceid].name})
end

--------------------------------------------------------------------------

local chesspieces = {}
for p = 1, #PIECES do
	table.insert(chesspieces, makepiece(p))
	table.insert(chesspieces, makebuilder(p))
	for m = 1,#MATERIALS do
		table.insert(chesspieces, makepiece(p, m))
	end
end

return unpack(chesspieces)