local assets_bear = {
	Asset("ANIM", "anim/polarbear_head.zip"),
}

local assets_walrus = {
	Asset("ANIM", "anim/polarwalrus_head.zip"),
}

local prefabs = {
	"flies",
	"twigs",
	"collapse_small",
}

local function OnFinish(inst)
	if inst.components.burnable and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	if TheWorld.state.isfullmoon then
		inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	end
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function OnWorked(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation(inst.awake and "idle_awake" or "idle_asleep")
	end
end

local function OnFullMoon(inst, isfullmoon)
	if not inst:HasTag("burnt") then
		if isfullmoon then
			if not inst.awake then
				inst.awake = true
				inst.AnimState:PlayAnimation("wake")
				inst.AnimState:PushAnimation("idle_awake", false)
			end
		elseif inst.awake then
			inst.awake = nil
			inst.AnimState:PlayAnimation("sleep")
			inst.AnimState:PushAnimation("idle_asleep", false)
		end
	end
end

local function OnSave(inst, data)
	if inst:HasTag("burnt") or (inst.components.burnable and inst.components.burnable:IsBurning()) then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
	
	-- When skin is applied, materials already placed needs to drop (polarheadstick_init_fn), except on reload, we don't want that
	inst.material_loaded = true
end

local function OnFinishHaunt(inst)
	if inst.awake and not (TheWorld.state.isfullmoon or inst:HasTag("burnt")) then
		inst.awake = nil
		inst.AnimState:PlayAnimation("sleep")
		inst.AnimState:PushAnimation("idle_asleep", false)
	end
end

local function OnHaunt(inst, haunter)
	if not (inst.awake or inst:HasTag("burnt")) then
		inst.awake = true
		inst.AnimState:PlayAnimation("wake")
		inst.AnimState:PushAnimation("idle_awake")
		inst:DoTaskInTime(4, OnFinishHaunt)
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
		
		return true
	end
	
	return false
end

--	TODO: Add bunnyman head
--	TODO: Add burnt strings and getstatus

local function create_common(bankandbuild, combattags, combatnottags)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank(bankandbuild)
	inst.AnimState:SetBuild(bankandbuild)
	inst.AnimState:PlayAnimation("idle_asleep")
	
	inst:AddTag("beaverchewable")
	inst:AddTag("mobhead_combat")
	inst:AddTag("structure")
	
	inst.mobhead_combat_mods = {
		armormult = TUNING.MOBHEADS_COMBAT_ARMOR_MULT,
		damagemult = TUNING.MOBHEADS_COMBAT_DAMAGE_MULT,
		stacking = TUNING.MOBHEADS_COMBAT_BUFF_STACKING,
		tags = combattags,
		not_tags = combatnottags,
	}
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.flies = inst:SpawnChild("flies")
	inst.awake = nil
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_MEDIUM
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnWorkCallback(OnWorked)
	inst.components.workable.onfinish = OnFinish
	
	MakeSmallBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:WatchWorldState("isfullmoon", OnFullMoon)
	OnFullMoon(inst, TheWorld.state.isfullmoon)
	
	inst.face_left = math.random() > 0.5
	local scale = inst.face_left and 1 or -1
	inst.AnimState:SetScale(scale, 1)
	
	return inst
end

local function create_bearhead()
	local inst = create_common("polarbear_head", {"bear", "bearger"})
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	return inst
end

local function create_walrushead()
	local inst = create_common("polarwalrus_head", {"walrus"})
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	return inst
end

--

local function OnConstructed(inst, doer)
	local concluded = inst.constructionname ~= nil
	for _, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
			concluded = false
			break
		end
	end
	
	if concluded then
		local head = SpawnPrefab(inst.constructionname)
		
		if head then
			head.Transform:SetPosition(inst.Transform:GetWorldPosition())
			head.AnimState:PlayAnimation("hit")
			head.AnimState:PushAnimation("idle_asleep")
			head.SoundEmitter:PlaySound("dontstarve/common/together/put_meat_rack")
		end
		
		inst:Remove()
	else
		inst.AnimState:PlayAnimation("hit_stick")
		inst.AnimState:PushAnimation("idle_stick")
	end
end

local function OnFinish_Stick(inst)
	if inst.components.burnable and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	if inst.components.constructionsite then
		inst.components.constructionsite:DropAllMaterials()
	end
	inst.components.lootdropper:DropLoot()
	
	inst:Remove()
end

local function OnWorked_Stick(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit_stick")
		inst.AnimState:PushAnimation("idle_stick")
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("build")
	inst.AnimState:PushAnimation("idle_stick")
	inst.SoundEmitter:PlaySound("stageplay_set/mannequin/place")
end

local function OnConstructionNameDirty(inst)
	inst.constructionname = inst.net_constructionname:value()
end

local function builder_common(constructioname)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst:AddTag("beaverchewable")
	inst:AddTag("constructionsite")
	inst:AddTag("structure")
	
	inst.AnimState:SetBank("polarbear_head")
	inst.AnimState:SetBuild("polarbear_head")
	inst.AnimState:PlayAnimation("idle_stick")
	
	inst.constructionname = constructioname
	inst.net_constructionname = net_string(inst.GUID, "polarheadstick.net_constructionname", "net_constructionnamedirty")
	
	inst.reskin_prefabswap = "polarheadstick" -- reskin_tool postinit, we need this to cycle between the skins despite each having unique prefabs
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst:ListenForEvent("net_constructionnamedirty", OnConstructionNameDirty)
		
		return inst
	end
	
	inst.Stick_OnConstructed = OnConstructed
	
	inst:AddComponent("constructionsite")
	inst.components.constructionsite:SetConstructionPrefab("construction_container")
	inst.components.constructionsite:SetOnConstructedFn(inst.Stick_OnConstructed)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "polarheadstick"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"twigs", "twigs"})
	
	inst:AddComponent("named")
	inst.components.named:SetName(STRINGS.NAMES.POLARHEADSTICK_NAME)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnFinishCallback(OnFinish_Stick)
	inst.components.workable:SetOnWorkCallback(OnWorked_Stick)
	
	MakeHauntableWork(inst)
	MakeSmallBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	return inst
end

local function builder_bear()
	local inst = builder_common("polarbearhead")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	return inst
end

local function builder_merm()
	local inst = builder_common("mermhead")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	return inst
end

local function builder_pig()
	local inst = builder_common("pighead")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	return inst
end

local function builder_walrus()
	local inst = builder_common("polarwalrushead")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	return inst
end

return Prefab("polarbearhead", create_bearhead, assets_bear, prefabs), -- New heads
	Prefab("polarwalrushead", create_walrushead, assets_walrus, prefabs),
	
	Prefab("polarheadstick", builder_bear, assets_bear, prefabs), -- Just the construction sites (technically also the skins)
	Prefab("polarheadstick_merm", builder_merm, assets_bear, prefabs),
	Prefab("polarheadstick_pig", builder_pig, assets_bear, prefabs),
	Prefab("polarheadstick_walrus", builder_walrus, assets_bear, prefabs),
	
	MakePlacer("polarheadstick_placer", "polarbear_head", "polarbear_head", "idle_stick")