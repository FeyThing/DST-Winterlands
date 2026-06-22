local PocketWatchCommon = require("prefabs/pocketwatch_common")
local PlayerCommonExtensions = require("prefabs/player_common_extensions")

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

local function GetDebugAnim(target)
	local dbg = target:GetDebugString()
	
	if dbg then
		local anim = dbg:match("anim:%s*(%S+)")
		return anim
	end
	
	return nil
end

local function UpdateEquipped(inst, owner)
	if inst.components.skinner then
		inst.components.skinner:CopySkinsFromPlayer(owner)
	end
	
	inst._equipped = inst._equipped or {}
	local updated = {}
	
	for slot, item in pairs(owner.components.inventory.equipslots or {}) do
		local equipped = inst._equipped[slot]
		updated[slot] = true
		
		local valid = item and item:IsValid() and not item:HasTag("noafterimagecopy")
		if equipped and equipped:IsValid() then
			if not valid or (equipped.prefab ~= item.prefab) or (equipped:GetSkinName() ~= item:GetSkinName()) then
				if equipped.components.equippable:IsEquipped() then
					inst.components.inventory:Unequip(slot)
				end
				
				equipped:Remove()
				inst._equipped[slot] = nil
			end
		end
		
		if valid then
			if inst._equipped[slot] == nil then
				equipped = SpawnPrefab(item.prefab, item.skinname, item.skin_id)
			end
			
			if equipped then
				--equipped:SetPersistData(item:GetPersistData()) That wouuuld be better but also causes issues with certain items (like lanterns)
				if not equipped.components.equippable:IsEquipped() then
					inst.components.inventory:Equip(equipped)
				end
				
				if equipped.fx then
					if equipped.fx.pocketwatch_polar_active then
						equipped.fx.pocketwatch_polar_active:set(true)
					end
					
					if TheWorld.ismastersim then
						if equipped.fx.Activate_PocketwatchPolar then
							equipped.fx:Activate_PocketwatchPolar(true)
						end
					end
					
					equipped.persists = false
					equipped:Hide()
				end
			end
		end
		
		inst._equipped[slot] = equipped
	end
	
	for slot, equipped in pairs(inst._equipped) do
		if not updated[slot] then
			if equipped:IsValid() then
				if equipped.components.equippable:IsEquipped() then
					inst.components.inventory:Unequip(slot)
				end
				
				equipped:Remove()
			end
			
			inst._equipped[slot] = nil
		end
	end
end

local function RestartFade(inst)
	if inst.components.colourtweener == nil then
		inst:AddComponent("colourtweener")
	end
	
	inst.components.colourtweener:StartTween({0.63 + math.random() * 0.2, 0.7, 0.9, 0.3}, 0.2)
	inst:DoTaskInTime(0.21, function()
		inst.components.colourtweener:StartTween({0.2, 0.7, 0.9, 0}, 0.2, inst.Hide)
	end)
	
	for slot, item in pairs(inst.components.inventory.equipslots or {}) do
		if item and item.fx then
			if item.fx.pocketwatch_polar_dofade then
				item.fx.pocketwatch_polar_dofade:push()
			end
			
			if TheWorld.ismastersim then
				if item.fx.DoFade_PocketwatchPolar then
					item.fx:DoFade_PocketwatchPolar()
				end
			end
		end
	end
	
	inst:Show()
end

local function SetPuppetStyle(inst, data)
	local owner = data and data.owner
	
	if owner == nil or not owner:IsValid() or not owner.components.inventory then
		inst:Remove()
		return
	end
	
	inst:UpdateEquipped(owner)
	
	inst.Transform:SetPosition(owner.Transform:GetWorldPosition())
	inst.Transform:SetRotation(owner.Transform:GetRotation())
	
	local anim = GetDebugAnim(owner)
	if anim then
		inst.AnimState:PlayAnimation(anim, true)
		inst.AnimState:SetFrame(owner.AnimState:GetCurrentAnimationFrame() or 0)
	end
end

local function fx()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("wanda")
	inst.AnimState:SetFinalOffset(-6)
	inst.AnimState:UsePointFiltering(true)
	inst.AnimState:SetDeltaTimeMultiplier(0)
	inst.AnimState:SetAddColour(0.3, 0.52 + math.random() * 0.1, 0.85 + math.random() * 0.15, 0)
	inst.AnimState:SetMultColour(0, 0, 0, 0)
	inst.AnimState:SetScale(1 + math.random() * 0.15, 1 + math.random() * 0.15)
	inst.AnimState:SetLightOverride(0.1)
	inst.AnimState:SetErosionParams(0, math.random() * 0.5, 1)
	
	if PlayerCommonExtensions.SetupBaseSymbolVisibility then -- TODO: Remove this after WX skiltree beta
		PlayerCommonExtensions.SetupBaseSymbolVisibility(inst)
	end
	
	inst.SoundEmitter:OverrideVolumeMultiplier(0)
	
	inst:AddTag("afterimagefx")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("equipmentmodel")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bloomer")
	
	inst:AddComponent("colouradder")
	
	inst:AddComponent("colourtweener")
	
	inst:AddComponent("inventory")
	inst.components.inventory.maxslots = 0
	
	inst:AddComponent("skinner")
	inst.components.skinner:SetupNonPlayerData()
	
	inst.RestartFade = RestartFade
	inst.SetPuppetStyle = SetPuppetStyle
	inst.UpdateEquipped = UpdateEquipped
	
	inst.persists = false
	
	return inst
end

return Prefab("pocketwatch_polar", fn, assets),
	Prefab("wandatimefreeze_player_fx", fx)