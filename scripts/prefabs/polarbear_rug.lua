local assets = {
	Asset("ANIM", "anim/polarbear_rug.zip"),
}

local RUG_RADIUS_SQ = TUNING.POLARBEAR_RUG_RADIUS * TUNING.POLARBEAR_RUG_RADIUS

local function IsRugAtPoint(inst, x, y, z)
	local ex, ey, ez = inst.Transform:GetWorldPosition()
	
	return distsq(ex, ez, x, z) <= RUG_RADIUS_SQ
end

local function OnPlayerNear(inst, player)
	if player and player.components.temperature then
		player._polarbear_rug = inst
	end
end

local function OnPlayerFar(inst, player)
	if player and player.components.temperature and player._polarbear_rug == inst then
		player._polarbear_rug = nil
	end
end

local function AuraFn(inst, observer)
	local iscanadian = observer and (observer:HasTag("polite") or observer:HasTag("pinetreepioneer"))
	
	return TUNING.SANITYAURA_TINY * (iscanadian and TUNING.POLARBEAR_RUG_MULT_CANADIAN or 1)
end

local function AuraFalloffFn(inst, observer, distsq)
	return 1
end

local function OnHammered(inst, worker)
	OnPlayerFar(inst, worker)
	
	if inst.components.burnable and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	if inst.components.lootdropper then
		inst.components.lootdropper:DropLoot()
	end
	
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	inst:Remove()
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/throne/build")
end

local function IsLowPriorityAction(act, force_inspect)
	return act == nil or act.action == ACTIONS.WALKTO or (act.action == ACTIONS.LOOKAT and not force_inspect)
end

local function CanMouseThrough(inst)
	if not inst:HasTag("fire") and ThePlayer and ThePlayer.components.playeractionpicker then
		local force_inspect = ThePlayer.components.playercontroller and ThePlayer.components.playercontroller:IsControlPressed(CONTROL_FORCE_INSPECT)
		local lmb, rmb = ThePlayer.components.playeractionpicker:DoGetMouseActions(inst:GetPosition(), inst)
		
		local lowpriority = IsLowPriorityAction(rmb, force_inspect) and IsLowPriorityAction(lmb, force_inspect)
		return lowpriority, lowpriority
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddPhysics()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Physics:SetSphere(2)
	
	inst.AnimState:SetBank("polarbear_rug")
	inst.AnimState:SetBuild("polarbear_rug")
	inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(4)
	
	inst:AddTag("cattoy")
	inst:AddTag("NOBLOCK")
	inst:AddTag("nonslipgritpool")
	inst:AddTag("playerowned")
	inst:AddTag("polarbearrug")
	inst:AddTag("rotatableobject")
	inst:AddTag("snowblocker")
	inst:AddTag("storytellingprop")
	
	inst.CanMouseThrough = CanMouseThrough
	
	inst.scrapbook_inspectonseen = true
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "polarbear_rug._snowblockrange")
	inst._snowblockrange:set(6)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("nonslipgritpool")
	inst.components.nonslipgritpool:SetIsGritAtPoint(IsRugAtPoint)
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(TUNING.POLARBEAR_RUG_RADIUS, TUNING.POLARBEAR_RUG_RADIUS)
	inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
	inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
	inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = AuraFn
	inst.components.sanityaura.fallofffn = AuraFalloffFn
	inst.components.sanityaura.max_distsq = TUNING.POLARBEAR_RUG_RADIUS
	
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("storytellingprop") -- Using same proxy as campfire, patched in prefabpostinit (wilson) since this doesn't use fueled
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	MakeHauntableWork(inst)
	MakeLargeBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	return inst
end

local function PlacerPostinit(inst)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(4)
end

return Prefab("polarbear_rug", fn, assets),
	MakePlacer("polarbear_rug_placer", "polarbear_rug", "polarbear_rug", "idle", true, nil, nil, nil, 90, nil, PlacerPostinit)