local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function MoleOnLocomote(inst)
	local inpolar = IsInPolar(inst)
	
	if inpolar and not inst.polar_mole then
		inst.AnimState:OverrideSymbol("dirt_base", "dirt_to_polar_builds", "dirt_base")
		inst.AnimState:OverrideSymbol("hill", "dirt_to_polar_builds", "hill")
		inst.AnimState:OverrideSymbol("wormmovefx", "dirt_to_polar_builds", "wormmovefx")
	elseif not inpolar and inst.polar_mole then
		inst.AnimState:ClearOverrideSymbol("dirt_base")
		inst.AnimState:ClearOverrideSymbol("hill")
		inst.AnimState:ClearOverrideSymbol("wormmovefx")
	end
	
	inst.polar_mole = inpolar
end

local olddisplaynamefn
local function displaynamefn(inst, ...)
	local name = olddisplaynamefn and olddisplaynamefn(inst, ...)
	
	if name == STRINGS.NAMES.MOLE_UNDERGROUND and IsInPolar(inst) then
		name = STRINGS.NAMES.MOLE_UNDERGROUND_POLAR
	end
	
	return name
end

ENV.AddPrefabPostInit("mole", function(inst)
	if olddisplaynamefn == nil then
		olddisplaynamefn = inst.displaynamefn
	end
	inst.displaynamefn = displaynamefn
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst:ListenForEvent("locomote", MoleOnLocomote)
	inst:DoTaskInTime(0, MoleOnLocomote)
end)

--

local function PolarInit(inst)
	if IsInPolar(inst) then
		inst.AnimState:OverrideSymbol("dirt_base", "dirt_to_polar_builds", "dirt_base")
		inst.AnimState:OverrideSymbol("hill", "dirt_to_polar_builds", "hill")
		inst.AnimState:OverrideSymbol("wormmovefx", "dirt_to_polar_builds", "wormmovefx")
	end
end

ENV.AddPrefabPostInit("molehill", function(inst)
	inst:AddTag("icicleimmune")
	
	if not TheWorld.ismastersim then
		return
	end
	
	inst:DoTaskInTime(0, PolarInit)
end)

--

local function PolarInit_Fx(inst)
	if IsInPolar(inst) then
		ReplacePrefab(inst, "mole_move_polar_fx")
	end
end

local olddisplaynamefn_fx
local function displaynamefn_fx(inst, ...)
	local name = olddisplaynamefn_fx and olddisplaynamefn_fx(inst, ...)
	
	if IsInPolar(inst) then
		name = STRINGS.NAMES.MOLE_UNDERGROUND_POLAR
	end
	
	return name
end

ENV.AddPrefabPostInit("mole_move_fx", function(inst)
	inst:DoTaskInTime(0, PolarInit_Fx)
end)