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

--	Constant lower temperature

local OldGetTemperatureAtXZ = GetTemperatureAtXZ
function GetTemperatureAtXZ(x, z, ...)
	local temperature = OldGetTemperatureAtXZ(x, z, ...)
	
	if IsInPolarAtPoint(x, 0, z) then
		temperature = temperature + (TheWorld.state.iscavenight and TUNING.POLAR_TEMPERATURES["night"]
			or TheWorld.state.iscavedusk and TUNING.POLAR_TEMPERATURES["dusk"]
			or TUNING.POLAR_TEMPERATURES["day"])
	elseif TheWorld.Map:GetTileAtPoint(x, 0, z) == WORLD_TILES.POLAR_DRYICE then
		temperature = temperature + TUNING.POLAR_TEMPERATURES["ice"]
	end
	
	return temperature
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
		inst.components.pickable.pause_in_polar = true
	end
	
	local load_polar = inst.polar_toggle == nil
	if load_polar then
		inst.polar_toggle = function() OnPolarCover(inst, load_polar) end
		inst:ListenForEvent("phasechanged", inst.polar_toggle, TheWorld)
		inst:DoTaskInTime(0, inst.polar_toggle)
	end
end

--	Descs get sneazy while having the snow debuff

function PolarifySpeech(ret, inst)
	local ret_poses = {}
	
	if inst:HasTag("soulless") or ret == nil then
		return ret
	end
	
	if type(inst) == "table" then
		local polar_level = GetPolarWetness(inst)
		if math.random() < (TUNING.POLARWETNESS_SNIFFNESS * polar_level) then
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
	ret = PolarifySpeech(ret, inst)
	
	return OldSpecialCases(ret, charactertable, inst, item, modifier, ...)
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
	if inst.components.polarwalker then
		local slowed, slowing = inst.components.polarwalker:IsPolarSlowed()
		
		if slowing then
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