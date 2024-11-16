local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldSetStage
local function SetStage(inst, stage, source, ...)
	if inst._canpolarise and IsInPolar(inst) and (source == nil or source == "grow" or source == "melt") then
		stage = "tall"
		
		local grow_tries = 0
		while inst.stage and inst.stage ~= stage and grow_tries < 5 do
			grow_tries = grow_tries + 1
			OldSetStage(inst, stage, source, ...)
		end
	else
		OldSetStage(inst, stage, source, ...)
	end
end

local function OnPolarInit(inst)
	if IsInPolar(inst) then
		inst._canpolarise = true
		SetStage(inst, "tall", "grow")
	end
end

ENV.AddPrefabPostInit("rock_ice", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.workable and OldSetStage == nil then
		OldSetStage = PolarUpvalue(inst.components.workable.onwork, "SetStage")
		
		if OldSetStage then
			PolarUpvalue(inst.components.workable.onwork, "SetStage", SetStage)
		end
	end
	
	inst:DoTaskInTime(0.1, OnPolarInit) -- Stage change should be delayed because OnLoad begs to restore saved stage first
end)