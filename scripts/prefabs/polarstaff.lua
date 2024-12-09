local assets = {
	Asset("ANIM", "anim/polarstaffs.zip"),
}

local icicle_prefabs = {
	"iciclestaff_icicle",
}

local polarice_prefabs = {
	"iciclestaff_icicle",
}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", "swap_bluestaff")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	owner.AnimState:Show("ARM_normal")
	owner.AnimState:Hide("ARM_carry")
end

local function OnFinished(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
	inst:Remove()
end

local function commonfn(name, tags)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("polarstaffs")
	inst.AnimState:SetBuild("polarstaffs")
	inst.AnimState:PlayAnimation(name.."staff")
	
	inst:AddTag("shadowlevel")
	
	if tags then
		for i, v in ipairs(tags) do
			inst:AddTag(v)
		end
	end
	
	local floater_swap_data = {
		sym_build = "polarstaffs",
		sym_name = "swap_"..name.."staff",
		bank = "polarstaffs",
		anim = name.."staff"
	}
	MakeInventoryFloatable(inst, "med", nil, {0.9, 0.5, 0.9}, true, -24, floater_swap_data)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(function(inst, owner)
		owner.AnimState:OverrideSymbol("swap_object", "polarstaffs", "swap_"..name.."staff")
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
	end)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetOnFinished(OnFinished)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("shadowlevel")
	inst.components.shadowlevel:SetDefaultLevel(TUNING.STAFF_SHADOW_LEVEL)
	
	inst:AddComponent("tradable")
	
	MakeHauntableLaunch(inst)
	
	return inst
end

--

local function SummonIcicles(inst, target, pos, doer)
	local x, y, z
	if target then
		x, y, z = target.Transform:GetWorldPosition()
	elseif pos then
		x, y, z = pos:Get()
	else
		return false
	end
	
	if doer.components.staffsanity then
		doer.components.staffsanity:DoCastingDelta(TUNING.ICICLESTAFF_SANITY_DELTA)
	elseif doer.components.sanity ~= nil then
		doer.components.sanity:DoDelta(TUNING.ICICLESTAFF_SANITY_DELTA)
	end
	
	for i = 0, TUNING.ICICLESTAFF_ICICLES_NUM do
		TheWorld:DoTaskInTime(0.1 * i, function()
			local x2 = 3 - math.random() * 6
			local z2 = 3 - math.random() * 6
			
			local proj = SpawnPrefab("polar_icicle_staff")
			proj.Transform:SetPosition(x + x2, 0, z + z2)
			proj.owner = doer
		end)
	end
	
	if inst.components.finiteuses then
		inst.components.finiteuses:Use(1)
	end
end

local function reticuletargetfn()
	return Vector3(ThePlayer.entity:LocalToWorldSpace(15, 0.001, 0))
end

local function icicle()
	local inst = commonfn("icicle", {"allow_action_on_impassable", "castontargets", "nopunch"})
	
	inst:AddComponent("reticule")
	inst.components.reticule.targetfn = reticuletargetfn
	inst.components.reticule.ease = true
	inst.components.reticule.ispassableatallpoints = true
	inst.components.reticule.reticuleprefab = "reticuleaoe"
	inst.components.reticule.pingprefab = "reticuleaoeping"
	inst.components.reticule.mouseenabled = true
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.finiteuses:SetMaxUses(TUNING.ICICLESTAFF_USES)
	inst.components.finiteuses:SetUses(TUNING.ICICLESTAFF_USES)
	inst.components.finiteuses:SetOnFinished(OnFinished)
	
	inst:AddComponent("spellcaster")
	inst.components.spellcaster:SetSpellFn(SummonIcicles)
	inst.components.spellcaster.canuseonpoint = true
	inst.components.spellcaster.canuseonpoint_water = true
	inst.components.spellcaster.canuseontargets = true
	inst.components.spellcaster.can_cast_fn = function(doer, target, pos) return true end
	inst.components.spellcaster.quickcast = true
	
	return inst
end

--

local MUST_TAGS = {"_combat"}
local CANT_TAGS = {"INLIMBO", "playerghost", "player", "flight"}

local function DoFrostAura(inst, target, pos, doer)
	if doer then
		if doer.components.staffsanity then
			doer.components.staffsanity:DoCastingDelta(TUNING.POLARICESTAFF_SANITY_DELTA)
		elseif doer.components.sanity ~= nil then
			doer.components.sanity:DoDelta(TUNING.POLARICESTAFF_SANITY_DELTA)
		end
		
		local x, y, z = doer.Transform:GetWorldPosition()
		SpawnPrefab("polar_frostaura").Transform:SetPosition(x, y, z)
		SpawnPrefab("groundpoundring_fx").Transform:SetPosition(x, y, z)
		inst.SoundEmitter:PlaySound("dontstarve/common/break_iceblock")
		
		local ents = TheSim:FindEntities(x, 0, z, 12, MUST_TAGS, CANT_TAGS)
		for i, ent in ipairs(ents) do
			if ent:IsValid() and ent.components.freezable and not ent:HasTag("player") then
				ent.components.freezable:AddColdness(10, TUNING.FROSTAURASTAFF_FREEZE_TIME) -- Very high freeze value
			end
		end
		
		if TheWorld.components.polarice_manager then
			
		end
		
		inst.components.finiteuses:Use(1)
		
		return true
	end
	
	return false
end

local function OnAttack(inst, attacker, target)
	if target and target.SoundEmitter and not target:HasTag("shadowcreature") and not target:HasTag("brightmare") then
		target.SoundEmitter:PlaySound("polarsounds/antler_tree/bonk", nil, nil, true)
	end
end

local function polarice()
	local inst = commonfn("polarice", {"allow_action_on_impassable", "antlerstick", "polarstaff"})
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.equippable.polar_slowtime = 4
	inst.components.equippable.walkspeedmult = TUNING.ANTLER_TREE_STICK_SPEED_MULT
	
	inst.components.finiteuses:SetMaxUses(TUNING.POLARICESTAFF_USES)
	inst.components.finiteuses:SetUses(TUNING.POLARICESTAFF_USES)
	inst.components.finiteuses:SetOnFinished(OnFinished)
	
	inst:AddComponent("spellcaster")
	inst.components.spellcaster:SetSpellFn(DoFrostAura)
	inst.components.spellcaster.canuseonpoint = true
	inst.components.spellcaster.canuseonpoint_water = true
	inst.components.spellcaster.can_cast_fn = function(doer, target, pos) return true end
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)
	inst.components.weapon:SetOnAttack(OnAttack)
	inst.components.weapon.attackwear = 0
	
	return inst
end

return Prefab("iciclestaff", icicle, assets, icicle_prefabs),
	Prefab("polaricestaff", polarice, assets, polarice_prefabs)