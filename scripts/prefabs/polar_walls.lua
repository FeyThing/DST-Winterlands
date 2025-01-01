require "prefabutil"

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

local anims = {
	{threshold = 0, anim = "broken"},
	{threshold = 0.4, anim = "onequarter"},
	{threshold = 0.5, anim = "half"},
	{threshold = 0.99, anim = "threequarter"},
	{threshold = 1, anim = {"fullA", "fullB", "fullC"}},
}

local function ResolveAnimToPlay(inst, percent)
	for i, v in ipairs(anims) do
		if percent <= v.threshold then
			if type(v.anim) == "table" then
				return v.anim[math.random(1, #v.anim)]
			else
				return v.anim
			end
		end
	end
end

local function OnHealthChange(inst, old_percent, new_percent)
	local anim_to_play = ResolveAnimToPlay(inst, new_percent)
	
	if new_percent > 0 then
		if old_percent <= 0 then
			MakeObstacle(inst)
		end
		inst.AnimState:PlayAnimation(anim_to_play.."_hit")
		inst.AnimState:PushAnimation(anim_to_play, false)
	else
		if old_percent > 0 then
			ClearObstacle(inst)
		end
		inst.AnimState:PlayAnimation(anim_to_play)
	end
	
	inst.wallanim = anim_to_play
end

local function KeepTargetFn()
	return false
end

local function OnSave(inst, data)
	data.wallanim = inst.wallanim
end

local function OnLoad(inst, data)
	if inst.components.health:IsDead() then
		ClearObstacle(inst)
	end
	
	if data then
		if data.wallanim then
			inst.wallanim = data.wallanim
			inst.AnimState:PlayAnimation(inst.wallanim, false)
		end
		if data.gridnudge then
			local function normalize(coord)	   
				
				local temp = coord%0.5 
				coord = coord + 0.5 - temp
				
				if  coord%1 == 0 then
					coord = coord -0.5
				end
				
				return coord
			end
			
			local pt = Vector3(inst.Transform:GetWorldPosition())
			pt.x = normalize(pt.x)
			pt.z = normalize(pt.z)
			inst.Transform:SetPosition(pt.x, pt.y, pt.z)
		end
	end
end

local function OnRemove(inst)
	inst._ispathfinding:set_local(false)
	OnIsPathFindingDirty(inst)
end

local PLAYER_TAGS = {"player"}
local function ValidRepairFn(inst)
	if inst.Physics:IsActive() then
		return true
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	if TheWorld.Map:IsAboveGroundAtPoint(x, y, z) then
		return true
	end
	
	if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
		for i, v in ipairs(TheSim:FindEntities(x, 0, z, 1, PLAYER_TAGS)) do
			if v ~= inst and v.entity:IsVisible() and v.components.placer == nil and v.entity:GetParent() == nil then
				local px, _, pz = v.Transform:GetWorldPosition()
				if math.floor(x) == math.floor(px) and math.floor(z) == math.floor(pz) then
					return false
				end
			end
		end
	end
	
	return true
end

local function GetPolarMistMult(inst)
	return math.max(2 * (inst.components.health and inst.components.health:GetPercent() or 1), 1.5)
end

local function OnPutInInv(inst, owner)
	if inst._droppedice and owner.components.freezable then
		owner.components.freezable:AddColdness(TUNING.DRYICE_FREEZABLE_COLDNESS * (not owner:HasTag("player") and 4 or 1))
	end
	
	inst.components.polarmistemitter:StopMisting()
	inst._droppedice = nil
end

local function OnDropped(inst)
	inst.components.polarmistemitter:StartMisting()
	inst._droppedice = true
end

local function OnEntitySleep(inst)
	inst.components.polarmistemitter:StopMisting()
end

local function OnEntityWake(inst)
	if not inst.inlimbo then
		inst.components.polarmistemitter:StartMisting()
	end
end

local function OnAttacked(inst, data)
	local attacker = data and data.attacker
	local weapon = data and data.weapon
	
	if attacker and attacker.components.health and not attacker.components.health:IsDead() and attacker.components.freezable
		and (weapon == nil or ((weapon.components.weapon == nil or weapon.components.weapon.projectile == nil) and weapon.components.projectile == nil)) then
		
		if attacker.components.temperature then
			local winterInsulation, summerInsulation = attacker.components.temperature:GetInsulation()
			
			if winterInsulation >= TUNING.POLARWALL_FREEZE_INSULATION_MIN then
				return
			end
		end
		
		attacker.components.freezable:AddColdness(TUNING.DRYICE_FREEZABLE_COLDNESS * 2)
		attacker.components.freezable:SpawnShatterFX()
	end
end

function MakeWallType(data)
	local assets = {
		Asset("ANIM", "anim/wall.zip"),
		Asset("ANIM", "anim/wall_"..data.name..".zip"),
	}
	
	local prefabs = {
		"collapse_small",
	}
	
	local function OnDeployWall(inst, pt, deployer)
		local wall = SpawnPrefab("wall_"..data.name, inst.linked_skinname, inst.skin_id)
		
		if wall then
			local x = math.floor(pt.x) + 0.5
			local z = math.floor(pt.z) + 0.5
			wall.Physics:SetCollides(false)
			wall.Physics:Teleport(x, 0, z)
			wall.Physics:SetCollides(true)
			inst.components.stackable:Get():Remove()
			
			if data.buildsound then
				wall.SoundEmitter:PlaySound(data.buildsound)
			end
		end
	end
	
	local function OnHammered(inst, worker)
		if data.maxloots and data.loot then
			local num_loots = math.max(1, math.floor(data.maxloots * inst.components.health:GetPercent()))
			
			for i = 1, num_loots do
				inst.components.lootdropper:SpawnLootPrefab(data.loot)
			end
		end
		
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		if data.material then
			fx:SetMaterial(data.material)
		end
		
		inst:Remove()
	end
	
	local function itemfn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst:AddTag("wallbuilder")
		if data.polar then
			inst:AddTag("dryice")
		end
		
		inst.AnimState:SetBank("wall")
		inst.AnimState:SetBuild("wall_"..data.name)
		inst.AnimState:PlayAnimation("idle")
		
		local item_floats = (data.name == "wood") or (data.name == "hay")
		if item_floats then
			MakeInventoryFloatable(inst)
		end
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		if not item_floats then
			inst.components.inventoryitem:SetSinks(true)
		end
		
		inst:AddComponent("repairer")
		inst.components.repairer.repairmaterial = data.material
		inst.components.repairer.healthrepairvalue = data.maxhealth / 6
		
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = OnDeployWall
		inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
		
		if data.flammable then
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
			MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
			MakeSmallPropagator(inst)
		end
		
		if data.polar then
			inst:AddComponent("polarmistemitter")
			inst.components.polarmistemitter:StartMisting()
			
			inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInv)
			inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
			
			inst.OnEntitySleep = OnEntitySleep
			inst.OnEntityWake = OnEntityWake
		end
		
		MakeHauntableLaunch(inst)
		
		return inst
	end
	
	local function OnHit(inst)
		if data.material then
			inst.SoundEmitter:PlaySound(data.hitsound)
		end
		
		local healthpercent = inst.components.health:GetPercent()
		if healthpercent > 0 then
			local anim_to_play = ResolveAnimToPlay(inst, healthpercent)
			inst.AnimState:PlayAnimation(anim_to_play.."_hit")
			inst.AnimState:PushAnimation(anim_to_play, false)
		end
	end
	
	local function OnRepaired(inst)
		if data.buildsound then
			inst.SoundEmitter:PlaySound(data.buildsound)
		end
		MakeObstacle(inst)
	end
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
		
		inst.Transform:SetEightFaced()
		
		MakeObstaclePhysics(inst, 0.5)
		inst.Physics:SetDontRemoveOnSleep(true)
		
		inst:AddTag("wall")
		inst:AddTag("noauradamage")
		
		for i, v in ipairs(data.tags) do
			inst:AddTag(v)
		end
		
		inst.AnimState:SetBank("wall")
		inst.AnimState:SetBuild("wall_"..data.name)
		inst.AnimState:PlayAnimation("half")
		
		inst._pfpos = nil
		inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
		MakeObstacle(inst)
		inst:DoTaskInTime(0, InitializePathFinding)
		
		inst.OnRemoveEntity = OnRemove
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("combat")
		inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
		inst.components.combat.onhitfn = OnHit
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(data.maxhealth)
		inst.components.health:SetCurrentHealth(data.maxhealth * 0.5)
		inst.components.health.ondelta = OnHealthChange
		inst.components.health.nofadeout = true
		inst.components.health.canheal = false
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("lootdropper")
		
		inst:AddComponent("repairable")
		inst.components.repairable.repairmaterial = data.material
		inst.components.repairable.onrepaired = OnRepaired
		inst.components.repairable.testvalidrepairfn = ValidRepairFn
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(data.maxwork or 3)
		inst.components.workable:SetOnFinishCallback(OnHammered)
		inst.components.workable:SetOnWorkCallback(OnHit)
		
		if data.polar then
			inst:AddComponent("polarmistemitter")
			inst.components.polarmistemitter:StartMisting()
			inst.components.polarmistemitter.scale = GetPolarMistMult
			inst.components.polarmistemitter.maxmist = 4
			
			inst.OnEntitySleep = OnEntitySleep
			inst.OnEntityWake = OnEntityWake
		end
		
		if data.flammable then
			MakeMediumBurnable(inst)
			MakeLargePropagator(inst)
			inst.components.burnable.flammability = 0.5
			inst.components.burnable.nocharring = true
		end
		
		MakeHauntableWork(inst)
		
		inst.OnSave = OnSave
		inst.OnLoad = OnLoad
		
		if data.onattacked then
			inst:ListenForEvent("attacked", data.onattacked)
		end
		
		return inst
	end
	
	return Prefab("wall_"..data.name, fn, assets, prefabs),
		Prefab("wall_"..data.name.."_item", itemfn, assets, {"wall_"..data.name, "wall_"..data.name.."_item_placer"}),
		MakePlacer("wall_"..data.name.."_item_placer", "wall", "wall_"..data.name, "half", false, false, true, nil, nil, "eight")
end

local wallprefabs = {}

local walldata = {
	{
		name = "polar",
		material = MATERIALS.DRYICE,
		buildsound = "dontstarve_DLC001/common/iceboulder_hit",
		hitsound = "dontstarve_DLC001/common/iceboulder_smash",
		tags = {"stone"},
		loot = "ice",
		maxloots = 2,
		maxhealth = TUNING.POLARWALL_HEALTH,
		polar = true,
		onattacked = OnAttacked,
	},
}

for i, v in ipairs(walldata) do
	local wall, item, placer = MakeWallType(v)
	
	table.insert(wallprefabs, wall)
	table.insert(wallprefabs, item)
	table.insert(wallprefabs, placer)
end

return unpack(wallprefabs)