local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BLIZZARED_FIRES = {
	campfire = TUNING.POLAR_STORM_FUELEDMULT.CAMPFIRE,
	cotl_tabernacle_level1 = TUNING.POLAR_STORM_FUELEDMULT.CAMPFIRE,
	cotl_tabernacle_level2 = TUNING.POLAR_STORM_FUELEDMULT.FIREPIT,
	cotl_tabernacle_level3 = TUNING.POLAR_STORM_FUELEDMULT.RESISTANT,
	firepit = TUNING.POLAR_STORM_FUELEDMULT.FIREPIT,
	torch = TUNING.POLAR_STORM_FUELEDMULT.TORCH,
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

for prefab, mult in pairs(BLIZZARED_FIRES) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst.polarstorm_fuelmod = mult
		inst.onpolarstormchanged = function(src, data)
			if data and data.stormtype == STORM_TYPES.POLARSTORM then
				OnPolarstormChanged(inst, data.setting)
			end
		end
		
		inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
		if TheWorld.components.polarstorm then
			OnPolarstormChanged(inst, TheWorld.components.polarstorm:IsPolarStormActive())
		end
	end)
end