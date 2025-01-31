function PolarUpvalue(fn, upvalue_name, set_upvalue)
	if fn == nil or upvalue_name == nil then
		return
	end
	
	local i = 1
	while true do
		local val, v = debug.getupvalue(fn, i)
		
		if not val then
			break
		end
		if val == upvalue_name then
			if set_upvalue then
				debug.setupvalue(fn, i, set_upvalue)
			end
			
			return v, i
		end
		i = i + 1
	end
end

local WINTERLANDS_MOD_ID = "workshop-3383047161"

function ChangePolarConfigs(config, value)
	local configs = KnownModIndex:LoadModConfigurationOptions(WINTERLANDS_MOD_ID, false)
	
	if configs then
		for i, v in ipairs(configs) do
			if v.name == config then
				v.saved = value
				print("Changed "..config.." to "..value)
			end
		end
	end
	
	KnownModIndex:SaveConfigurationOptions(function() end, WINTERLANDS_MOD_ID, configs, false)
end

--	Constant lower temperature

-- Testing
-- \frac{x+31}{\left(a+1\right)-ac}-31\left\{-31\le x\le100\right\}
-- a = 0 | 0 <=a <= 10, S: 0.5
-- c = 0 | 0 <=a <= 1, S: 0.05

-- local x, y, z = ThePlayer.Transform:GetWorldPosition() print(GetTemperatureAtXZ(x, z))
-- Testing

local MIN_TEMPERATURE = -31
-- local MAX_TEMPERATURE = 100
function GetPolarTemperature(temperature, x, z)
	if TheWorld.components.polartemperature_manager then
		local dist_factor = 1 - TheWorld.components.polartemperature_manager:GetDataAtPoint(x, 0, z)
		temperature = (temperature - MIN_TEMPERATURE) / (3.5 - 2.5 * dist_factor) + MIN_TEMPERATURE
	end

	return temperature
end

local OldGetTemperatureAtXZ = GetTemperatureAtXZ
function GetTemperatureAtXZ(x, z, ...)
	local temperature = OldGetTemperatureAtXZ(x, z, ...)
	
	return GetPolarTemperature(temperature, x, z)
end

--	We keep snow on things here, and thicken it

local OldMakeSnowCovered = MakeSnowCovered
function MakeSnowCovered(inst, ...)
	OldMakeSnowCovered(inst, ...)
	
	local load_polar = inst.polar_toggle == nil
	if load_polar then
		inst.polar_toggle = function() OnPolarCover(inst, load_polar) end
		inst:ListenForEvent("phasechanged", inst.polar_toggle, TheWorld)
		inst:DoTaskInTime(0, inst.polar_toggle)
	end
end

--	Most growable and pickable plants are paused

local OldMakeNoGrowInWinter = MakeNoGrowInWinter
function MakeNoGrowInWinter(inst, ...)
	OldMakeNoGrowInWinter(inst, ...)
	if not inst:HasTag("canpolargrow") and inst.components.pickable then
		inst.pause_grow_in_polar = true
	end
	
	local load_polar = inst.polar_toggle == nil
	if load_polar then
		inst.polar_toggle = function() OnPolarCover(inst, load_polar) end
		inst:ListenForEvent("phasechanged", inst.polar_toggle, TheWorld)
		inst:DoTaskInTime(0, inst.polar_toggle)
	end
end

--	Add buff from eating Ice Lettuce things

function EatIceLettuce(inst, eater, duration, freeziness, temperature)
	if freeziness and eater.components.freezable then
		eater.components.freezable:AddColdness(freeziness)
	end
	
	if temperature and eater.components.temperature and eater.components.temperature.current then
		eater.components.temperature:SetTemperature(eater.components.temperature.current + temperature)
	end
	
	if eater.components.debuffable == nil then
		eater:AddComponent("debuffable")
	end
	
	if not duration then
		return
	end
	
	local buff = eater.components.debuffable:GetDebuff("buff_polarimmunity") or eater.components.debuffable:AddDebuff("buff_polarimmunity", "buff_polarimmunity")
	local timeleft = (buff and buff.components.timer) and buff.components.timer:GetTimeLeft("buffover") or nil
	
	if timeleft and duration and duration > timeleft then
		buff.components.timer:SetTimeLeft("buffover", duration)
	end
	
	return buff
end

--	Descs get sneazy while having the snow debuff

