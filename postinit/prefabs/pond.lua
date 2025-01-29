local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local ponds = {
	"pond",
	"pond_mos",
}

local DespawnPlants
local OldOnSnowLevel

local OldCanSpawn
local function CanSpawn(inst, ...)
	if IsInPolar(inst) then
		return false
	end
	
	if OldCanSpawn then
		return OldCanSpawn(inst, ...)
	end
	
	return true
end

local function DoPolarIcePlow(inst, plow)
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

local OldCanMouseThrough
local function CanMouseThrough(inst, ...)
	if ThePlayer and ThePlayer.components.playeractionpicker and ThePlayer.components.playercontroller then
		local lmb, rmb = ThePlayer.components.playeractionpicker:DoGetMouseActions(inst:GetPosition(), inst)
		local deployplacer = ThePlayer.components.playercontroller.deployplacer
		
		if lmb == nil and rmb == nil and deployplacer and deployplacer.prefab == "polarice_plow_item_placer" then
			return true, true
		end
	end
	
	return OldCanMouseThrough and OldCanMouseThrough(inst, ...) or false
end

for i, prefab in ipairs(ponds) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		inst:AddTag("snowblocker")
		
		if OldCanMouseThrough == nil then
			OldCanMouseThrough = inst.CanMouseThrough
		end
		inst.CanMouseThrough = CanMouseThrough
		
		inst._snowblockrange = net_smallbyte(inst.GUID, prefab.."._snowblockrange")
		inst._snowblockrange:set(5)
		
		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.childspawner then
			if OldCanSpawn == nil then
				OldCanSpawn = inst.components.childspawner.canspawnfn
			end
			inst.components.childspawner.canspawnfn = CanSpawn
		end
		
		if inst.components.timer == nil then
			inst:AddComponent("timer")
		end
		
		inst.DoPolarIcePlow = DoPolarIcePlow
		inst.SetPolarPond = SetPolarPond
		
		inst:DoTaskInTime(0.1, PolarInit)
	end)
end