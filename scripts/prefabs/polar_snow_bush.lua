-- This is a snow overlay that's added atop the My-Wee-Glacier skin, for extra sneak-i-ness in winter.

local assets = {
	Asset("ANIM", "anim/polar_snow_bush.zip"),
}

local function UpdateSnow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local isinpolar = IsInPolarAtPoint(x, y, z)
	local issnowcovered = TheWorld.state.issnowcovered
	
	if issnowcovered or isinpolar then
		inst.AnimState:Show("snow")
	else
		inst.AnimState:Hide("snow")
	end
	
	if not inst.updatesnowanim then
		return
	end
	
	local pct = TheWorld.state.seasonprogress
	local stage = "tall"
	
	if TheWorld.state.iswinter or isinpolar then
		stage = "tall"
	elseif TheWorld.state.isspring then
		stage = (pct < inst.threshold1 and "tall")
			or (pct < inst.threshold2 and "medium")
			or "short"
	elseif TheWorld.state.issummer then
		stage = "short"
	elseif TheWorld.state.isautumn then
		stage = (pct < inst.threshold2 and "short")
			or (pct < inst.threshold3 and "medium")
			or "tall"
	end
	
	local anim = stage == "tall" and "idle"
		or stage == "medium" and "med"
		or "low"
		
	inst.AnimState:PlayAnimation(anim..5, true)
end

local function CreateFxFollowFrame(i)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()
	
	inst:AddTag("FX")
	inst:AddTag("SnowCovered")
	
	inst.AnimState:SetBank("polar_snow_bush")
	inst.AnimState:SetBuild("snow")
	inst.AnimState:PlayAnimation("idle"..i, true)
	inst.AnimState:OverrideSymbol("snow", "snow", "snow")
	inst.AnimState:SetFinalOffset(1)
	inst.AnimState:Hide("snow")
	
	inst:AddComponent("highlightchild")
	
	inst.persists = false
	inst.updatesnowanim = i == 5
	
	inst.threshold1 = 0.4
	inst.threshold2 = 0.65
	inst.threshold3 = 0.9
	
	--inst:WatchWorldState("issnowcovered", UpdateSnow)
	inst:DoPeriodicTask(0.1, UpdateSnow, 0)
	--UpdateSnow(inst, TheWorld.state.issnowcovered)
	
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
	
	for i = 1, 5 do
		local fx = CreateFxFollowFrame(i)
		fx.entity:SetParent(owner.entity)
		fx.Follower:FollowSymbol(owner.GUID, "swap_hat", 0, -55, 0, true, nil, i - 1)
		
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

--

return Prefab("polar_snow_bush", fn, assets)