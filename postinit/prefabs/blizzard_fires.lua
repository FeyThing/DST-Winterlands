local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local FUELMULT = TUNING.POLAR_STORM_FUELEDMULT
local PROTECTION = TUNING.POLAR_STORM_PROTECTION

local BLIZZARED_FIRES = {
	campfire = 					{fuel_rate = FUELMULT.CAMPFIRE},
	cotl_tabernacle_level1 = 	{fuel_rate = FUELMULT.CAMPFIRE},
	cotl_tabernacle_level2 = 	{fuel_rate = FUELMULT.FIREPIT},
	cotl_tabernacle_level3 = 	{fuel_rate = FUELMULT.FIREPIT},
	firepit = 					{fuel_rate = FUELMULT.FIREPIT},
	torch = 					{fuel_rate = FUELMULT.TORCH},
	--
	campfirefire = 				{prot_range = PROTECTION.CAMPFIRE},
	character_fire = 			{prot_range = PROTECTION.FIRE},
	fire = 						{prot_range = PROTECTION.FIRE},
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

for prefab, blizzard_data in pairs(BLIZZARED_FIRES) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if blizzard_data.prot_range then
			inst:AddTag("blizzardprotection")
			
			inst.blizzardprotect_rad = blizzard_data.prot_range
		end
		
		if not TheWorld.ismastersim then
			return
		end
		
		if blizzard_data.fuel_rate then
			inst.polarstorm_fuelmod = blizzard_data.fuel_rate
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
	end)
end