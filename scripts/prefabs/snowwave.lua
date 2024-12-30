local assets = {
	Asset("ANIM", "anim/snowwave.zip"),
}

local SNOWWAVE_VARS = 4

local function DoWaveFade(inst, out, out_fn)
	inst._fading = out
	
	if out then
		inst.components.colourtweener:StartTween({1, 1, 1, 0}, 0.3, out_fn)
	else
		inst.components.colourtweener:StartTween({1, 1, 1, 1}, 0.3)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	local snowvar = math.random(SNOWWAVE_VARS)
	inst.AnimState:SetBank("snowwave")
	inst.AnimState:SetBuild("snowwave")
	inst.AnimState:PlayAnimation("idle_bounce", true)
	inst.AnimState:OverrideSymbol("snowy1", "snowwave", "snowy"..snowvar)
	inst.AnimState:SetFinalOffset(7)
	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
	inst.AnimState:SetMultColour(1, 1, 1, 0)
	inst.AnimState:SetScale(2, 2) -- TODO: make it bigger in the anims, base scale should remain 1
	
	inst:AddTag("FX")
	
	inst:AddComponent("colourtweener")
	
	inst.DoWaveFade = DoWaveFade
	
	inst.persists = false
	
	return inst
end

--

local function ExtendSnowBlocker(inst)
	if inst.components.timer and inst.components.timer:TimerExists("plowcycle") then
		
		local blizzard = TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst)
		local timeleft = TUNING.POLARPLOW_BLOCKER_DURATION
		
		inst.components.timer:SetTimeLeft("plowcycle", timeleft * (blizzard and TUNING.POLARPLOW_BLOCKER_STORMCUT or 1))
	end
end

local function SetSnowBlockRange(inst, range)
	inst._snowblockrange:set(range or 2)
end

local function OnSave(inst, data)
	data.range = inst._snowblockrange:value()
end

local function OnLoad(inst, data)
	if data and data.range then
		inst:SetSnowBlockRange(data.range)
	end
end

local function OnPolarstormChanged(inst, active)
	if active and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(inst)
		and inst.components.timer then
		
		local timeleft = inst.components.timer:GetTimeLeft("plowcycle")
		inst.components.timer:SetTimeLeft("plowcycle", timeleft * TUNING.POLARPLOW_BLOCKER_STORMCUT)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "plowcycle" then
		inst:Remove()
	end
end

local function OnSnowBlockRangeDirty(inst)
	TheWorld:PushEvent("snowwave_blockerupdate", {blocker = inst})
end

local function blocker()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "snowwave_blocker._snowblockrange", "snowblockrangedirty")
	inst._snowblockrange:set(6) -- For debug spawn :3
	
	inst:ListenForEvent("snowblockrangedirty", OnSnowBlockRangeDirty)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("plowcycle", TUNING.POLARPLOW_BLOCKER_DURATION)
	
	inst.ExtendSnowBlocker = ExtendSnowBlocker
	inst.SetSnowBlockRange = SetSnowBlockRange
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	inst.onpolarstormchanged = function(src, data)
		if data and data.stormtype == STORM_TYPES.POLARSTORM then
			OnPolarstormChanged(inst, data.setting)
		end
	end
	
	inst:ListenForEvent("ms_stormchanged", inst.onpolarstormchanged, TheWorld)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

--

local function OnDig(inst, worker)
	if worker and worker:HasTag("shadowminion") then
		local blocker = SpawnPrefab("snowwave_blocker")
		blocker.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if blocker.SetSnowBlockRange then
			blocker:SetSnowBlockRange(inst.plow_range)
		end
	end
end

local function marker()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("stump") -- Worker's Brain only looks out for stumps, graves and farm debris
	inst:AddTag("shadowworker_plowmark")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnDig)
	
	inst.plow_range = 5
	inst.persists = false
	
	inst:DoTaskInTime(60, inst.Remove)
	
	return inst
end

return Prefab("snowwave", fn, assets),
	Prefab("snowwave_blocker", blocker),
	Prefab("snowwave_workermarker", marker)