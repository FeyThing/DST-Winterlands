local assets = {
	Asset("ANIM", "anim/polar_brazier.zip"),
}

local prefabs = {
	"collapse_small",
	"polar_brazier_item",
}

local prefabs_item = {
	"polar_brazier",
}

local DEFAULT_PAINTING = "blue"
local HOUSE_PAINTINGS = {
	"blue",
	"red",
}

local function OnExtinguish(inst)
	if inst.components.fueled then
		inst.components.fueled:InitializeFuelLevel(0)
	end
end

local function OnTakeFuel(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function UpdateFuelRate(inst)
	inst.components.fueled.rate = TheWorld.state.israining and inst.components.rainimmunity == nil and 1 + TUNING.FIREPIT_RAIN_RATE * TheWorld.state.precipitationrate or 1
end

local function OnUpdateFueled(inst)
	if inst.components.burnable and inst.components.fueled then
		UpdateFuelRate(inst)
		inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(), inst.components.fueled:GetSectionPercent())
	end
end

local function OnFuelChange(newsection, oldsection, inst, doer)
	if newsection <= 0 then
		inst.components.burnable:Extinguish()
	else
		if not inst.components.burnable:IsBurning() then
			UpdateFuelRate(inst)
			inst.components.burnable:Ignite(nil, nil, doer)
		end
		inst.components.burnable:SetFXLevel(newsection, inst.components.fueled:GetSectionPercent())
	end
end

local function ChangeToItem(inst)
	inst:RemoveComponent("portablestructure")
	inst:RemoveComponent("workable")
	
	inst:AddTag("NOCLICK")
	
	local item = SpawnPrefab("polar_brazier_item", inst.linked_skinname, inst.skin_id)
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
	item.AnimState:PlayAnimation("disassemble")
	item.AnimState:PushAnimation("idle_item")
	item.SoundEmitter:PlaySound("dontstarve/characters/walter/tent/close")
	
	item.house_paint = inst.house_paint
	item.no_teeth = inst.no_teeth
end

local function OnDismantle(inst, doer)
	ChangeToItem(inst)
	inst:Remove()
end

local function OnHammered(inst, worker)
	if inst.components.burnable and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")
	
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function OnHit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle", true)
end

local function OnHaunt(inst, haunter)
	if math.random() <= TUNING.HAUNT_CHANCE_RARE and inst.components.fueled then
		inst.components.fueled:DoDelta(TUNING.MED_FUEL)
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
		
		return true
	end
	
	return false
end

local function OnInit(inst)
	if inst.components.burnable then
		inst.components.burnable:FixFX()
	end
	
	if inst.no_teeth then
		inst.AnimState:Hide("decor")
	end
	inst:SetPainting(inst.house_paint or HOUSE_PAINTINGS[math.random(#HOUSE_PAINTINGS)])
end

local function SetPainting(inst, colour)
	if colour ~= DEFAULT_PAINTING then
		inst.AnimState:OverrideSymbol("blue", "polar_brazier", colour)
	else
		inst.AnimState:ClearOverrideSymbol("blue")
	end
	
	inst.house_paint = colour
end

local function OnSave(inst, data)
	data.stage = inst.stage
	data.no_teeth = inst.no_teeth
end

local function OnLoad(inst, data)
	if data then
		inst.stage = data.stage
		inst.no_teeth = data.no_teeth
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst:SetDeploySmartRadius(0.45)
	inst:SetPhysicsRadiusOverride(0.2)
	MakeObstaclePhysics(inst, inst.physicsradiusoverride)
	
	inst.MiniMapEntity:SetIcon("polar_brazier.png")
	
	inst:AddTag("campfire")
	inst:AddTag("cooker")
	inst:AddTag("portablebrazier")
	inst:AddTag("storytellingprop")
	inst:AddTag("structure")
	inst:AddTag("wildfireprotected")
	
	inst.AnimState:SetBank("polar_brazier")
	inst.AnimState:SetBuild("polar_brazier")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetScale(0.7, 0.7)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("burnable")
	inst.components.burnable:AddBurnFX("campfirefire", Vector3(0, 0, 0), "swap_fire", true, nil, true)
	inst:ListenForEvent("onextinguish", OnExtinguish)
	
	inst:AddComponent("cooker")
	
	inst:AddComponent("fueled")
	inst.components.fueled.maxfuel = TUNING.FIREPIT_FUEL_MAX
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(4)
	inst.components.fueled.bonusmult = TUNING.FIREPIT_BONUS_MULT
	inst.components.fueled:SetTakeFuelFn(OnTakeFuel)
	inst.components.fueled:SetUpdateFn(OnUpdateFueled)
	inst.components.fueled:SetSectionCallback(OnFuelChange)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("portablestructure")
	inst.components.portablestructure:SetOnDismantleFn(OnDismantle)
	
	inst:AddComponent("storytellingprop")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.SetPainting = SetPainting
	
	inst:DoTaskInTime(0, OnInit)
	
	return inst
end

local function OnDeploy(inst, pt, deployer)
	local brazier = SpawnPrefab("polar_brazier")
	
	if brazier then
		brazier.house_paint = inst.house_paint
		brazier.no_teeth = inst.no_teeth
		
		brazier.Physics:SetCollides(false)
		brazier.Physics:Teleport(pt.x, 0, pt.z)
		brazier.Physics:SetCollides(true)
		
		brazier.AnimState:PlayAnimation("place")
		brazier.AnimState:PushAnimation("idle", true)
		brazier.SoundEmitter:PlaySound("dontstarve/characters/walter/tent/open")
		
		inst:Remove()
		PreventCharacterCollisionsWithPlacedObjects(brazier)
	end
end

local function OnPreBuilt(inst, builder, materials, recipe)
	inst.no_teeth = true
end

local function itemfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polar_brazier")
	inst.AnimState:SetBuild("polar_brazier")
	inst.AnimState:PlayAnimation("idle_item")
	inst.AnimState:SetScale(0.7, 0.7)
	
	inst:AddTag("portableitem")
	
	MakeInventoryFloatable(inst, nil, 0.05, 0.7)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.onPreBuilt = OnPreBuilt
	inst.SetPainting = SetPainting
	
	inst:DoTaskInTime(0, OnInit)
	
	return inst
end

return Prefab("polar_brazier", fn, assets, prefabs),
	Prefab("polar_brazier_item", itemfn, assets, prefabs_item),
	MakePlacer("polar_brazier_item_placer", "polar_brazier", "polar_brazier", "placer")