local assets = {
	Asset("ANIM", "anim/reticuleaoe.zip")
}

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("reticuleaoe")
	inst.AnimState:SetBuild("reticuleaoe")
	inst.AnimState:PlayAnimation("idle_1d2_12")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetMultColour(1, 1, 1, 0)
	
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({0.5, 1, 0.75, 0.5}, TUNING.TRIALS_START_TIME - 0.1)
	
	inst:DoTaskInTime(TUNING.TRIALS_START_TIME, function()
		inst.components.colourtweener:StartTween({0.75, 0.66, 1, 1}, 0.5)
	end)
	
	inst.persists = false
	
	return inst
end

return Prefab("trial_radius_fx", fn, assets)