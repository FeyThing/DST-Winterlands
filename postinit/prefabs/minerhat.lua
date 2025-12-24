local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- TODO: Honestly I'd rather move this to minerhat init / clear skin functions later, but this was quicker to pull of in the rush

local BOREALLIGHT_COLORS = {
	{120 / 255, 200 / 255, 255 / 255},
	{90 / 255, 220 / 255, 200 / 255},
	{160 / 255, 120 / 255, 255 / 255},
}

local BOREALLIGHT_SPEED = 0.03

local function UpdateBorealLight(inst)
	if not inst._light or not inst._borealight_phase then
		inst._borealight_colors = BOREALLIGHT_COLORS
		inst._borealight_phase = 0
		
		return
	end
	
	local colors = inst._borealight_colors
	inst._borealight_phase = inst._borealight_phase + BOREALLIGHT_SPEED
	
	local i1 = math.floor(inst._borealight_phase) % #colors + 1
	local i2 = i1 % #colors + 1
	local t  = inst._borealight_phase - math.floor(inst._borealight_phase)
	
	local c1 = colors[i1]
	local c2 = colors[i2]
	
	inst._light.Light:SetColour(
		Lerp(c1[1], c2[1], t),
		Lerp(c1[2], c2[2], t),
		Lerp(c1[3], c2[3], t)
	)
end

local function OnFuelSectionChanged(inst, owner, data)
	if owner == nil or not owner:IsValid() then
		return
	end
	
	local hasfuel = inst.components.fueled == nil or not inst.components.fueled:IsEmpty()
	
	if hasfuel and inst._vfx_fx_inst == nil then
		inst._vfx_fx_inst = SpawnPrefab("minerhat_boreal_overlay")
		inst._vfx_fx_inst.entity:SetParent(owner.entity)
	elseif not hasfuel and inst._vfx_fx_inst then
		inst._vfx_fx_inst:Remove()
		inst._vfx_fx_inst = nil
	end
	
	if hasfuel then
		owner.AnimState:ClearOverrideSymbol("swap_hat") -- Overlay does all the work instead while lit, both never show at once
	else
		owner.AnimState:OverrideItemSkinSymbol("swap_hat", inst:GetSkinBuild(), "swap_hat_off", inst.GUID)
	end
end

local OldOnEquip
local function OnEquip(inst, owner, ...)
	local skin_name = inst:GetSkinName()
	if skin_name == "ms_minerhat_boreal" then
		ENV.RemapSoundEvent("dontstarve/common/minerhatAddFuel", "polarsounds/common/minerhatAddFuel_boreal")
	end
	
	if OldOnEquip then
		OldOnEquip(inst, owner, ...)
	end

	if skin_name == "ms_minerhat_boreal" then
		inst._borealight_colors = BOREALLIGHT_COLORS
		inst._borealight_phase = 0
		
		if inst._vfx_fx_inst == nil and not (inst.components.fueled and inst.components.fueled:IsEmpty()) then
			inst._vfx_fx_inst = SpawnPrefab("minerhat_boreal_overlay")
			inst._vfx_fx_inst.entity:SetParent(owner.entity)
		end
		if inst._borealight_task then
			inst._borealight_task:Cancel()
		end
		inst._borealight_task = inst:DoPeriodicTask(0.05, UpdateBorealLight)
		inst._borealightcallback = function(inst, data) OnFuelSectionChanged(inst, owner, data) end
		
		inst:ListenForEvent("onfueldsectionchanged", inst._borealightcallback)
		OnFuelSectionChanged(inst, owner)
		
		ENV.RemoveRemapSoundEvent("dontstarve/common/minerhatAddFuel")
	end
end

local OldOnUnequip
local function OnUnequip(inst, owner, ...)
	if inst._vfx_fx_inst then
		inst._vfx_fx_inst:Remove()
		inst._vfx_fx_inst = nil
	end
	if inst._borealight_task then
		inst._borealight_task:Cancel()
		inst._borealight_task = nil
	end
	if inst._borealightcallback then
		inst:RemoveEventCallback("onfueldsectionchanged", inst._borealightcallback)
		inst._borealightcallback = nil
	end
	
	if OldOnUnequip then
		OldOnUnequip(inst, owner, ...)
	end
end

local oldminer_turnon
local function miner_turnon(inst, ...)
	local skin_name = inst:GetSkinName()
	if skin_name == "ms_minerhat_boreal" then
		ENV.RemapSoundEvent("dontstarve/common/minerhatAddFuel", "polarsounds/common/minerhatAddFuel_boreal")
	end
	
	if oldminer_turnon then
		oldminer_turnon(inst, ...)
	end
	
	if skin_name == "ms_minerhat_boreal" then
		ENV.RemoveRemapSoundEvent("dontstarve/common/minerhatAddFuel")
	end
end

local oldminer_turnoff
local function miner_turnoff(inst, ...)
	local skin_name = inst:GetSkinName()
	if skin_name == "ms_minerhat_boreal" then
		ENV.RemapSoundEvent("dontstarve/common/minerhatOut", "polarsounds/common/minerhatOut_boreal")
	end
	
	if oldminer_turnoff then
		oldminer_turnoff(inst, ...)
	end
	
	if skin_name == "ms_minerhat_boreal" then
		ENV.RemoveRemapSoundEvent("dontstarve/common/minerhatOut")
	end
end

ENV.AddPrefabPostInit("minerhat", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.equippable then
		if OldOnEquip == nil then
			if inst.components.fueled then
				oldminer_turnon = PolarUpvalue(inst.components.fueled.ontakefuelfn, "miner_turnon")
				PolarUpvalue(inst.components.fueled.ontakefuelfn, "miner_turnon", miner_turnon)
			end
			
			OldOnEquip = inst.components.equippable.onequipfn
		end
		
		if OldOnUnequip == nil then
			oldminer_turnoff = PolarUpvalue(inst.components.equippable.onunequipfn, "miner_turnoff")
			PolarUpvalue(inst.components.equippable.onunequipfn, "miner_turnoff", miner_turnoff)
			
			OldOnUnequip = inst.components.equippable.onunequipfn
		end
		
		inst.components.equippable:SetOnEquip(OnEquip)
		inst.components.equippable:SetOnUnequip(OnUnequip)
	end
end)