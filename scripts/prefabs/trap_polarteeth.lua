local assets = {
	Asset("ANIM", "anim/trap_polarteeth.zip"),
}

local function OnFinished(inst)
	inst:RemoveComponent("inventoryitem")
	inst:RemoveComponent("mine")
	inst.persists = false
	
	inst.Physics:SetActive(false)
	inst.AnimState:PushAnimation("used", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	
	inst:DoTaskInTime(3, inst.Remove)
end

local function OnExplode(inst, target)
	inst.AnimState:PlayAnimation("trap")
	if target then
		inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_trigger")
		target.components.combat:GetAttacked(inst, TUNING.TRAP_POLARTEETH_DAMAGE)
		
		if target.components.freezable and not (target.components.health and target.components.health:IsDead()) then
			target.components.freezable:AddColdness(TUNING.TRAP_POLARTEETH_FREEZING)
		end
	end
	if inst.components.finiteuses then
		inst.components.finiteuses:Use(1)
	end
end

local function OnReset(inst)
	if inst.components.inventoryitem then
		inst.components.inventoryitem.nobounce = true
	end
	if not inst:IsInLimbo() then
		inst.MiniMapEntity:SetEnabled(true)
		inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_reset")
	end
	
	if not inst.AnimState:IsCurrentAnimation("idle") then
		inst.AnimState:PlayAnimation("reset")
		inst.AnimState:PushAnimation("idle", false)
	end
end

local function SetSprung(inst)
	if inst.components.inventoryitem then
		inst.components.inventoryitem.nobounce = true
	end
	
	if not inst:IsInLimbo() then
		inst.MiniMapEntity:SetEnabled(true)
	end
	inst.AnimState:PlayAnimation("trap_idle")
end

local function SetInactive(inst)
	if inst.components.inventoryitem then
		inst.components.inventoryitem.nobounce = false
	end
	
	inst.MiniMapEntity:SetEnabled(false)
	inst.AnimState:PlayAnimation("inactive")
end

local function OnDropped(inst)
	inst.components.mine:Deactivate()
end

local function OnDeploy(inst, pt, deployer)
	inst.components.mine:Reset()
	inst.Physics:Stop()
	inst.Physics:Teleport(pt:Get())
end

local function OnHaunt(inst, haunter)
	if inst.components.mine == nil or inst.components.mine.inactive then
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
		Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
		return true
	elseif not inst.components.mine.issprung then
		return false
	elseif math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
		inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
		inst.components.mine:Reset()
		return true
	end
	return false
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	inst:SetDeploySmartRadius(DEPLOYSPACING_RADIUS[DEPLOYSPACING.LESS] / 2)
	
	inst.MiniMapEntity:SetIcon("trap_polarteeth.png")
	
	inst.AnimState:SetBank("trap_polarteeth")
	inst.AnimState:SetBuild("trap_polarteeth")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("trap")
	
	MakeInventoryFloatable(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	
	inst:AddComponent("mine")
	inst.components.mine:SetRadius(TUNING.TRAP_TEETH_RADIUS)
	inst.components.mine:SetAlignment("player")
	inst.components.mine:SetOnExplodeFn(OnExplode)
	inst.components.mine:SetOnResetFn(OnReset)
	inst.components.mine:SetOnSprungFn(SetSprung)
	inst.components.mine:SetOnDeactivateFn(SetInactive)
	inst.components.mine:Reset()
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.TRAP_POLARTEETH_USES)
	inst.components.finiteuses:SetUses(TUNING.TRAP_POLARTEETH_USES)
	inst.components.finiteuses:SetOnFinished(OnFinished)
	
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = OnDeploy
	inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetOnHauntFn(OnHaunt)
	
	return inst
end

return Prefab("trap_polarteeth", fn, assets),
	MakePlacer("trap_polarteeth_placer", "trap_polarteeth", "trap_polarteeth", "idle")