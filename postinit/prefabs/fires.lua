local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local FUELMULT = TUNING.POLAR_STORM_FUELEDMULT
local PROTECTION = TUNING.POLAR_STORM_PROTECTION

--[[
	fuel_rate: Fueled fires should deplace faster in blizzard
	prot_range: Range of safety of blizzard, for all hot flames (not u, torch)
	snow_melt: To be given to big flames, this prevents snow from returning too soon by laying snowwave_blockers behind
--]]

local FIRES = {
	campfire = 					{fuel_rate = FUELMULT.CAMPFIRE},
	cotl_tabernacle_level1 = 	{fuel_rate = FUELMULT.CAMPFIRE},
	cotl_tabernacle_level2 = 	{fuel_rate = FUELMULT.FIREPIT},
	cotl_tabernacle_level3 = 	{fuel_rate = FUELMULT.FIREPIT},
	firepit = 					{fuel_rate = FUELMULT.FIREPIT},
	torch = 					{fuel_rate = FUELMULT.TORCH},
	--
	campfirefire = 				{prot_range = PROTECTION.CAMPFIRE, 	snow_melt = true},
	character_fire = 			{prot_range = PROTECTION.FIRE, 		snow_melt = true},
	fire = 						{prot_range = PROTECTION.FIRE, 		snow_melt = true},
	torchfire = 				{prot_range = PROTECTION.TORCH},
}

local function SetPolarstormRate(inst)
	if inst.components.fueled then
		if TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
			inst.components.fueled.rate_modifiers:SetModifier(inst, inst.polarstorm_fuelmod or 1, "polarstorm")
		else
			inst.components.fueled.rate_modifiers:RemoveModifier(inst, "polarstorm")
		end
	end
end

local function OnPolarstormChanged(inst, active)
	if active then
		if inst._update_polarstorm_rate == nil then
			inst._update_polarstorm_rate = inst:DoPeriodicTask(1, SetPolarstormRate)
		end
	elseif inst._update_polarstorm_rate then
		inst._update_polarstorm_rate:Cancel()
		inst._update_polarstorm_rate = nil
	end
end

for prefab, data in pairs(FIRES) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if data.prot_range then
			inst:AddTag("blizzardprotection")
			
			inst.blizzardprotect_rad = data.prot_range
		end
		
		if not TheWorld.ismastersim then
			return
		end
		
		if data.fuel_rate then
			inst.polarstorm_fuelmod = data.fuel_rate
			inst.onpolarstormchanged = function(src, data)
				if data and data.stormtype == STORM_TYPES.POLARSTORM then
					OnPolarstormChanged(inst, data.setting)
				end
			end
			
			inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
			if TheWorld.components.polarstorm then
				OnPolarstormChanged(inst, TheWorld.components.polarstorm:IsPolarStormActive())
			end
		end
		
		if data.snow_melt and inst.components.snowwavemelter == nil then
			inst:AddComponent("snowwavemelter")
			inst.components.snowwavemelter:StartMelting()
		end
	end)
end