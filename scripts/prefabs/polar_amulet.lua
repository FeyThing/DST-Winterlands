local assets = {
	Asset("ANIM", "anim/torso_polar_amulet.zip"),
	Asset("ANIM", "anim/polar_amulet_items.zip"),
}

local AMULET_PARTS = {
	"left",
	"middle",
	"right",
}

local function OnPolarTiles(inst, owner, on_polar, force_disable)
	local tile, tileinfo = owner:GetCurrentTileType()
	local in_snow = tile and (tile == WORLD_TILES.POLAR_SNOW or (tileinfo and not tileinfo.nogroundoverlays and TheWorld.state.snowlevel and TheWorld.state.snowlevel > 0.15))
	
	on_polar = not force_disable and (TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(owner) or in_snow) or false
	
	if owner.components.locomotor then
		if on_polar then
			local polarwargstooth = inst:GetAmuletParts("polarwargstooth")
			if polarwargstooth > 0 then
				owner.components.locomotor:SetExternalSpeedMultiplier(owner, "polaramulet", 1 + (polarwargstooth * TUNING.POLARAMULET.POLARWARGSTOOTH.SNOWMOVEMENT_SPEED))
			end
		else
			owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "polaramulet")
		end
	end
end

local function OnEquip(inst, owner)
	local parts = inst:GetAmuletParts()
	
	local gnarwail_horn = #parts["gnarwail_horn"]
	if gnarwail_horn > 0 and owner.components.expertsailor == nil then
		owner:AddComponent("expertsailor")
	end
	
	local houndstooth = #parts["houndstooth"]
	if houndstooth > 0 and owner.components.combat then
		owner.components.combat.externaldamagemultipliers:SetModifier(inst, 1 + (houndstooth * TUNING.POLARAMULET.HOUNDSTOOTH.DAMAGE_MULT))
	end
	
	local polarwargstooth = #parts["polarwargstooth"]
	if polarwargstooth > 0 and owner.components.areaaware then
		inst._onpolartiles = function(owner, data, amulet, force_disable)
			OnPolarTiles(inst or amulet, owner, data, force_disable)
		end
		
		inst.onpolarstormchanged = function(src, data)
			if data and data.stormtype == STORM_TYPES.POLARSTORM and inst._onpolartiles then
				inst._onpolartiles(owner, nil, inst)
			end
		end
		
		inst._onpolartiles(owner, nil, inst)
		--inst:ListenForEvent("on_POLAR_ICE_tile", inst._onpolartiles, owner)
		inst:ListenForEvent("on_POLAR_SNOW_tile", inst._onpolartiles, owner)
		inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	end
	
	if inst.components.fueled then
		inst.components.fueled:StartConsuming()
	end
	
	--
	
	if inst.fx then
		inst.fx:Remove()
	end
	
	inst.fx = SpawnPrefab("polaramulet_fx")
	inst.fx._amulet:set(inst)
	inst.fx:AttachToOwner(owner)
end

local function OnUnequip(inst, owner)
	if owner.components.combat then
		owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
	end
	
	if inst._onpolartiles then
		--inst:RemoveEventCallback("on_POLAR_ICE_tile",  inst._onpolartiles, owner)
		inst:RemoveEventCallback("on_POLAR_SNOW_tile", inst._onpolartiles, owner)
		inst:RemoveEventCallback("ms_stormchanged", inst.onpolarstormchanged, owner)
		inst._onpolartiles(owner, nil, inst, true)
		inst._onpolartiles = nil
		inst.onpolarstormchanged = nil
	end
	
	if inst.components.fueled then
		inst.components.fueled:StopConsuming()
	end
	
	--
	
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
	
	if inst.components.fueled then
		data.amulet_fueled = inst.components.fueled:GetPercent()
	elseif inst.components.perishable then
		data.amulet_perishable = inst.components.perishable:GetPercent()
	end
	
	data.amulet_parts = parts
end

local function OnLoad(inst, data)
	if data then
		if data.amulet_parts then
			inst:SetAmuletParts(data.amulet_parts, {fueled = data.amulet_fueled, perishable = data.amulet_perishable})
		end
	end
end

local function GetAmuletParts(inst, name)
	local parts = {ornament = {}}
	if name == nil then
		for k, v in pairs(POLARAMULET_PARTS) do
			parts[k] = {}
		end
	end
	
	for k, v in pairs(inst.amulet_parts) do
		local part = v:value()
		local is_ornament = POLARAMULET_PARTS[part].ornament
		
		if name and (part == name or (name == "ornament" and is_ornament)) then
			table.insert(parts, part)
		elseif name == nil then
			table.insert(parts[is_ornament and "ornament" or part], part)
		end
	end
	
	return name and #parts or parts
end

local function SetAmuletParts(inst, parts, data)
	data = data or {}
	
	for i, item in ipairs(parts) do
		local part = AMULET_PARTS[i]
		inst.amulet_parts[part]:set(item)
		
		local build = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].build
		local sym = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].symbol
		local ornament = POLARAMULET_PARTS[item] and POLARAMULET_PARTS[item].ornament
		
		inst.AnimState:OverrideSymbol((ornament and "ornament_" or "tooth_")..part, build, sym or "swap_"..item)
	end
	
	inst:SetAmuletPower(data)
end

local function SetAmuletPower(inst, data)
	local parts = inst:GetAmuletParts()
	local add_fueled = true
	
	local houndstooth = #parts["houndstooth"]
	if houndstooth > 0 then
		if inst.components.equippable then
			inst.components.equippable.walkspeedmult = 1 + (houndstooth * TUNING.POLARAMULET.HOUNDSTOOTH.MOVEMENT_SPEED)
		end
	end
	
	local polarwargstooth = #parts["polarwargstooth"]
	if polarwargstooth > 0 then
		add_fueled = false
		
		inst:AddTag("polarimmunity")
		inst:AddTag("polarsnowimmunity")
		inst:AddTag("show_spoilage")
		
		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.POLARAMULET_PERISHATIME + (polarwargstooth * TUNING.POLARAMULET.POLARWARGSTOOTH.PERISHTIME))
		inst.components.perishable:SetOnPerishFn(inst.Remove)
		inst.components.perishable:StartPerishing()
		
		if data.perishable then
			inst.components.perishable:SetPercent(data.perishable)
		end
	end
	
	local walrus_tusk = #parts["walrus_tusk"]
	if walrus_tusk > 0 then
		if inst.components.equippable then
			inst.components.equippable.dapperness = walrus_tusk * TUNING.POLARAMULET.WALRUS_TUSK.DAPERNESS
		end
		if inst.components.insulator == nil then
			inst:AddComponent("insulator")
		end
		inst.components.insulator:SetInsulation(walrus_tusk * TUNING.POLARAMULET.WALRUS_TUSK.INSULATION)
	end
	
	local ornament = #parts["ornament"]
	if ornament >= #AMULET_PARTS then
		add_fueled = false
	end
	
	if add_fueled then
		if inst.components.fueled == nil then
			inst:AddComponent("fueled")
			inst.components.fueled.fueltype = FUELTYPE.MAGIC
			inst.components.fueled:InitializeFuelLevel(TUNING.POLARAMULET_PERISHATIME)
			inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
			inst.components.fueled:SetDepletedFn(inst.Remove)
		end
		if data.fueled then
			inst.components.fueled:SetPercent(data.fueled)
		end
	end
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