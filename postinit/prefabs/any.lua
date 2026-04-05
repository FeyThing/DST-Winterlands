local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- Use Any when there's a fair chance of modded content of the same kind to be out there

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

--	[[	Animated Equippable	]]	-- 	Server/client Timefreeze Watch activation handles

local function Activate_PocketwatchPolar(inst, activate)
	local active = activate or inst.pocketwatch_polar_active:value()
	local fxs = inst.fx
	
	if fxs then
		if type(fxs) ~= "table" then
			fxs = {fxs}
		end
		
		for i, fx in ipairs(fxs) do
			if fx.AnimState then
				if active then
					fx.AnimState:SetMultColour(0, 0, 0, 0)
					
					local parent = fx.entity:GetParent()
					if parent and parent:HasTag("afterimagefx") then
						fx.AnimState:SetFinalOffset(-6)
						fx.AnimState:UsePointFiltering(true)
						fx.AnimState:SetDeltaTimeMultiplier(0)
						
						fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
						fx.AnimState:SetAddColour(0.3, 0.52 + math.random() * 0.1, 0.85 + math.random() * 0.15, 0)
						fx.AnimState:SetMultColour(0, 0, 0, 0)
						fx.AnimState:SetScale(1 + math.random() * 0.15, 1 + math.random() * 0.15)
						fx.AnimState:SetLightOverride(0.1)
						fx.AnimState:SetErosionParams(0, math.random() * 0.5, 1)
					end
				else
					fx.AnimState:SetMultColour(1, 1, 1, 1)
				end
			end
		end
	end
end

local function DoFade_PocketwatchPolar(inst)
	local fxs = inst.fx
	
	if fxs then
		if type(fxs) ~= "table" then
			fxs = {fxs}
		end
		
		for i, fx in ipairs(fxs) do
			if fx.AnimState then
				if fx.components.colourtweener == nil then
					fx:AddComponent("colourtweener")
				end
				
				fx.components.colourtweener:StartTween({0.63 + math.random() * 0.2, 0.7, 0.9, 0.3}, 0.2)
				
				fx:DoTaskInTime(0.21, function()
					fx.components.colourtweener:StartTween({0.2, 0.7, 0.9, 0}, 0.2, fx.Hide)
				end)
			end
		end
	end
end

local function AnimatedEquippableInit(inst)
	inst.Activate_PocketwatchPolar = Activate_PocketwatchPolar
	inst.DoFade_PocketwatchPolar = DoFade_PocketwatchPolar
	
	inst.pocketwatch_polar_active = net_bool(inst.GUID, "winterlands.pocketwatch_polar_active", "pocketwatch_polar_active")
	inst.pocketwatch_polar_dofade = net_event(inst.GUID, "winterlands.pocketwatch_polar_dofade")
	
	if not TheWorld.ismastersim then
		inst:ListenForEvent("pocketwatch_polar_active", inst.Activate_PocketwatchPolar)
		inst:ListenForEvent("winterlands.pocketwatch_polar_dofade", inst.DoFade_PocketwatchPolar)
	end
end

--

ENV.AddPrefabPostInitAny(function(inst)
	if inst:HasTag("FX") and inst.components.colouraddersync then
		AnimatedEquippableInit(inst)
	end
	
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