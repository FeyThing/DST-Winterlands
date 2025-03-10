local ENV = env
GLOBAL.setfenv(1, GLOBAL)

--	Note:	Does your Thermal Stone suck now?
--			It's normal! This file doesn't contain all the changes for it, it's getting nerfed from components/temperature tweaks and blizzard effect :p
--			Here we are just keeping it on "Winter mode" inside of the biome.

local OldHeatFn
local function HeatFn(inst, observer, ...)
	local test
	
	if OldHeatFn then
		test = OldHeatFn(inst, observer, ...)
	end
	
	if inst.inpolar then
		inst.components.heater:SetThermics(true, false)
	end
	
	return test
end

local OldHeatCarriedFn
local function HeatCarriedFn(inst, observer, ...)
	local test
	
	if OldHeatCarriedFn then
		test = OldHeatCarriedFn(inst, observer, ...)
	end
	
	if inst.inpolar then
		inst.components.heater:SetThermics(true, false)
	end
	
	return test
end

--

local AdjustLighting
local GetRangeForTemperature
local UpdateImages

local OldTemperatureDelta
local function PolarTemperatureDelta(inst, data, ...)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if inst.inpolar then
		local ambient_temp = GetTemperatureAtXZ(x, z)
		local cur_temp = inst.components.temperature:GetCurrent()
		local range = GetRangeForTemperature(cur_temp, ambient_temp)
		
		if AdjustLighting then
			AdjustLighting(inst, range, ambient_temp)
		end
		
		if inst.highTemp == nil or inst.highTemp < cur_temp then
			inst.highTemp = math.ceil(cur_temp)
		end
		inst.lowTemp = nil
		
		if range ~= inst.currentTempRange then
			if UpdateImages then
				UpdateImages(inst, range)
			end
			
			if (inst.lowTemp ~= nil and range >= 3) or
				(inst.highTemp ~= nil and range <= 3) then
				inst.lowTemp = nil
				inst.highTemp = nil
				inst.components.fueled:SetPercent(inst.components.fueled:GetPercent() - 1 / TUNING.HEATROCK_NUMUSES)
			end
		end
		
	else
		OldTemperatureDelta(inst, data, ...)
	end
end

--	Toggle winter mode every now and then, live update at each game tick is expensive

local function UpdateInPolar(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	inst.inpolar = GetClosestPolarTileToPoint(x, 0, z, 4) ~= nil
end

local OldOnEntitySleep
local function OnEntitySleep(inst, ...)
	if inst._polarupdate then
		inst._polarupdate:Cancel()
		inst._polarupdate = nil
	end
	
	if OldOnEntitySleep then
		OldOnEntitySleep(inst, ...)
	end
end

local OldOnEntityWake
local function OnEntityWake(inst, ...)
	if inst._polarupdate == nil then
		inst._polarupdate = inst:DoPeriodicTask(10 + math.random(), inst.UpdateInPolar)
	end
	
	if OldOnEntityWake then
		OldOnEntityWake(inst, ...)
	end
end

--

ENV.AddPrefabPostInit("heatrock", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.temperature then
		if OldHeatFn == nil then
			OldHeatFn = inst.components.heater.heatfn
			OldHeatCarriedFn = inst.components.heater.carriedheatfn
		end
		
		inst.components.heater.heatfn = HeatFn
		inst.components.heater.carriedheatfn = HeatCarriedFn
	end
	
	if OldTemperatureDelta == nil and inst.event_listeners and inst.event_listeners.temperaturedelta and inst.event_listeners.temperaturedelta[inst] then
		OldTemperatureDelta = inst.event_listeners.temperaturedelta[inst][1]
		
		AdjustLighting = PolarUpvalue(OldTemperatureDelta, "AdjustLighting")
		GetRangeForTemperature = PolarUpvalue(OldTemperatureDelta, "GetRangeForTemperature")
		UpdateImages = PolarUpvalue(OldTemperatureDelta, "UpdateImages")
	end
	
	if OldTemperatureDelta and GetRangeForTemperature then
		inst.event_listeners.temperaturedelta[inst][1] = function(inst, data, ...)
			PolarTemperatureDelta(inst, data, ...)
		end
	end
	
	--
	
	inst.UpdateInPolar = UpdateInPolar
	
	if OldOnEntitySleep == nil then
		OldOnEntitySleep = inst.OnEntitySleep
	end
	inst.OnEntitySleep = OnEntitySleep
	
	if OldOnEntityWake == nil then
		OldOnEntityWake = inst.OnEntityWake
	end
	inst.OnEntityWake = OnEntityWake
end)