function PolarifySpeech(ret, inst)
	local ret_poses = {}
	
	if inst:HasTag("soulless") or ret == nil then
		return ret
	end
	
	if type(inst) == "table" then
		local polar_level = GetPolarWetness(inst)
		if math.random() < (TUNING.POLAR_WETNESS_SNIFFNESS * polar_level) then
			for i = 1, #ret do
				local c = ret:sub(i, i)
				if c == " " then
					table.insert(ret_poses, i)
				end
			end
		end
	end
	
	if #ret_poses > 0 then
		local ret_pos = ret_poses[math.random(#ret_poses)]
		local ret_snuff = STRINGS.POLARCOLD_SNUFFING[math.random(#STRINGS.POLARCOLD_SNUFFING)]
		
		if not inst:HasTag("player") then
			ret_snuff = string.upper(ret_snuff)
		end
		
		ret = ret:sub(1, ret_pos)..ret_snuff..ret:sub(ret_pos + 1)
	end
	
	return ret
end

local OldSpecialCases = GetDescription_AddSpecialCases
function GetDescription_AddSpecialCases(ret, charactertable, inst, item, modifier, ...)
	if inst and type(inst) == "table" then
		ret = PolarifySpeech(ret, inst)
	end
	
	return OldSpecialCases(ret, charactertable, inst, item, modifier, ...)
end

--	Can't see the name of things in snow, unless it's tall enough or we get close

function IsTooDeepInSnow(inst, viewer)
	local insnow = false
	
	viewer = viewer or ThePlayer
	
	if TUNING.POLAR_WAVES_ENABLED and inst:IsValid() and not inst:IsInLimbo() and inst.Transform and inst.AnimState then
		local x, y, z = inst.Transform:GetWorldPosition()
		local temperature = TheWorld.state.temperature
		
		insnow = TheWorld.Map:IsPolarSnowAtPoint(x, 0, z, true) and not TheWorld.Map:IsPolarSnowBlocked(x, 0, z)
			and temperature and temperature < TUNING.POLAR_SNOW_MELT_TEMP
		
		if insnow and not inst:HasTag("snowhidden") then
			local bbx1, bby1, bbx2, bby2 = inst.AnimState:GetVisualBB()
			local bby = bby2 - bby1
			
			insnow = bby < 2
		end
	end
	
	return insnow and (viewer == nil or viewer:GetDistanceSqToInst(inst) > TUNING.DEEP_IN_SNOW_PLAYERDIST)
end

local OldGetDisplayName = EntityScript.GetDisplayName
function EntityScript:GetDisplayName(...)
	return IsTooDeepInSnow(self, ThePlayer) and STRINGS.NAMES.IN_POLARSNOW or OldGetDisplayName(self, ...)
end

--	Ice Cave protects from rain (this is more for the Lunar Hail than anything)
local SHADE_ICECAVE_TAGS = {"icecaveshelter"}

local OldIsUnderRainDomeAtXZ = IsUnderRainDomeAtXZ
function IsUnderRainDomeAtXZ(x, z, ...)
	if #TheSim:FindEntities(x, 0, z, TUNING.SHADE_POLAR_RANGE, SHADE_ICECAVE_TAGS) > 0 then
		return true
	end
	
	return OldIsUnderRainDomeAtXZ(x, z, ...)
end

--	Dryice leaves a big cloud when it sinks
require("ocean_util")

local OldSinkEntity = SinkEntity
function SinkEntity(inst, ...)
	OldSinkEntity(inst, ...)
	
	if inst:HasTag("dryice") then
		local pt = inst:GetPosition()
		
		for i = 1, 16 do
			local offset = FindWalkableOffset(pt, math.random() * TWOPI, 0.2, 12, false, true, nil, true, true)
			
			if offset then
				local mist = SpawnPrefab("polar_mist")
				mist.Transform:SetPosition((pt + offset):Get())
				mist:SetEmitter(inst, 2, 0.5 * math.random())
			end
		end
	end
end

--	Spawning FXs as we walk in high snow

local OldPlayFootstep = PlayFootstep
function PlayFootstep(inst, volume, ispredicted, ...)
	if inst.components.polarwalker and TUNING.POLAR_WAVES_ENABLED then
		local x, y, z = inst.Transform:GetWorldPosition()
		
		if TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true) and not TheWorld.Map:IsPolarSnowBlocked(x, y, z)
			and (TheWorld.state.temperature or 0) <= TUNING.POLAR_SNOW_MELT_TEMP then
			local splash_fx = (inst:HasTag("epic") and inst:HasTag("largecreature")) and "polar_splash_epic"
				or (inst:HasTag("epic") or inst:HasTag("largecreature")) and "polar_splash_large"
				or "polar_splash"
			
			local fx = SpawnPrefab(splash_fx)
			if not inst:HasTag("character") then
				fx.entity:SetParent(inst.entity)
			else
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
			end
		end
	end
	
	OldPlayFootstep(inst, volume, ispredicted, ...)
end