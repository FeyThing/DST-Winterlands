local assets = {
	Asset("ANIM", "anim/krampus_ugly_sweater.zip"),
}

local function CreateFxFollowFrame(i, sym)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("krampus_ugly_sweater")
	inst.AnimState:SetBuild("krampus_ugly_sweater")
	inst.AnimState:PlayAnimation(sym..i)
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	return inst
end

local function OnSweaterId(inst)
	if inst.fx ~= nil then
		local id = inst.sweater_id:value() or 1
		local sweater_data = KRAMPUS_UGLY_SWEATERS[id]
		
		local r, g, b, a, hue
		
		if sweater_data.colormult then
			r, g, b, a = unpack(sweater_data.colormult)
		end
		if sweater_data.hue then
			hue = sweater_data.hue
		end
		
		for i, v in ipairs(inst.fx) do
			if r then
				v.AnimState:SetMultColour(r, g, b, a)
				v.AnimState:SetMultColour(r, g, b, a)
			end
			if hue then
				v.AnimState:SetHue(hue)
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
	
	local syms = {"neck", "torso"}
	local x, y, z = 0, 0, 0
	
	for i, sym in ipairs(syms) do
		y = sym == "neck" and 5 or 0
		for j = 1, 4 do
			local fx = CreateFxFollowFrame(j, sym)
			
			fx.entity:SetParent(owner.entity)
			fx.Follower:FollowSymbol(owner.GUID, "krampus_"..sym, x, y, z, true, nil, j - 1)
			fx.components.highlightchild:SetOwner(owner)
			table.insert(inst.fx, fx)
		end
	end
	
	inst.OnRemoveEntity = fx_OnRemoveEntity
end

local function fx_OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	if owner then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fx_AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	
	owner.AnimState:HideSymbol("krampus_furpiece")
	owner.AnimState:OverrideSymbol("krampus_neck", "krampus_ugly_sweater", "krampus_neck") -- So that fur doesn't goes over the sweater
	owner.AnimState:OverrideSymbol("krampus_torso", "krampus_ugly_sweater", "krampus_torso")
	
	if not TheNet:IsDedicated() then
		fx_SpawnFxForOwner(inst, owner)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	inst.sweater_id = net_tinybyte(inst.GUID, "krampus_ugly_sweater.sweater_id", "sweater_id_dirty")
	
	if not TheNet:IsDedicated() then
		inst:ListenForEvent("sweater_id_dirty", OnSweaterId)
	end
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = fx_OnEntityReplicated
		
		return inst
	end
	
	inst.persists = false
	
	inst.AttachToOwner = fx_AttachToOwner
	
	return inst
end

return Prefab("krampus_ugly_sweater", fn, assets)