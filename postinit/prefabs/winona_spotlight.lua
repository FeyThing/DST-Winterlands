local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local EnableTargetSearch

local OldOnIsDarkOrCold
local function OnIsDarkOrCold(inst, ...)
	if OldOnIsDarkOrCold then
		OldOnIsDarkOrCold(inst, ...)
	end
	
	local x, y, z = inst.Transform:GetWorldPosition()
	
	local heated = inst._heated and inst._heated:value()
	local light = inst._lightinst
	
	if heated and GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil and inst._turnofftask then
		if light and light:IsValid() then
			if light.components.snowwavemelter == nil then
				light:AddComponent("snowwavemelter")
			end
			
			local ranged = inst._ranged and inst._ranged:value()
			light.components.snowwavemelter.melt_range = ranged and TUNING.WINONA_SPOTLIGHT_SNOWMELT_RANGE2 or TUNING.WINONA_SPOTLIGHT_SNOWMELT_RANGE1
			light.components.snowwavemelter:StartMelting()
		end
		
		if EnableTargetSearch then
			EnableTargetSearch(inst, true)
		end
	elseif not heated then
		if light and light:IsValid() and light.components.snowwavemelter then
			light.components.snowwavemelter:StopMelting()
		end
	end
end

ENV.AddPrefabPostInit("winona_spotlight", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.AddBatteryPower and OldOnIsDarkOrCold == nil then
		local SetPowered = PolarUpvalue(inst.AddBatteryPower, "SetPowered")
		
		if SetPowered then
			OldOnIsDarkOrCold = PolarUpvalue(SetPowered, "OnIsDarkOrCold")
			
			if OldOnIsDarkOrCold then
				EnableTargetSearch = PolarUpvalue(OldOnIsDarkOrCold, "EnableTargetSearch")
				
				PolarUpvalue(SetPowered, "OnIsDarkOrCold", OnIsDarkOrCold)
			end
		end
	end
end)