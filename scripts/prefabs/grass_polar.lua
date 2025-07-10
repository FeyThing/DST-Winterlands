local assets = {
	Asset("ANIM", "anim/grass_polar.zip"),
}

local prefabs = {
	"cutgrass",
}

local WAXED_PLANTS = require("prefabs/waxed_plant_common")

local function OnAnimOverStorm(inst)
	if inst.AnimState:IsCurrentAnimation("blown_loop1") or inst.AnimState:IsCurrentAnimation("blown_loop2") and inst:HasTag("pickable")
		and TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
		
		inst.AnimState:PlayAnimation("blown_loop"..math.random(2))
	end
end

local function OnPolarstormChanged(inst, active)
	if active and TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
		if inst:HasTag("pickable") and inst._blizzardbreak == nil then
			inst:ListenForEvent("animover", OnAnimOverStorm)
			inst.AnimState:PushAnimation("blown_pre", false)
			inst.AnimState:PushAnimation("blown_loop"..math.random(2), false)
			
			inst._blizzardbreak = inst:DoTaskInTime(2 + math.random(10), function()
				if math.random() < TUNING.GRASS_POLAR_BLIZZARDPICK_CHANCE and inst.components.pickable and inst:HasTag("pickable") then
					inst.components.pickable:MakeEmpty()
					
					inst.AnimState:PlayAnimation("fall")
					if inst.components.pickable:IsBarren() then
						inst.AnimState:PushAnimation("empty_to_dead")
						inst.AnimState:PushAnimation("idle_dead", false)
					else
						inst.AnimState:PushAnimation("picked", false)
					end
				end
			end)
		end
	elseif inst._blizzardbreak and not active then
		inst:RemoveEventCallback("animover", OnAnimOverStorm)
		if inst.AnimState:IsCurrentAnimation("blown_loop1") or inst.AnimState:IsCurrentAnimation("blown_loop2") then
			inst.AnimState:PushAnimation("blown_pst", false)
		end
		if inst:HasTag("pickable") then
			inst.AnimState:PushAnimation("idle", true)
		end
		
		inst._blizzardbreak:Cancel()
		inst._blizzardbreak = nil
	end
end

--

local function OnTransplantFn(inst)
	inst.components.pickable:MakeBarren()
end

