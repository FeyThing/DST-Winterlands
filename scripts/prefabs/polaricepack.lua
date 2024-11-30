local assets = {
	Asset("ANIM", "anim/polaricepack.zip"),
}

--if owner:HasTag("pocketdimension_container") or owner:HasTag("buried") then

local function OnOwnerUsed(inst, owner)
	local _owner = inst.components.inventoryitem:GetGrandOwner()
	
	if owner and owner.components.container then
		if owner.components.polarmistemitter == nil then
			owner:AddComponent("polarmistemitter")
			owner.components.polarmistemitter.maxmist = 6
			owner.components.polarmistemitter.scale = 2.5
		end
		
		if owner.components.container:IsOpen() then
			owner.components.polarmistemitter:StartMisting()
		else
			owner.components.polarmistemitter:StopMisting()
		end
	end
end

local function OnOwnerChange(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	
	if inst._owner and owner ~= inst._owner then
		inst:RemoveEventCallback("onclose", inst._onownerused, inst._owner)
		inst:RemoveEventCallback("onopen", inst._onownerused, inst._owner)
		
		inst:_onownerused(owner)
		inst.components.polarmistemitter:StartMisting()
	end
	
	if owner and owner:IsValid() and owner ~= inst._owner then
		if owner.components.preserver == nil then
			owner:AddComponent("preserver")
		end
		
		inst:ListenForEvent("onclose", inst._onownerused, owner)
		inst:ListenForEvent("onopen", inst._onownerused, owner)
		
		inst:_onownerused(owner)
		inst.components.polarmistemitter:StopMisting()
	end
	
	inst._owner = owner
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBank("polaricepack")
	inst.AnimState:SetBuild("polaricepack")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("icepack")
	inst:AddTag("icebox_valid")
	inst:AddTag("saltbox_valid")
	inst:AddTag("show_spoilage")
	
	inst.pickupsound = "rock"
	inst.preserver_mult = TUNING.POLARICEPACK_PRESERVE_MULT
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetSinks(true)
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW + TUNING.PERISH_PRESERVED)
	inst.components.perishable:StartPerishing()
	
	inst:AddComponent("polarmistemitter")
	inst.components.polarmistemitter.maxmist = 8
	inst.components.polarmistemitter.scale = 1.5
	inst.components.polarmistemitter:StartMisting()
	
	MakeHauntableLaunch(inst)
	
	inst._onownerused = function(owner) OnOwnerUsed(inst, owner) end
	
	inst:ListenForEvent("onputininventory", OnOwnerChange)
	inst:ListenForEvent("ondropped", OnOwnerChange)
	
	OnOwnerChange(inst)
	
	return inst
end

return Prefab("polaricepack", fn, assets)