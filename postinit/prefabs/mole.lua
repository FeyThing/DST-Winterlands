local ENV = env
GLOBAL.setfenv(1, GLOBAL)

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
	
	MakeSnowAndDirtToggleable(inst, {
		{symbol = "dirt_base", 	build = "dirt_to_polar_builds"},
		{symbol = "hill", 		build = "dirt_to_polar_builds"},
		{symbol = "wormmovefx", build = "dirt_to_polar_builds"},
	})
end)

--

ENV.AddPrefabPostInit("molehill", function(inst)
	inst:AddTag("icicleimmune")
	
	if not TheWorld.ismastersim then
		return
	end
	
	MakeSnowAndDirtToggleable(inst, {
		{symbol = "dirt_base", 	build = "dirt_to_polar_builds"},
		{symbol = "hill", 		build = "dirt_to_polar_builds"},
		{symbol = "wormmovefx", build = "dirt_to_polar_builds"},
	})
end)

--

local function PolarInit_Fx(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local in_snow = TheWorld.Map:IsPolarSnowAtPoint(x, y, z, true)
		or (not IsInPolar(inst) and TheWorld.state.snowlevel and TheWorld.state.snowlevel > TUNING.DIRT_TO_SNOW_MIN_LEVEL)
	
	if in_snow then
		ReplacePrefab(inst, "mole_move_polar_fx")
	end
end

ENV.AddPrefabPostInit("mole_move_fx", function(inst)
	inst:DoTaskInTime(0, PolarInit_Fx)
end)