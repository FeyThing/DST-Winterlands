local assets = {
	Asset("ANIM", "anim/polar_mist.zip"),
}

local MIST_VARS = 5

local LIGHT_TAGS = {"lightsource"}
local LIGHT_NOT_TAGS = {"spawnlight"}

local function OnPerish(inst)
	inst.components.colourtweener:StartTween({1, 1, 1, 0}, TUNING.POLAR_MIST_TWEENTIME, inst.Remove)
end

local function DoMistUpdate(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local lights = TheSim:FindEntities(x, y, z, TUNING.DAYLIGHT_SEARCH_RANGE, LIGHT_TAGS, LIGHT_NOT_TAGS)
	
	for i, v in ipairs(lights) do
		local lightrad = v.Light and v.Light:GetCalculatedRadius() * 0.75
		if v ~= inst and v:GetDistanceSqToPoint(x, y, z) < lightrad * lightrad then
			inst.components.perishable:SetPercent(0)
			break
		end
	end
end
 
local function OnEntitySleep(inst)
	inst:Remove()
end

local function OnInit(inst, x, y, z)
	if not inst:IsValid() then
		return
	end
	
	if x ~= nil then
		local angle = 180 + inst:GetAngleToPoint(x, y, z)
		inst.Transform:SetRotation(angle)
	else
		inst.Transform:SetRotation(math.random() * 360)
	end
	
	inst.Physics:SetMotorVel(inst.mistspeed, 0, 0)
end

local function SetEmitter(inst, emitter, scale, speed)
	inst.mist_emitter = emitter
	inst.mist_scale = scale or 1
	
	inst.AnimState:SetScale(inst.mist_scale, inst.mist_scale)
	inst.AnimState:SetSortOrder(2)
	
	local x, y, z
	if emitter.Transform then
		x, y, z = emitter.Transform:GetWorldPosition()
	end
	
	inst.mistspeed = speed or 0.1
	
	inst:DoTaskInTime(FRAMES, OnInit, x, y, z)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeTinyFlyingCharacterPhysics(inst, 1, 0.5)
	
	local mistvar = math.random(MIST_VARS) - 1
	inst.AnimState:SetBank("polar_mist")
	inst.AnimState:SetBuild("polar_mist")
	inst.AnimState:OverrideSymbol("mist0", "polar_mist", "mist"..mistvar)
	inst.AnimState:SetMultColour(1, 1, 1, 0)
	inst.AnimState:PlayAnimation("pre")
	inst.AnimState:PushAnimation("loop", true)
	inst.AnimState:SetLightOverride(0.07)
	
	inst:AddTag("FX")
	inst:AddTag("polarmist")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({1, 1, 1, 0.5}, TUNING.POLAR_MIST_TWEENTIME)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.POLAR_MIST_TIME)
	inst.components.perishable:StartPerishing()
	inst.components.perishable:SetOnPerishFn(OnPerish)
	
	inst.DoMistUpdate = DoMistUpdate
	inst.OnEntitySleep = OnEntitySleep
	inst.SetEmitter = SetEmitter
	
	inst.persists = false
	
	inst.mist_task = inst:DoPeriodicTask(FRAMES * 8, inst.DoMistUpdate)
	
	return inst
end

return Prefab("polar_mist", fn, assets)