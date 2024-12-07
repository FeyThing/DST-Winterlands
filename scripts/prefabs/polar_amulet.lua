local assets = {
	Asset("ANIM", "anim/torso_polar_amulet.zip"),
	Asset("ANIM", "anim/polar_amulet_items.zip"),
}

local AMULET_PARTS = {
	"left",
	"middle",
	"right",
}

local function OnEquip(inst, owner)
	if inst.fx then
		inst.fx:Remove()
	end
	
	inst.fx = SpawnPrefab("polaramulet_fx")
	inst.fx._amulet:set(inst)
	inst.fx:AttachToOwner(owner)
end

local function OnUnequip(inst, owner)
	if inst.fx then
		inst.fx:Remove()
		inst.fx = nil
	end
end

local function OnSave(inst, data)
	local parts = {}
	
	for k, v in pairs(inst.amulet_parts) do
		local part = v:value()
		table.insert(parts, part)
	end
	
	data.amulet_parts = parts
end

local function OnLoad(inst, data)
	if data and data.amulet_parts then
		inst:SetAmuletParts(data.amulet_parts)
	end
end

local function GetAmuletParts(inst, name)
	local parts = {}
	if name == nil then
		for k, v in pairs(POLARAMULET_PARTS) do
			parts[k] = {}
		end
	end
	
	for k, v in pairs(inst.amulet_parts) do
		local part = v:value()
		if name and part == name then
			table.insert(parts, part)
		elseif name == nil then
			table.insert(parts[part], part)
		end
	end
	
	return name and #parts or parts
end

local function SetAmuletParts(inst, parts, doer, build_overrides)
	for i, item in ipairs(parts) do
		local part = AMULET_PARTS[i]
		inst.amulet_parts[part]:set(item)
		
		local build = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].build
		local sym = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].symbol
		local ornament = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].ornament
		
		inst.AnimState:OverrideSymbol((ornament and "ornament_" or "tooth_")..part, build, sym or "swap_"..item)
	end
	
	inst:SetAmuletPower(doer)
end

local function SetAmuletPower(inst, doer)
	local parts = inst:GetAmuletParts()
	
	local houndstooth = #parts["houndstooth"]
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("torso_polar_amulet")
	inst.AnimState:SetBuild("torso_polar_amulet")
	inst.AnimState:PlayAnimation("idle")
	
	MakeInventoryFloatable(inst, "med", nil, 0.6)
	
	inst:AddTag("shadowlevel")
	
	inst.foleysound = "dontstarve/movement/foley/jewlery"
	
	inst.amulet_parts = {}
	for i, v in ipairs(AMULET_PARTS) do
		inst.amulet_parts[v] = net_string(inst.GUID, "polaramulet._part_"..v)
	end
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.AMULET_SHADOW_LEVEL)
	
	MakeHauntableLaunch(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.GetAmuletParts = GetAmuletParts
	inst.SetAmuletParts = SetAmuletParts
	inst.SetAmuletPower = SetAmuletPower
	
	return inst
end

--

local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("torso_polar_amulet")
	inst.AnimState:SetBuild("torso_polar_amulet")
	inst.AnimState:PlayAnimation("equip"..tostring(i))
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

local function UpdateTeeth(inst)
	local owner = inst.owner
	local amulet = inst._amulet:value()
	
	if amulet and amulet.amulet_parts then
		if inst._set_fx_parts then
			for i, fx in ipairs(inst.fx) do
				for j, v in ipairs(AMULET_PARTS) do
					local part = amulet.amulet_parts[v]
					local item = part and part:value()
					
					local build = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].build
					local sym = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].symbol
					local ornament = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].ornament
					
					if build then
						fx.AnimState:OverrideSymbol((ornament and "ornament_" or "tooth_")..v, build, sym or "swap_"..item)
					end
				end
			end
			inst._set_fx_parts = nil
		end
		
		local is_left = owner.AnimState:GetCurrentFacing() == FACING_LEFT or nil
		if is_left ~= inst._facing_left then
			inst._facing_left = is_left
			
			local item_right = amulet.amulet_parts["right"]:value()
			local build_right = POLARAMULET_PARTS[item_right] and POLARAMULET_PARTS[item_right].build
			local sym_right = POLARAMULET_PARTS[item_right] and POLARAMULET_PARTS[item_right].symbol or "swap_"..item_right
			local ornament_right = POLARAMULET_PARTS[item_right] and POLARAMULET_PARTS[item_right].ornament
			
			local item_left = amulet.amulet_parts["left"]:value()
			local build_left = POLARAMULET_PARTS[item_left] and POLARAMULET_PARTS[item_left].build
			local sym_left = POLARAMULET_PARTS[item_left] and POLARAMULET_PARTS[item_left].symbol or "swap_"..item_left
			local ornament_left = POLARAMULET_PARTS[item_left] and POLARAMULET_PARTS[item_left].ornament
			
			local override_sym = is_left and (ornament_left and "ornament_" or "tooth_") or (ornament_right and "ornament_" or "tooth_")
			for i, v in ipairs(inst.fx) do
				if i >= 4 and i <= 6 then
					v.AnimState:OverrideSymbol(override_sym.."left", is_left and build_right or build_left, is_left and sym_right or sym_left)
				end
			end
		end
	end
end

local function fx_OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end

local function fx_SpawnFxForOwner(inst, owner)
	inst.owner = owner
	inst.fx = {}
	
	for i = 1, 9 do
		local fx = CreateFxFollowFrame(i)
		
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "swap_body", nil, nil, nil, true, nil, i - 1)
		fx.components.highlightchild:SetOwner(owner)
		
		table.insert(inst.fx, fx)
	end
	inst._set_fx_parts = true
	
	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddPostUpdateFn(UpdateTeeth)
	
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	if owner ~= nil then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function toothfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	inst._amulet = net_entity(inst.GUID, "polaramulet_fx._amulet")
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		
		return inst
	end
	
	inst.persists = false
	
	inst.AttachToOwner = fx_AttachToOwner
	
	return inst
end

return Prefab("polaramulet", fn, assets),
	Prefab("polaramulet_fx", toothfn, assets)