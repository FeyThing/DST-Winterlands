local assets = {
	Asset("ANIM", "anim/tower_polar.zip"),
}

local assets_floor = {
	Asset("ANIM", "anim/emperor_penguin_ice.zip"),
}

local prefabs = {
	"collapse_small",
}

SetSharedLootTable("tower_polar", {
	{"ice", 1},
	{"ice", 1},
	{"ice", 0.8},
	{"ice", 0.8},
	{"ice", 0.6},
	{"ice", 0.6},
	{"ice", 0.4},
	{"ice", 0.4},
	{"ice", 0.2},
	{"ice", 0.2},
	{"oceanfish_medium_1_inv", 0.2},
	{"oceanfish_medium_2_inv", 0.2},
	{"oceanfish_medium_3_inv", 0.2},
	{"oceanfish_medium_4_inv", 0.2},
	{"oceanfish_medium_5_inv", 0.2},
	{"oceanfish_medium_8_inv", 0.2},
	{"oceanfish_medium_polar1_inv", 0.2},
	{"oceanfish_small_1_inv", 0.2},
	{"oceanfish_small_2_inv", 0.2},
	{"oceanfish_small_3_inv", 0.2},
	{"oceanfish_small_4_inv", 0.2},
	{"oceanfish_small_5_inv", 0.2},
	{"oceanfish_small_6_inv", 0.2},
	{"oceanfish_small_7_inv", 0.2},
	{"oceanfish_small_9_inv", 0.2},
	{"polar_dryice", 1},
	{"polar_dryice", 0.8},
	{"polar_dryice", 0.6},
	{"polar_dryice", 0.4},
	{"polar_dryice", 0.2},
	{"pondfish", 1},
})

local CASTLE_FLOOR_TAGS = {"polarcastlefloor"}
local CASTLE_TOWER_TAGS = {"polarcastletower"}

--	Court

local function IsSlipperyAtPosition(inst, x, y, z)
	local ex, ey, ez = inst.Transform:GetWorldPosition()
	local bbx1, bby1, bbx2, bby2 = inst.AnimState:GetVisualBB()
	
	if x < ex + bbx1 or x > ex + bbx2 or z < ez + bby1 or z > ez + bby2 then
		return false
	end

	local a, b = (bbx2 - bbx1) * 0.5, (bby2 - bby1) * 0.5
	local cx, cz = ex - x, ez - z
	
	return ((cx * cx) / (a * a)) + ((cz * cz) / (b * b)) < 1
end

local function SlipperyRate(inst, target)
	return 2.75 / 2
end

local function OnEntityWake_Castle(inst)
	inst._time_asleep = nil
	
	if TheWorld.components.emperorpenguinspawner == nil or not table.contains(TheWorld.components.emperorpenguinspawner.ice_castle_parts, inst) then
		local x, y, z = inst.Transform:GetWorldPosition()
		local towers = TheSim:FindEntities(x, y, z, TUNING.EMPEROR_PENGUIN_CASTLE_RANGE, CASTLE_TOWER_TAGS)
		
		if #towers == 0 then
			inst:Remove() -- This is in case castle was kept post winter but players now want to get rid of it !
		end
	end
end

