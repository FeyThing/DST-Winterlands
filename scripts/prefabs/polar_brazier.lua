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

local function OnTakeFuel(inst, fuelvalue)
	if fuelvalue >= TUNING.MED_FUEL * (inst.components.fueled.bonusmult or 1) then
		inst.AnimState:PlayAnimation("fuel")
		inst.AnimState:PushAnimation("idle", true)
		if not inst.no_teeth then
			inst.SoundEmitter:PlaySound("polarsounds/brazier/teeth")
		end
	end
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

local function GetStatus(inst)
	return not (inst.components.fueled and inst.components.fueled:IsEmpty()) and "ON" or nil
end

local BEAR_TAGS = {"bear"}
local BEAR_NOT_TAGS = {"INLIMBO", "sleeping"}

local function ChangeToItem(inst)
	inst:RemoveComponent("portablestructure")
	inst:RemoveComponent("workable")
	
	inst:AddTag("NOCLICK")
	
	local item = SpawnPrefab("polar_brazier_item", inst.linked_skinname, inst.skin_id)
	item.Transform:SetPosition(inst.Transform:GetWorldPosition())
	item.AnimState:PlayAnimation("disassemble")
	item.AnimState:PushAnimation("idle_item")
	item.SoundEmitter:PlaySound("polarsounds/brazier/drop")
	
	item.house_paint = inst.house_paint
	item.no_teeth = inst.no_teeth
end

local function ProtectFromThief(inst, thief)
	if thief and not thief:HasTag("bearbuddy") and thief.components.combat and not inst.no_teeth then
		local bear = FindEntity(inst, TUNING.POLARBEAR_PROTECTSTUFF_RANGE, function(guy)
			return guy.components.health and not guy.components.health:IsDead() and guy.components.homeseeker and guy.components.homeseeker.home ~= nil
				and guy.components.combat and guy.components.combat.target == nil and guy.components.combat:CanTarget(thief)
				and not (guy.components.follower and guy.components.follower.leader)
				
		end, BEAR_TAGS, BEAR_NOT_TAGS)
		
		if bear and bear.sg then
			if thief.components.timer and not thief.components.timer:TimerExists("stealing_bear_stuff") then
				thief.components.timer:StartTimer("stealing_bear_stuff", 2)
			end
			bear.components.combat:SuggestTarget(thief)
			bear.sg:GoToState("abandon", thief)
		end
	end
end

local function OnDismantle(inst, doer)
	if not inst.no_teeth then
		inst.SoundEmitter:PlaySound("polarsounds/brazier/teeth")
	end
	
	ProtectFromThief(inst, doer)
	ChangeToItem(inst)
	inst:Remove()
end

local function OnHammered(inst, worker)
	if inst.components.burnable and inst.components.burnable:IsBurning() then
		inst.components.burnable:Extinguish()
	end
	
	--local fx = SpawnPrefab("collapse_big")
	--fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	--fx:SetMaterial("stone")
	
	--inst.components.lootdropper:DropLoot()
	ChangeToItem(inst)
	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst.no_teeth then
		inst.SoundEmitter:PlaySound("polarsounds/brazier/teeth")
	end
	
	ProtectFromThief(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle", true)
end

local function OnHaunt(inst, haunter)
	if math.random() <= TUNING.HAUNT_CHANCE_RARE and inst.components.fueled then
		inst.components.fueled:DoDelta(TUNING.MED_FUEL)
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
		
		inst.AnimState:PlayAnimation("fuel")
		inst.AnimState:PushAnimation("idle", true)
		if not inst.no_teeth then
			inst.SoundEmitter:PlaySound("polarsounds/brazier/teeth")
		end
		
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
	data.colour = inst.house_paint
	data.no_teeth = inst.no_teeth
end

local function OnLoad(inst, data)
	if data then
		inst.no_teeth = data.no_teeth
		if data.colour then
			inst:SetPainting(data.colour)
		end
	end
end

local function SetPolarstormRate(inst)
	if inst.components.fueled then
		if not inst.components.fueled:IsEmpty() and TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
			inst.components.fueled.rate_modifiers:SetModifier(inst, inst.polarstorm_fuelmod or 1, "polarstorm")
		else
			inst.components.fueled.rate_modifiers:RemoveModifier(inst, "polarstorm")
		end
	end
end

local function OnPolarstormChanged(inst, active)
	if active then
		if inst._update_polarstorm_rate == nil then
			inst._update_polarstorm_rate = inst:DoPeriodicTask(1, SetPolarstormRate)
		end
	elseif inst._update_polarstorm_rate then
		inst._update_polarstorm_rate:Cancel()
		inst._update_polarstorm_rate = nil
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
	inst:AddTag("portable_brazier")
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
	inst.components.inspectable.getstatus = GetStatus
	
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
	
	inst.polarstorm_fuelmod = TUNING.POLAR_STORM_FUELEDMULT.FIREPIT
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	if TheWorld.components.polarstorm then
		OnPolarstormChanged(inst, TheWorld.components.polarstorm:IsPolarStormActive())
	end
	
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
		brazier.SoundEmitter:PlaySound("polarsounds/brazier/place")
		
		brazier:DoTaskInTime(0.6, function()
			if not brazier.no_teeth then
				brazier.SoundEmitter:PlaySound("polarsounds/brazier/teeth")
			end
		end)
		
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
	
	inst:AddTag("donotautopick")
	inst:AddTag("portableitem")
	
	MakeInventoryFloatable(inst, nil, 0.05, 0.7)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.ONEPOINTFIVE)
	
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