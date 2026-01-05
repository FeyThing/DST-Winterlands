local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- We should be using Any when there's a fair chance of modded content of the same kind to be out there

--	[[		Shovels		]]	--

local SHOVEL_PLOW_RANGES = {
	shovel = TUNING.SNOW_PLOW_RANGES.SHOVEL,
	goldenshovel = TUNING.SNOW_PLOW_RANGES.GOLDENSHOVEL,
	shovel_lunarplant = TUNING.SNOW_PLOW_RANGES.SHOVEL_LUNARPLANT,
}

local function ShovelPostInit(inst)
	if inst.components.finiteuses then
		local dig_use = inst.components.finiteuses.consumption[ACTIONS.DIG] or 1
		
		inst.components.finiteuses:SetConsumption(ACTIONS.POLARPLOW, dig_use * TUNING.POLARPLOW_USE)
	end
	
	if inst.components.polarplower == nil then
		local plow_range = SHOVEL_PLOW_RANGES[inst.prefab] or SHOVEL_PLOW_RANGES.goldenshovel
		
		inst:AddComponent("polarplower")
		inst.components.polarplower.plow_range = plow_range
	end
end

--	[[	Walrus / Hounds	]]	--

local function NoWalrusAllyRetarget(inst, target)
	if target:HasTag("walruspal") or (target.components.age and target.components.age:GetAge() <= 20) then -- Leave freshly spawned players alone, yknow why
		return not inst:HasTag("epic") and not inst:HasTag("warg") -- Puppy's getting too big
	end
end

local function WalrusOrHoundPostInit(inst)
	local oldtargetfn = inst.components.combat and inst.components.combat.targetfn
	
	if oldtargetfn then
		inst.components.combat.targetfn = function(inst, ...)
			local target, forcechange = oldtargetfn(inst, ...)
			if target and NoWalrusAllyRetarget(inst, target) then
				return
			end
			
			return target, forcechange
		end
	end
end

--

ENV.AddPrefabPostInitAny(function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst:HasTag("DIG_tool") then
		ShovelPostInit(inst)
	end
	
	if inst:HasTag("hound") or inst:HasTag("walrus") then
		WalrusOrHoundPostInit(inst)
	end
end)