local assets = {
	Asset("ANIM", "anim/bluegem_overcharged.zip"),
}

local function DoGemFx(inst)
	if not inst:IsAsleep() and not inst.inlimbo then
		local fx = SpawnPrefab("bluegem_overcharged_fx")
		fx.entity:SetParent(inst.entity)
		fx.entity:AddFollower()
		fx.Follower:FollowSymbol(inst.GUID, "gem", GetRandomMinMax(-40, 40), GetRandomMinMax(0, -40), 0)
		
		inst._fxtask = inst:DoTaskInTime(FRAMES * math.random(20), DoGemFx)
	else
		inst._fxtask = nil
	end
end

local function OnEntitySleep(inst)
	if inst._fxtask then
		inst._fxtask:Cancel()
		inst._fxtask = nil
	end
end

local function OnEntityWake(inst)
	if inst._fxtask == nil and not inst.inlimbo then
		inst._fxtask = inst:DoTaskInTime(FRAMES, DoGemFx)
	end
end

local function OnIcicleSmashed(inst, data)
	local num_shards = math.random(TUNING.POLAR_ICICLE_NUMSHARDS.bluegem_overcharged.min, TUNING.POLAR_ICICLE_NUMSHARDS.bluegem_overcharged.max)
	local x, y, z = inst.Transform:GetWorldPosition()
	local small = data and data.small
	
	for i = 1, num_shards do
		local shard = SpawnPrefab("bluegem_shards")
		shard.components.inventoryitem:DoDropPhysics(x, y, z, true, small and 0.5 or (1.5 + math.random()))
	end
	
	if small then
		SpawnPrefab("ground_chunks_breaking").Transform:SetPosition(x, y, z)
		inst:Remove()
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetBank("bluegem_overcharged")
	inst.AnimState:SetBuild("bluegem_overcharged")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetSymbolLightOverride("gem", 0.1)
	inst.AnimState:SetSymbolLightOverride("fx", 0.8)
	inst.AnimState:SetScale(1.2, 1.2)
	
	inst.pickupsound = "gem"
	
	inst:AddTag("molebait")
	inst:AddTag("quakedebris")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
	inst.components.edible.hungervalue = 1
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunchAndSmash(inst)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	inst:ListenForEvent("iciclesmashed", OnIcicleSmashed)
	inst:ListenForEvent("ondropped", OnEntityWake)
	
	return inst
end

--

local NUM_FXSYMS = 4

local function fx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst:AddTag("NOCLICK")
	
	inst.AnimState:SetBank("bluegem_overcharged")
	inst.AnimState:SetBuild("bluegem_overcharged")
	inst.AnimState:PlayAnimation("fx"..math.random(6))
	inst.AnimState:SetFinalOffset(2)
	inst.AnimState:SetLightOverride(0.45)
	inst.AnimState:SetMultColour(1, 1, 1, 0.2)
	
	local symnum = math.random(NUM_FXSYMS)
	if symnum > 1 then
		inst.AnimState:OverrideSymbol("fx", "bluegem_overcharged", "fx"..symnum)
	end
	
	local scale = math.random() > 0.5 and 4.2 or -4.2
	inst.AnimState:SetScale(scale, 4.2)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	local anim_time = inst.AnimState:GetCurrentAnimationLength()
	local fade_in = anim_time * 1 - math.random()
	local fade_out = anim_time - fade_in
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({1, 1, 1, 1}, anim_time * 1 - math.random())
	
	inst:DoTaskInTime(fade_in, function()
		inst.components.colourtweener:StartTween({1, 1, 1, 0}, fade_out)
	end)
	
	inst:ListenForEvent("animover", inst.Remove)
	
	inst.persists = false
	
	return inst
end

return Prefab("bluegem_overcharged", fn, assets),
	Prefab("bluegem_overcharged_fx", fx, assets)