local function OnRegenFn(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	inst:TryGetFlea()
	
	if inst.onpolarstormchanged and TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
		OnPolarstormChanged(inst, true)
	end
end

local function MakeEmptyFn(inst)
	if not POPULATING and (inst.components.witherable and inst.components.witherable:IsWithered() or inst.AnimState:IsCurrentAnimation("idle_dead")) then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("picked", false)
	else
		inst.AnimState:PlayAnimation("picked")
	end
	
	inst:ReleaseFlea()
end

local function MakeBarrenFn(inst, wasempty)
	if not POPULATING and (inst.components.witherable and inst.components.witherable:IsWithered()) then
		inst.AnimState:PlayAnimation(wasempty and "empty_to_dead" or "full_to_dead")
		inst.AnimState:PushAnimation("idle_dead", false)
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
end

local function OnPickedFn(inst, picker)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
	inst.AnimState:PlayAnimation("fall")
	
	if picker and math.random() <= TUNING.GRASS_POLAR_REEDS_CHANCE then
		local x, y, z = inst.Transform:GetWorldPosition()
		local loot = SpawnPrefab("cutreeds")
		
		loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
		loot.components.inventoryitem:DoDropPhysics(x, y, z, true)
	end
	if inst.components.pickable:IsBarren() then
		inst.AnimState:PushAnimation("empty_to_dead")
		inst.AnimState:PushAnimation("idle_dead", false)
	else
		inst.AnimState:PushAnimation("picked", false)
	end
	
	inst:ReleaseFlea()
end

local function DigUp(inst, worker)
	if inst.components.pickable and inst.components.lootdropper then
		if inst.components.pickable:CanBePicked() then
			inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
		end
		
		local withered = inst.components.witherable and inst.components.witherable:IsWithered()
		inst.components.lootdropper:SpawnLootPrefab(withered and "cutgrass" or "dug_grass")
	end
	
	inst:Remove()
end

local function OnSave(inst, data)
	data.was_herd = inst.components.herdmember and true or nil
end

local function OnLoad(inst, data)
	if data and data.has_flea then
		inst:TryGetFlea(true)
	end
end

local function OnPreLoad(inst, data)
	if data and data.was_herd then
		if TheWorld.components.lunarthrall_plantspawner then
			TheWorld.components.lunarthrall_plantspawner:setHerdsOnPlantable(inst)
		end
	end
end

local function TryGetFlea(inst, force)
	if force or math.random() < TUNING.GRASS_POLAR_FLEA_CHANCE and (TheWorld._numfleas or 0) < TUNING.POLARFLEA_WORLD_MAXFLEAS then
		local flea = SpawnPrefab("polarflea")
		flea.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if flea.SetHost then
			flea:SetHost(inst)
		end
	end
end

local function OnGetPolarFlea(inst, data)
	local flea = data and data.flea
	
	if flea and flea:IsValid() and flea:GetTimeAlive() > 2 then
		if inst:HasTag("pickable") then
			inst.AnimState:PlayAnimation("rustle")
			inst.AnimState:PushAnimation("idle", true)
		end
		inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds", nil, 0.25 + math.random() * 0.5)
	end
end

local function ReleaseFlea(inst)
	if inst._snowfleas then
		for i, v in ipairs(inst._snowfleas) do
			if v.SetHost then
				v:SetHost(nil, true) -- Be free!!
			end
		end
	end
end

local function GetFleaCapacity(inst, flea)
	if flea and flea.components.combat and flea.components.combat.target then
		return 0
	elseif TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
		return 0
	end
	
	return inst:HasTag("pickable") and TUNING.POLARFLEA_HOST_MAXFLEAS or 0
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	inst.MiniMapEntity:SetIcon("grass_polar.png")
	inst.MiniMapEntity:SetPriority(-1)
	
	inst:AddTag("fleahosted")
	inst:AddTag("plant")
	inst:AddTag("lunarplant_target")
	
	inst.AnimState:SetBank("grass_tall")
	inst.AnimState:SetBuild("grass_polar")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst._fleacapacity = GetFleaCapacity
	
	inst:AddComponent("inspectable")
	inst.components.inspectable:SetNameOverride("grass") -- TODO: Lazy ?
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
	inst.components.pickable:SetUp("cutgrass", TUNING.GRASS_REGROW_TIME * 2)
	inst.components.pickable.onregenfn = OnRegenFn
	inst.components.pickable.onpickedfn = OnPickedFn
	inst.components.pickable.makeemptyfn = MakeEmptyFn
	inst.components.pickable.makebarrenfn = MakeBarrenFn
	inst.components.pickable.ontransplantfn = OnTransplantFn
	inst.components.pickable.cycles_left = TUNING.GRASS_CYCLES
	inst.components.pickable.max_cycles = TUNING.GRASS_CYCLES
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	inst.components.pickable.jostlepick = true
	inst.components.pickable.droppicked = true
	inst.components.pickable.dropheight = 3
	
	inst:AddComponent("witherable")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUp)
	inst.components.workable:SetWorkLeft(1)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	
	MakeHauntableWorkAndIgnite(inst)
	
	MakeWaxablePlant(inst)
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnPreLoad = OnPreLoad
	inst.TryGetFlea = TryGetFlea
	inst.ReleaseFlea = ReleaseFlea
	
	local color = 0.75 + math.random() * 0.25
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
	
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst:ListenForEvent("gotpolarflea", OnGetPolarFlea)
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	
	return inst
end

local GRASS_BLOCKER_TAGS = {"antlion_sinkhole_blocker", "birdblocker", "blocker"}
local PLANT_TAGS = {"plant"}

local function customcheckfn(pt)
	return #TheSim:FindEntities(pt.x, pt.y, pt.z, 3, nil, nil, GRASS_BLOCKER_TAGS) == 0 and #TheSim:FindEntities(pt.x, pt.y, pt.z, 1.5, PLANT_TAGS) == 0
		and not TheWorld.Map:IsPointNearHole(pt) and TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true)
end

local function OnInit(inst)
	local numgrass = math.random(TUNING.GRASS_POLAR_DENSITY.min, TUNING.GRASS_POLAR_DENSITY.max)
	local pt = inst:GetPosition()
	
	for i = 1, numgrass do
		local offset = FindWalkableOffset(pt, math.random() * TWOPI, GetRandomMinMax(0, 10), 12, false, true, customcheckfn)
		
		if offset then
			local grass = SpawnPrefab("grass_polar")
			grass.Transform:SetPosition((pt + offset):Get())
			grass:TryGetFlea()
		end
	end
	
	inst:Remove()
end

local function spawner()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddNetwork()
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0.1, OnInit)
	
	inst.persists = false

    return inst
end

local waxed_data = {
	name = "grass_polar",
	bank = "grass",
	build = "grass1",
	mediumspacing = true,
	floater = {"med", 0.1, 0.92},
}

return Prefab("grass_polar", fn, assets, prefabs),
	Prefab("grass_polar_spawner", spawner, assets, prefabs),
	MakePlacer("dug_grass_polar_placer", "grass_tall", "grass_polar", "idle"),
	WAXED_PLANTS.CreateDugWaxedPlant(waxed_data)