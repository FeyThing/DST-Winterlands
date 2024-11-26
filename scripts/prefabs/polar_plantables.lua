require "prefabutil"

local WAXED_PLANTS = require "prefabs/waxed_plant_common"

local function make_plantable(data)
	local build = data.name
	local assets = {
		Asset("ANIM", "anim/"..build..".zip"),
	}
	
	local function OnDeploy(inst, pt, deployer)
		local tree = SpawnPrefab(data.name)
		if tree ~= nil then
			tree.Transform:SetPosition(pt:Get())
			inst.components.stackable:Get():Remove()
			if tree.components.pickable ~= nil then
				tree.components.pickable:OnTransplant()
			end
			if deployer ~= nil and deployer.SoundEmitter ~= nil then
				deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
			end
		end
	end
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst:AddTag("deployedplant")
		inst:AddTag("donotautopick")
		
		inst.AnimState:SetBank(data.bank or data.name)
		inst.AnimState:SetBuild(data.name)
		inst.AnimState:PlayAnimation(data.shop and "sapling" or "dropped")
		
		MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		if data.bank ~= nil then
			inst:SetPrefabNameOverride(data.bank)
		end
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")
		
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
		
		inst:AddComponent("deployable")
		inst.components.deployable.ondeploy = OnDeploy
		inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
		
		MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
		MakeSmallPropagator(inst)
		
		MakeHauntableLaunchAndIgnite(inst)
		
		return inst
	end
	
	return Prefab("dug_"..data.name, fn, assets)
end

local plantables = {
	{
		name = "grass_polar",
		bank = "grass_polar",
		floater = {"med", 0.1, 1.3},
		waxable = true,
	},
}

local prefabs = {}

for i, v in ipairs(plantables) do
	table.insert(prefabs, make_plantable(v))
	table.insert(prefabs, MakePlacer(v.shop and v.name.."_sapling_placer" or "dug_"..v.name.."_placer", v.bank or v.name, v.build or v.name, v.anim or "idle"))
	
	if v.waxable then
		table.insert(prefabs, WAXED_PLANTS.CreateDugWaxedPlant(v))
	end
end

return unpack(prefabs)