local PocketWatchCommon = require "prefabs/pocketwatch_common"

local assets = {
	Asset("ANIM", "anim/pocketwatch_polar.zip"),
}

local function DoCastSpell(inst, doer)
	local health = doer.components.health
	
	if health and not health:IsDead() then
		doer:AddDebuff("buff_wandatimefreeze", "buff_wandatimefreeze", {bypass_frozenstats = true})
		if doer.components.oldager then
			doer.components.oldager:StopDamageOverTime()
		end
		
		local fx = SpawnPrefab((doer.components.rider ~= nil and doer.components.rider:IsRiding()) and "pocketwatch_polar_fx_mount" or "pocketwatch_polar_fx")
		fx.entity:SetParent(doer.entity)
		
		inst.components.rechargeable:Discharge(TUNING.POCKETWATCH_POLAR_COOLDOWN)
		return true
	end
end

local MOUNTED_CAST_TAGS = {"pocketwatch_mountedcast"}

local function fn()
	local inst = PocketWatchCommon.common_fn("pocketwatch", "pocketwatch_polar", DoCastSpell, true, MOUNTED_CAST_TAGS)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.castfxcolour = {174 / 255, 174 / 255, 244 / 255}
	
	return inst
end

--

local EQUIPS_SYM_OVERRIDE = {
	swap_hat 		= EQUIPSLOTS.HEAD,
	swap_body 		= EQUIPSLOTS.BODY,
	swap_body_tall 	= EQUIPSLOTS.BODY,
	swap_object 	= EQUIPSLOTS.HANDS,
	lantern_overlay = EQUIPSLOTS.HANDS,
}

local function GetDebugAnim(target) -- Too much asked to get just the current anim I guess
	local dbg = target:GetDebugString()
	
	if dbg then
		local anim = dbg:match("anim:%s*(%S+)")
		return anim
	end
	
	return nil
end

local function SetPuppetStyle(inst, data)
	local doer = data and data.doer
	
	if doer and inst.components.skinner then
		inst.components.skinner:CopySkinsFromPlayer(doer)
		local anim = GetDebugAnim(doer)
		if anim then
			inst.AnimState:PlayAnimation(anim, true)
		end
		
		if data.z then
			inst.Transform:SetPosition(data.x, data.y, data.z)
		end
		inst.Transform:SetRotation(doer.Transform:GetRotation())
		
		for sym, equipslot in pairs(EQUIPS_SYM_OVERRIDE) do
			local build_override, sym_override = doer.AnimState:GetSymbolOverride(sym)
			local item = doer.components.inventory and doer.components.inventory:GetEquippedItem(equipslot)
			local hastool = nil
			
			if sym == "swap_hat" then
				if sym_override then
					inst.AnimState:Show("HAT")
					inst.AnimState:Show("HAIR_HAT")
					inst.AnimState:Hide("HAIR_NOHAT")
					inst.AnimState:Hide("HAIR")
					inst.AnimState:Hide("HEAD")
					inst.AnimState:Show("HEAD_HAT")
					inst.AnimState:Show("HEAD_HAT_NOHELM")
					inst.AnimState:Hide("HEAD_HAT_HELM")
				else
					inst.AnimState:Hide("HAT")
					inst.AnimState:Hide("HAIR_HAT")
					inst.AnimState:Show("HAIR_NOHAT")
					inst.AnimState:Show("HAIR")
					inst.AnimState:Show("HEAD")
					inst.AnimState:Hide("HEAD_HAT")
					inst.AnimState:Hide("HEAD_HAT_NOHELM")
					inst.AnimState:Hide("HEAD_HAT_HELM")
				end
			elseif (sym == "swap_object" or sym == "lantern_overlay") and not hastool then
				if sym_override then
					hastool = true
					inst.AnimState:Show("ARM_carry")
					inst.AnimState:Hide("ARM_normal")
				elseif not item then
					inst.AnimState:Hide("ARM_carry")
					inst.AnimState:Show("ARM_normal")
				end
			end
			
			if item then
				local build_override, sym_override = doer.AnimState:GetSymbolOverride(sym)
				
				if sym_override then
					local skin_name = item:GetSkinName() or item.skinname
					local skin_build = skin_name and GetBuildForItem(skin_name)
					
					if skin_build then
						inst.AnimState:OverrideItemSkinSymbol(sym, skin_build, sym, item.GUID, item.AnimState:GetBuild())
					else
						inst.AnimState:OverrideSymbol(sym, build_override, sym_override)
					end
				end
			end
		end
		
		inst.AnimState:SetFrame(doer.AnimState:GetCurrentAnimationFrame())
		inst.AnimState:Pause()
	end
end

local function fx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("wanda")
	inst.AnimState:SetFinalOffset(-6)
	inst.AnimState:SetAddColour(0.3, 0.52 + math.random() * 0.1, 0.85 + math.random() * 0.15, 0)
	inst.AnimState:SetMultColour(0, 0, 0, 0)
	inst.AnimState:SetScale(1 + math.random() * 0.15, 1 + math.random() * 0.15)
	inst.AnimState:SetLightOverride(0.1)
	inst.AnimState:SetErosionParams(0, math.random() * 0.5, 1)
	
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("colourtweener")
	inst.components.colourtweener:StartTween({0.63 + math.random() * 0.2, 0.7, 0.9, 0.3}, 0.2)
	
	inst:AddComponent("skinner")
	inst.components.skinner:SetupNonPlayerData()
	
	inst.SetPuppetStyle = SetPuppetStyle
	
	inst:DoTaskInTime(0.21, function()
		inst.components.colourtweener:StartTween({0.2, 0.7, 0.9, 0}, 0.2, inst.Remove)
	end)
	
	inst.persists = false
	
	return inst
end

return Prefab("pocketwatch_polar", fn, assets),
	Prefab("wandatimefreeze_player_fx", fx)