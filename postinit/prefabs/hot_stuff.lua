local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local FUELMULT = TUNING.POLAR_STORM_FUELEDMULT
local PROTECTION = TUNING.POLAR_STORM_PROTECTION

--[[
	fuel_rate: 	Fueled fires should deplace faster in blizzard
	prot_range: Range of protection from the blizzard. To be given to actual hot flames
	snow_block:	Prevents immediate snow around
	snow_melt: 	Keep snow away for a little longer after we're gone
--]]

local FIRES = {
	--	Fire sources
	campfire = 					{fuel_rate = FUELMULT.CAMPFIRE},
	cotl_tabernacle_level1 = 	{fuel_rate = FUELMULT.CAMPFIRE},
	cotl_tabernacle_level2 = 	{fuel_rate = FUELMULT.FIREPIT},
	cotl_tabernacle_level3 = 	{fuel_rate = FUELMULT.FIREPIT},
	firepit = 					{fuel_rate = FUELMULT.FIREPIT},
	torch = 					{fuel_rate = FUELMULT.TORCH},
	lighter = 					{fuel_rate = FUELMULT.TORCH},
	
	--	Super hot
	emberlight = 				{prot_range = PROTECTION.FIRE, 		snow_block = 7, 	snow_melt = true},
	dragonflyfurnace = 			{snow_block = 6},
	lava_pond = 				{snow_block = 6},
	lavae_pet = 				{prot_range = PROTECTION.FIRE, 		snow_block = 6, 	snow_melt = true},
	saladfurnace = 				{snow_block = 6},
	stafflight = 				{prot_range = PROTECTION.FIRE, 		snow_block = 10, 	snow_melt = true},
	
	--	Just visual
	mermthrone = 				{snow_block = 5},
	winona_teleport_pad = 		{snow_block = 4},
	
	--	Actual flames
	campfirefire = 				{prot_range = PROTECTION.CAMPFIRE, 						snow_melt = true},
	character_fire = 			{prot_range = PROTECTION.FIRE, 							snow_melt = true},
	fire = 						{prot_range = PROTECTION.FIRE, 							snow_melt = true},
}

local function SetPolarstormRate(inst)
	if inst.components.fueled then
		if not inst.components.fueled:IsEmpty() and TheWorld.components.polarstorm and TheWorld.components.polarstorm:GetPolarStormLevel(inst) >= TUNING.SANDSTORM_FULL_LEVEL then
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
		
		if data.snow_block and inst._snowblockrange == nil then
			inst:AddTag("snowblocker")
			
			inst._snowblockrange = net_smallbyte(inst.GUID, prefab.."._snowblockrange")
			inst._snowblockrange:set(data.snow_block)
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
			if data.snow_block then
				inst.components.snowwavemelter.melt_range = data.snow_block
			end
			inst.components.snowwavemelter:StartMelting()
		end
	end)
end