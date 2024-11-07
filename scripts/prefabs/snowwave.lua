local assets = {
	Asset("ANIM", "anim/snowwave.zip"),
}

local SNOWWAVE_VARS = 4

local function DoWaveFade(inst, out)
	if out then
		if ThePlayer and ThePlayer.components.snowwaver then
			ThePlayer.components.snowwaver.waves[inst._id] = nil
			ThePlayer.components.snowwaver.waves_data[inst._id] = nil
		end
		inst.components.colourtweener:StartTween({1, 1, 1, 0}, 0.3, inst.Remove)
	else
		inst.components.colourtweener:StartTween({1, 1, 1, 1}, 0.3)
	end
end

local function OnEntitySleep(inst)
	inst:DoWaveFade(true)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	local snowvar = math.random(SNOWWAVE_VARS)
	inst.AnimState:SetBank("snowwave")
	inst.AnimState:SetBuild("snowwave")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:OverrideSymbol("snowy1", "snowwave", "snowy"..snowvar)
	inst.AnimState:SetFinalOffset(3)
	inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) - 1)
	inst.AnimState:SetMultColour(1, 1, 1, 0)
	inst.AnimState:SetScale(2, 2) -- TODO: make it bigger in the anims, base scale should remain 1
	
	inst:AddTag("FX")
	
	inst:AddComponent("colourtweener")
	
	inst.DoWaveFade = DoWaveFade
	inst.OnEntitySleep = OnEntitySleep
	
	inst.persists = false
	
	return inst
end

--

local function ExtendSnowBlocker(inst)
	if inst.components.timer and inst.components.timer:TimerExists("plowcycle") then
		inst.components.timer:SetTimeLeft("plowcycle", TUNING.POLARPLOW_BLOCKER_DURATION)
	end
end

local function SetSnowBlockRange(inst, range)
	inst._snowblockrange:set(range or 4)
end

local function OnSave(inst, data)
	data.range = inst._snowblockrange:value()
end

local function OnLoad(inst, data)
	if data and data.range then
		inst:SetSnowBlockRange(data.range)
	end
end

local function OnTimerDone(inst, data)
	if data.name == "plowcycle" then
		inst:Remove()
	end
end

local function blocker()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst:AddTag("FX")
	inst:AddTag("snowblocker")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "snowwave_blocker._snowblockrange")
	inst._snowblockrange:set(4)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("timer")
	inst.components.timer:StartTimer("plowcycle", TUNING.POLARPLOW_BLOCKER_DURATION)
	
	inst.ExtendSnowBlocker = ExtendSnowBlocker
	inst.SetSnowBlockRange = SetSnowBlockRange
	
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

return Prefab("snowwave", fn, assets),
	Prefab("snowwave_blocker", blocker)