local function ice()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.MiniMapEntity:SetIcon("penguin.png")
	
	inst.AnimState:SetBank("emperor_penguin_ice")
	inst.AnimState:SetBuild("emperor_penguin_ice")
	inst.AnimState:PlayAnimation("castle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	inst:AddTag("NOCLICK")
	inst:AddTag("polarcastlefloor")
	inst:AddTag("slipperyfeettarget")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_smallbyte(inst.GUID, "polarcastle._snowblockrange")
	inst._snowblockrange:set(12)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("slipperyfeettarget")
	inst.components.slipperyfeettarget:SetIsSlipperyAtPoint(IsSlipperyAtPosition)
	inst.components.slipperyfeettarget:SetSlipperyRate(SlipperyRate)
	
	inst.OnEntityWake = OnEntityWake_Castle
	
	return inst
end

--	Tower

local function OnIsPathFindingDirty(inst)	
	if inst:GetCurrentPlatform() == nil then
		local wall_x, wall_y, wall_z = inst.Transform:GetWorldPosition()
		if inst._ispathfinding:value() then
			if inst._pfpos == nil then
				inst._pfpos = Point(wall_x, wall_y, wall_z)
				TheWorld.Pathfinder:AddWall(wall_x, wall_y, wall_z)
			end
		elseif inst._pfpos then
			TheWorld.Pathfinder:RemoveWall(wall_x, wall_y, wall_z)
			inst._pfpos = nil
		end
	end
end

local function InitializePathFinding(inst)
	inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
	OnIsPathFindingDirty(inst)
end

local function MakeObstacle(inst)
	inst.Physics:SetActive(true)
	inst._ispathfinding:set(true)
	
	if inst.components.polarmistemitter then
		inst.components.polarmistemitter:StartMisting()
	end
end

local function ClearObstacle(inst)
	inst.Physics:SetActive(false)
	inst._ispathfinding:set(false)
	
	if inst.components.polarmistemitter then
		inst.components.polarmistemitter:StopMisting()
	end
end

local function OnSave(inst, data)
	data.hasflag = inst.flag ~= nil
end

local function OnLoad(inst, data)
	if data then
		if data.hasflag then
			inst:AddFlag()
		end
	end
end

local function OnRemove(inst)
	if inst.flag and inst.flag:IsValid() then
		inst.flag:Remove()
		inst.flag = nil
	end
	
	inst._ispathfinding:set_local(false)
	OnIsPathFindingDirty(inst)
end

local function GetStatus(inst)
	return inst.emperor_juggling and "PENGUIN" or nil
end

local function GetPolarMistMult(inst)
	return 3
end

local function AddFlag(inst)
	local flag = SpawnPrefab("tower_polar_flag")
	
	flag.Transform:SetPosition(inst.Transform:GetWorldPosition())
	flag.AnimState:PlayAnimation("flag_tower", true)
	flag:AddTag("NOBLOCK")
	flag:AddTag("NOCLICK")
	flag:RemoveTag("structure")
	flag.persists = false
	
	inst.flag = flag
end

local function OnEntitySleep(inst)
	inst.components.polarmistemitter:StopMisting()
end

local function OnEntityWake(inst)
	inst.components.polarmistemitter:StartMisting()
end

local function OnHammered(inst, worker)
	-- TODO: if emperor is on top, disturb juggling for a little bit !
	local pt = inst:GetPosition()
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(pt:Get())
	fx:SetMaterial("stone")
	
	if inst.components.lootdropper then
		inst.components.lootdropper:DropLoot()
		
		if TheWorld.components.emperorpenguinspawner and not TheWorld.components.emperorpenguinspawner.dropped_recipecard then
			TheWorld.components.emperorpenguinspawner.dropped_recipecard = true
			
			local recipecard = inst.components.lootdropper:SpawnLootPrefab("cookingrecipecard")
			if recipecard and recipecard.components.named then
				recipecard.cooker_name = "cookpot"
				recipecard.recipe_name = "icecream_emperor"
				recipecard.components.named:SetName(subfmt(STRINGS.NAMES.COOKINGRECIPECARD, {item = STRINGS.NAMES.ICECREAM_EMPEROR}))
			end
		end
	end
	
	TheWorld:PushEvent("emperorpenguin_dropsketch", {pos = pt})
	inst:Remove()
end

local function OnHit(inst, worker, workleft, numworks)
	if (numworks > 0.5 or workleft <= 0) then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle")
		--inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
		
		if inst.components.lootdropper and inst.flag and inst.flag:IsValid() then
			local pt = inst:GetPosition()
			pt.y = pt.y + 7
			
			inst.components.lootdropper:SpawnLootPrefab("tower_polar_flag_item", pt)
			
			inst.flag:Remove()
			inst.flag = nil
		end
	end
	
	if worker and not worker:HasTag("penguin") and worker.components.health and not worker.components.health:IsDead() and worker.components.freezable then
		if worker.components.temperature then
			local winterInsulation, summerInsulation = worker.components.temperature:GetInsulation()
			
			if winterInsulation >= TUNING.POLARWALL_FREEZE_INSULATION_MIN then
				return
			end
		end
		
		worker.components.freezable:AddColdness(TUNING.DRYICE_FREEZABLE_COLDNESS * 2)
		worker.components.freezable:SpawnShatterFX()
	end
end

local function ShouldRecoil(inst, worker, tool, numworks)
	local spawner = TheWorld.components.emperorpenguinspawner
	
	if spawner and not spawner.defeated and spawner.ice_towers and table.contains(spawner.ice_towers, inst) then
		return true, 0
	end
	
	return false, numworks
end

local function UpdateFacing(inst)
	local castle_floor = GetClosestInstWithTag(CASTLE_FLOOR_TAGS, inst, 12)
	local facing = inst.AnimState:GetCurrentFacing()
	
	if castle_floor and inst._facing ~= facing then
		local front = facing == FACING_DOWN
		local left = facing == FACING_DOWNLEFT
		local right = facing == FACING_DOWNRIGHT
		
		if front then
			inst.AnimState:Show("door_front")
			inst.AnimState:Hide("door_left")
			inst.AnimState:Hide("door_right")
		elseif left or right then
			inst.AnimState:Hide("door_front")
			inst.AnimState:Hide("door_left")
			inst.AnimState:Show("door_right")
		--[[elseif right then
			inst.AnimState:Hide("door_front")
			inst.AnimState:Hide("door_left")
			inst.AnimState:Show("door_right")]]
		else
			inst.AnimState:Hide("door_front")
			inst.AnimState:Hide("door_left")
			inst.AnimState:Hide("door_right")
		end
		
		inst._facing = facing
	end
end

local function tower()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()
	
	MakeObstaclePhysics(inst, 0.5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst.AnimState:SetBank("tower_polar")
	inst.AnimState:SetBuild("tower_polar")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetFinalOffset(2)
	inst.AnimState:SetScale(1.25, 1.25)
	inst.AnimState:Hide("flagpole")
	inst.AnimState:Hide("flag")
	
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("birdblocker")
	inst:AddTag("polarcastletower")
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	MakeObstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)
	
	inst.OnRemoveEntity = OnRemove
	
	inst:AddComponent("updatelooper")
	inst.components.updatelooper:AddPostUpdateFn(UpdateFacing)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable("tower_polar")
	
	inst:AddComponent("polarmistemitter")
	inst.components.polarmistemitter:StartMisting()
	inst.components.polarmistemitter.scale = GetPolarMistMult
	inst.components.polarmistemitter.maxmist = 4
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(9)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetShouldRecoilFn(ShouldRecoil)
	
	inst:AddComponent("savedrotation")
	
	MakeHauntableWork(inst)
	
	inst.AddFlag = AddFlag
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end

--	Flag(s)

local function OnHammered_Flag(inst, worker)
	local fx = SpawnPrefab("collapse_small")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("wood")
	
	if inst.components.lootdropper then
		inst.components.lootdropper:DropLoot()
	end
	
	inst:Remove()
end

local function FlagWindUpdate(inst)
	if TheWorld.components.worldwind then
		inst.Transform:SetRotation(TheWorld.components.worldwind:GetWindAngle() or 0)
	end
	
	inst._windupdate = inst:DoTaskInTime(1 + math.random(), inst.FlagWindUpdate)
end

local function flag()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetSixFaced()
	
	inst:SetDeploySmartRadius(DEPLOYSPACING_RADIUS[DEPLOYSPACING.LESS] / 2)
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("tower_polar")
	inst.AnimState:SetBuild("tower_polar")
	inst.AnimState:PlayAnimation("flag", true)
	inst.AnimState:SetScale(1.25, 1.25)
	inst.AnimState:SetFinalOffset(4)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnHammered_Flag)
	
	inst.FlagWindUpdate = FlagWindUpdate
	inst:FlagWindUpdate()
	
	return inst
end

local function OnDeploy(inst, pt, deployer)
	local flag = SpawnPrefab("tower_polar_flag")
	
	if flag then
		flag.Transform:SetPosition(pt.x, 0, pt.z)
		flag.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
		
		if inst.components.stackable then
			inst.components.stackable:Get():Remove()
		else
			inst:Remove()
		end
	end
end

local function item()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("tower_polar")
	inst.AnimState:SetBuild("tower_polar")
	inst.AnimState:PlayAnimation("flag_item")
	
	MakeInventoryFloatable(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
	MakeSmallPropagator(inst)
	
	MakeHauntableLaunch(inst)
	
	return inst
end

local function PlacerPostInit(inst)
	inst.AnimState:SetScale(1.25, 1.25)
end

return Prefab("penguin_castle_ice", ice, assets_floor),
	Prefab("tower_polar", tower, assets, prefabs),
	Prefab("tower_polar_flag", flag, assets, prefabs),
	Prefab("tower_polar_flag_item", item, assets),
	MakePlacer("tower_polar_flag_item_placer", "tower_polar", "tower_polar", "flag", nil, nil, nil, nil, nil, nil, PlacerPostInit)