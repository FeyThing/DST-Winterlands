local assets = {
	Asset("ANIM", "anim/polaricepack.zip"),
}

local function OnOwnerUsed(inst, owner)
	if owner and owner.components.container and owner.components.polarmistemitter
		and not (owner:HasTag("pocketdimension_container") or owner:HasTag("buried")) then
		
		owner.components.polarmistemitter:SetEnabled(owner.components.container:IsOpen())
	end
end

local function OnOwnerChange(inst)
	local owner = inst.components.inventoryitem:GetGrandOwner()
	
	if inst._owner and owner ~= inst._owner then
		inst:RemoveEventCallback("onclose", inst._onownerused, inst._owner)
		inst:RemoveEventCallback("onopen", inst._onownerused, inst._owner)
		
		inst:_onownerused(owner)
		inst.components.polarmistemitter:SetEnabled(true)
	end
	
	if owner and owner:IsValid() and owner ~= inst._owner then
		--[[if owner.components.preserver == nil then
			owner:AddComponent("preserver")	NOTE: preserver and tag-based container spoilage rates (like "fridge") are mutually exclusive, we can't use this :/
		end]]
		
		inst:ListenForEvent("onclose", inst._onownerused, owner)
		inst:ListenForEvent("onopen", inst._onownerused, owner)
		
		inst:_onownerused(owner)
		inst.components.polarmistemitter:SetEnabled(false)
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
	
	inst:AddTag("dryice")
	inst:AddTag("icepack")
	inst:AddTag("icebox_valid")
	inst:AddTag("saltbox_valid")
	inst:AddTag("show_spoilage")
	
	inst.pickupsound = "rock"
	inst.preserver_mult = TUNING.POLARICEPACK_PRESERVE_MULT
	
	inst:AddComponent("polarmistemitter")
	
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
	inst.components.perishable:SetOnPerishFn(inst.Remove)
	
	inst.components.polarmistemitter:SetEnabled(true)
	
	MakeHauntableLaunch(inst)
	
	--	Dryice making containers emit mist was moved to any postinit, this is no longer specific to the Ice Pack
	--[[inst._onownerused = function(owner) OnOwnerUsed(inst, owner) end
	
	inst:ListenForEvent("onputininventory", OnOwnerChange)
	inst:ListenForEvent("ondropped", OnOwnerChange)
	
	OnOwnerChange(inst)]]
	
	return inst
end

return Prefab("polaricepack", fn, assets)