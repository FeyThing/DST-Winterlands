-- This skin has 2 layers to apply a fashionable borealistic tint on the crystals (colors are applied from minerhat prefab postinit).

local assets = {
	Asset("ANIM", "anim/minerhat_boreal_overlay.zip"),
}

local BOREALLIGHT_COLORS = {
	{120 / 255, 200 / 255, 255 / 255},
	{90 / 255, 220 / 255, 200 / 255},
	{160 / 255, 120 / 255, 255 / 255},
}

local BOREALLIGHT_SPEED = 0.03

local function UpdateBorealLight(inst)
	local colors = inst._borealight_colors
	inst._borealight_phase = inst._borealight_phase + BOREALLIGHT_SPEED
	
	local i1 = math.floor(inst._borealight_phase) % #colors + 1
	local i2 = i1 % #colors + 1
	local t  = inst._borealight_phase - math.floor(inst._borealight_phase)
	
	local c1 = colors[i1]
	local c2 = colors[i2]
	
	inst.AnimState:SetSymbolMultColour("boreal_crystals",
		Lerp(c1[1], c2[1], t),
		Lerp(c1[2], c2[2], t),
		Lerp(c1[3], c2[3], t),
		1
	)
end

local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	
	inst.AnimState:SetBank("minerhat_boreal_overlay")
	inst.AnimState:SetBuild("minerhat_boreal_overlay")
	inst.AnimState:PlayAnimation("hat"..i, true)
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:SetSymbolBloom("boreal_crystals")
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	
	inst._borealight_colors = BOREALLIGHT_COLORS
	inst._borealight_phase = 0
	inst._borealight_task = inst:DoPeriodicTask(0.05, UpdateBorealLight)
	
	return inst
end

local function OnRemoveEntity(inst)
	for i, v in ipairs(inst.fx) do
		v:Remove()
	end
end

local function ColourChanged(inst, r, g, b, a)
	for i, v in ipairs(inst.fx) do
		v.AnimState:SetAddColour(r, g, b, a)
	end
end

local function SpawnFxForOwner(inst, owner)
	inst.fx = {}
	
	for i = 1, 3 do
		local fx = CreateFxFollowFrame(i)
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "swap_hat", 0, 0, 0, true, nil, i - 1)
		
		fx.components.highlightchild:SetOwner(owner)
		table.insert(inst.fx, fx)
	end
	inst.components.colouraddersync:SetColourChangedFn(ColourChanged)
	inst.OnRemoveEntity = OnRemoveEntity
end

local function OnEntityReplicated(inst)
	local owner = inst.entity:GetParent()
	if owner then
		SpawnFxForOwner(inst, owner)
	end
end

local function AttachToOwner(inst, owner)
	inst.entity:SetParent(owner.entity)
	if owner.components.colouradder then
		owner.components.colouradder:AttachChild(inst)
	end
	
	if not TheNet:IsDedicated() then
		SpawnFxForOwner(inst, owner)
	end
end

local function OnInit(inst)
	local owner = inst.entity:GetParent()
	
	if owner and inst.fx == nil then
		inst:AttachToOwner(owner)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	
	inst:AddComponent("colouraddersync")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = OnEntityReplicated
		
		return inst
	end
	
	inst.AttachToOwner = AttachToOwner
	
	inst:DoTaskInTime(0, OnInit)
	
	inst.persists = false
	
	return inst
end

return Prefab("minerhat_boreal_overlay", fn, assets)