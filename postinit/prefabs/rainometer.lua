local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function TestBlizzardWarning(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 64) ~= nil and TheWorld.components.polarstorm then
		local time_before_storm = TheWorld.components.polarstorm:GetTimeLeft()
		local time_warn = TUNING[inst.prefab == "winterometer" and "WINTEROMETER_BLIZZARD_WARNTIME" or "RAINOMETER_BLIZZARD_WARNTIME"]
		
		return TheWorld.components.polarstorm:IsPolarStormActive() or time_before_storm and time_before_storm <= time_warn
	end
end

local function DoBlizzardUpdate(inst)
	local warning = inst:TestBlizzardWarning() or false
	local animate = warning and not inst.AnimState:IsCurrentAnimation("polarstorm")
	
	if animate or warning ~= inst._polarstorm_warning then
		inst._polarstorm_warning = warning
		
		if inst.task and warning then
			inst.task:Cancel()
			inst.task = nil
		end
		
		inst.SoundEmitter:KillSound("polarstorm")
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("polarstorm", warning)
			if warning then
				inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "polarstorm", 0.33)
			end
		end
	end
end

--

local BLIZZARD_WARNERS = {"rainometer", "winterometer"}

local OldStartCheckRain
local function StartCheckRain(inst, ...)
	if not inst._polarstorm_warning and OldStartCheckRain then
		OldStartCheckRain(inst, ...)
	end
end

local OldStartCheckTemp
local function StartCheckTemp(inst, ...)
	if not inst._polarstorm_warning and OldStartCheckTemp then
		OldStartCheckTemp(inst, ...)
	end
end

for i, prefab in ipairs(BLIZZARD_WARNERS) do
	local OldGetStatus
	local function GetStatus(inst, ...)
		if inst._polarstorm_warning and not inst:HasTag("burnt") then
			return "POLARSTORM"
		end
		
		return OldGetStatus and OldGetStatus(inst, ...) or nil
	end
	
	local OldOnEntitySleep
	local function OnEntitySleep(inst, ...)
		if inst._polarstorm_task then
			inst._polarstorm_task:Cancel()
			inst._polarstorm_task = nil
		end
		
		if OldOnEntitySleep then
			OldOnEntitySleep(inst, ...)
		end
	end
	
	local OldOnEntityWake
	local function OnEntityWake(inst, ...)
		if inst._polarstorm_task == nil then
			inst._polarstorm_task = inst:DoPeriodicTask(1 + math.random(), DoBlizzardUpdate)
		end
		
		if OldOnEntityWake then
			OldOnEntityWake(inst, ...)
		end
	end
	
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		if inst.components.inspectable then
			if OldGetStatus == nil then
				OldGetStatus = inst.components.inspectable.getstatus
			end
			inst.components.inspectable.getstatus = GetStatus
		end
		
		inst.TestBlizzardWarning = TestBlizzardWarning
		
		inst._polarstorm_warning = false
		inst._polarstorm_task = inst:DoPeriodicTask(1 + math.random(), DoBlizzardUpdate)
		
		if inst.event_listeners.animover and inst.event_listeners.animover[inst] then
			if OldStartCheckRain == nil and prefab == "rainometer" then
				OldStartCheckRain = inst.event_listeners.animover[inst][1]
			elseif OldStartCheckTemp == nil and prefab == "winterometer" then
				OldStartCheckTemp = inst.event_listeners.animover[inst][1]
			end
			
			inst.event_listeners.animover[inst][1] = prefab == "rainometer" and StartCheckRain or StartCheckTemp
		end
	end)
end