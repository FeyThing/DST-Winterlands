local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local ponds = {
	"pond",
	"pond_mos",
}

local DespawnPlants
local OldOnSnowLevel

local function DoPolarIcePlow(inst, plow)
	if inst.components.timer == nil then
		inst:AddComponent("timer")
	end
	if not inst.components.timer:TimerExists("polarice_plow_pond") then
		inst.components.timer:StartTimer("polarice_plow_pond", TUNING.POLARICE_PLOW_PONDTIME)
	end
	
	if OldOnSnowLevel then
		OldOnSnowLevel(inst, 0)
	end
end

local function SetPolarPond(inst)
	local inpolar = IsInPolar(inst)
	
	if inpolar and not inst._polarpond then
		if OldOnSnowLevel then
			OldOnSnowLevel(inst, 1)
		end
	elseif not inpolar and inst._polarpond then
		if OldOnSnowLevel then
			OldOnSnowLevel(inst, TheWorld.state.snowlevel)
		end
	end
	
	inst._polarpond = inpolar or nil
end

local function OnSnowLevel(inst, snowlevel, ...)
	if inst._polarpond or (inst.components.timer and inst.components.timer:TimerExists("polarice_plow_pond") and snowlevel > 0.02) then
		return
	end
	
	if OldOnSnowLevel then
		OldOnSnowLevel(inst, snowlevel, ...)
	end
end

local function PolarInit(inst)
	if inst.worldstatewatching and inst.worldstatewatching["snowlevel"] then
		for i, v in ipairs(inst.worldstatewatching["snowlevel"]) do
			DespawnPlants = PolarUpvalue(v, "DespawnPlants")
			
			if DespawnPlants then
				if OldOnSnowLevel == nil then
					OldOnSnowLevel = inst.worldstatewatching["snowlevel"][i]
				end
				inst:StopWatchingWorldState("snowlevel", OldOnSnowLevel)
				inst:WatchWorldState("snowlevel", OnSnowLevel)
				
				break
			end
		end
	end
	
	inst:SetPolarPond()
end

for i, prefab in ipairs(ponds) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("ignoremouseover") -- So we can place the ice demoleisher...
		inst:AddTag("snowblocker")
		
		inst._snowblockrange = net_smallbyte(inst.GUID, prefab.."._snowblockrange")
		inst._snowblockrange:set(5)
		
		if not TheWorld.ismastersim then
			return
		end
		
		inst.DoPolarIcePlow = DoPolarIcePlow
		inst.SetPolarPond = SetPolarPond
		
		inst:DoTaskInTime(0, PolarInit)
	end)
end