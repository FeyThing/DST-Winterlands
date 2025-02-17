local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local updatelevel

local oldsetlevel
local function setlevel(inst, level, dotransition, ...)
	if oldsetlevel then
		oldsetlevel(inst, level, dotransition, ...)
	end
	
	if not IsInPolar(inst) or inst:HasTag("burnt") then
		return
	end
	
	if inst.components.harvestable and inst.components.harvestable:CanBeHarvested() then
		for i = 1, inst.components.harvestable.produce do
			inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
		end
		
		inst.components.harvestable.produce = 0
		inst.components.harvestable:StopGrowing()
		inst.remainingharvests = inst.remainingharvests - 1
	end
	
	if inst.components.trader then
		inst.components.trader:Disable()
	end
end

local OldGetStatus
local function GetStatus(inst, ...)
	if inst.components.harvestable and inst.remainingharvests and inst.remainingharvests > 0 then
		if IsInPolar(inst) then
			return "SNOWCOVERED" -- TODO: White cave shroom will still have produce status!
		end
	end
	
	if OldGetStatus then
		return OldGetStatus(inst, ...)
	end
end

local function PolarInit(inst)
	if updatelevel and IsInPolar(inst) then
		updatelevel(inst, false)
	end
end

ENV.AddPrefabPostInit("mushroom_farm", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if oldsetlevel == nil and inst.components.harvestable then
		updatelevel = PolarUpvalue(inst.components.harvestable.onharvestfn, "updatelevel")
		oldsetlevel = PolarUpvalue(updatelevel, "setlevel")
		PolarUpvalue(updatelevel, "setlevel", setlevel)
	end
	
	if inst.components.inspectable then
		if OldGetStatus == nil then
			OldGetStatus = inst.components.inspectable.getstatus
		end
		inst.components.inspectable.getstatus = GetStatus
	end
	
	inst:DoTaskInTime(0, PolarInit)
end)