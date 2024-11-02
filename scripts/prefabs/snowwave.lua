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

return Prefab("snowwave", fn, assets)