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

--[[Constant lower temperature

\frac{x+31}{\left(a+1\right)-ac}-31\left\{-31\le x\le100\right\}
a = 0 | 0 <=a <= 10, S: 0.5
c = 0 | 0 <=a <= 1, S: 0.05

local pt = ThePlayer:GetPosition() print(GetTemperatureAtXZ(pt.x, pt.z))]]

local MIN_TEMPERATURE = -31

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

--	Always covered in snow, always no grow in winter...

local OldMakeSnowCovered = MakeSnowCovered -- Also see worldstate postinit
function MakeSnowCovered(inst, ...)
	OldMakeSnowCovered(inst, ...)
	SetPolarComponentsUpdates(inst, POPULATING)
end

local OldMakeNoGrowInWinter = MakeNoGrowInWinter
function MakeNoGrowInWinter(inst, ...)
	if not inst:HasTag("canpolargrow") and (inst.components.growable or inst.components.pickable) then
		inst.pause_grow_in_polar = true
	end
	
	OldMakeNoGrowInWinter(inst, ...)
	SetPolarComponentsUpdates(inst, POPULATING)
end

--	Ice Cave sheltering

local SHADE_ICECAVE_TAGS = {"icecaveshelter"}

function IsUnderIceCaveAtXZ(x, z)
	if #TheSim:FindEntities(x, 0, z, TUNING.SHADE_POLAR_RANGE, SHADE_ICECAVE_TAGS) > 0 then
		return true
	end
end

local OldIsUnderRainDomeAtXZ = IsUnderRainDomeAtXZ
function IsUnderRainDomeAtXZ(x, z, ...)
	if IsUnderIceCaveAtXZ(x, z) then
		return true -- Stops lunar hail
	end
	
	return OldIsUnderRainDomeAtXZ(x, z, ...)
end

--	Sneazy speech from Frozen Wetness

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
local getcharacterstring = PolarUpvalue(GetDescription_AddSpecialCases, "getcharacterstring")
function GetDescription_AddSpecialCases(ret, charactertable, inst, item, modifier, ...)
	local _getcharacterstring = getcharacterstring
	
	if inst and type(inst) == "table" then
		ret = PolarifySpeech(ret, inst)
	end
	
	return OldSpecialCases(ret, charactertable, inst, item, modifier, ...)
end

--	Hide small things in High Snow

function IsTooDeepInSnow(inst, viewer)
	local insnow = false
	
	viewer = viewer or ThePlayer
	
	if TUNING.POLAR_WAVES_ENABLED and inst:IsValid() and not inst:IsInLimbo() and inst.Transform and inst.AnimState then
		local x, y, z = inst.Transform:GetWorldPosition()
		
		insnow = TheWorld.Map:IsPolarSnowAtPoint(x, 0, z, true) and not TheWorld.Map:IsPolarSnowBlocked(x, 0, z)
		
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

--	Misc

local PENGUIN_ICE_TAGS = {"slipperyfeettarget"}

local OldPlayFootstep = PlayFootstep
function PlayFootstep(inst, volume, ispredicted, ...)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if inst.components.polarwalker and TUNING.POLAR_WAVES_ENABLED then
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
	
	local penguin_ice = FindEntity(inst, 12, function(target)
		return target.components.slipperyfeettarget and target.components.slipperyfeettarget:IsSlipperyAtPosition(x, y, z)
	end, PENGUIN_ICE_TAGS)
	
	if inst._polarbear_rug then
		inst.SoundEmitter:PlaySound("dontstarve/movement/"..(inst.sg and inst.sg:HasStateTag("running") and "run" or "walk").."_carpet")
		volume = 0
	elseif penguin_ice then
		inst.SoundEmitter:PlaySound("dontstarve/movement/"..(inst.sg and inst.sg:HasStateTag("running") and "run" or "walk").."_iceslab")
		volume = 0
	end
	
	OldPlayFootstep(inst, volume, ispredicted, ...)
end

require("ocean_util")

local OldSinkEntity = SinkEntity
function SinkEntity(inst, ...)
	local dryice_sinking = inst:HasTag("dryice")
	if dryice_sinking then
		inst:AddTag("dryice_sunk") -- polarmistemitter spawns a ring of mist when dry ice sinks
	end
	
	OldSinkEntity(inst, ...)
end