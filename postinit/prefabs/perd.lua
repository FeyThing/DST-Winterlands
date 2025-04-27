local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local HIGH_SNOW_TAGS = {"snowitemrespawner"}

local function FindHighSnow(inst)
	if inst.components.homeseeker == nil then
		return
	end
	
	local home = inst.components.homeseeker.home
	local temperature = TheWorld.state.temperature
	
	if not (temperature and temperature >= TUNING.POLAR_SNOW_MELT_TEMP) and home == nil or not home:IsValid() or inst:GetDistanceSqToInst(home) > 200 then
		local snow = FindEntity(inst, 40, function(ent)
			local pt = ent:GetPosition()
			
			return TheWorld.Map:IsPolarSnowAtPoint(pt.x, 0, pt.z, true) and not TheWorld.Map:IsPolarSnowBlocked(pt.x, 0, pt.z)
		end, HIGH_SNOW_TAGS)
		
		if snow then
			inst.components.homeseeker:SetHome(snow)
		end
	end
end

local function BecomePolarPerd(inst, force)
	local x, y, z = inst.Transform:GetWorldPosition()
	if force ~= nil then
		inst.polar_perd = force
	elseif inst.polar_perd == nil then
		inst.polar_perd = GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil
	end
	
	if inst.polar_perd then
		inst.AnimState:SetSymbolHue("perd_tail", 0.5)
		inst.AnimState:SetSymbolMultColour("pig_arm", 0.4, 0.6, 1, 1)
		inst.AnimState:SetSymbolMultColour("pig_torso", 0.4, 0.6, 1, 1)
		inst.AnimState:SetSymbolMultColour("pig_leg", 0.8, 0.4, 0.4, 1)
	else
		inst.AnimState:SetSymbolHue("perd_tail", 1)
		inst.AnimState:SetSymbolMultColour("pig_arm", 1, 1, 1, 1)
		inst.AnimState:SetSymbolMultColour("pig_leg", 1, 1, 1, 1)
		inst.AnimState:SetSymbolMultColour("pig_torso", 1, 1, 1, 1)
	end
end

local OldOnSave
local function OnSave(inst, data, ...)
	if OldOnSave then
		OldOnSave(inst, data, ...)
	end
	if inst.polar_perd then
		data.polar_perd = true
	end
end

local OldOnLoad
local function OnLoad(inst, data, ...)
	if OldOnLoad then
		OldOnLoad(inst, data, ...)
	end
	
	inst.polar_perd = data and data.polar_perd or false
end

ENV.AddPrefabPostInit("perd", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if not OldOnSave then
		OldOnSave = inst.OnSave
	end
	inst.OnSave = OnSave
	
	if not OldOnLoad then
		OldOnLoad = inst.OnLoad
	end
	inst.OnLoad = OnLoad
	
	inst.BecomePolarPerd = BecomePolarPerd
	inst.FindHighSnow = FindHighSnow
	
	inst:DoTaskInTime(0, inst.BecomePolarPerd)
	inst.find_highsnow = inst:DoPeriodicTask(1, inst.FindHighSnow, 3)
end)