local MATERIALS_DRYICE = {name = "dryice", prefab = "polar_dryice", inv_suffix = "_moonglass"}

local function makepiece_dryice(name)
	local MATERIALS
	local materialid_dryice
	
	local OldOnEquip
	local function OnEquip(inst, owner, ...)
		if OldOnEquip then
			OldOnEquip(inst, owner, ...)
		end
		owner.AnimState:OverrideSymbol("swap_body", "swap_"..name.."_moonglass", "swap_body")
		owner.AnimState:SetSymbolHue("swap_body", 0.15)
		owner.AnimState:SetSymbolSaturation("swap_body", 0.48)
		owner.AnimState:SetSymbolBrightness("swap_body", 1.23)
	end
	
	local OldOnUnequip
	local function OnUnequip(inst, owner, ...)
		if OldOnUnequip then
			OldOnUnequip(inst, owner, ...)
		end
		owner.AnimState:SetSymbolHue("swap_body", 0)
		owner.AnimState:SetSymbolSaturation("swap_body", 1)
		owner.AnimState:SetSymbolBrightness("swap_body", 1)
	end
	
	--
	
	local function ChessPiecePreInit(inst)
		MATERIALS = PolarUpvalue(Prefabs[name.."_moonglass"].fn, "MATERIALS")
		materialid_dryice = MATERIALS and #MATERIALS or 3
		
		if MATERIALS and not table.contains(MATERIALS, MATERIALS_DRYICE) then
			table.insert(MATERIALS, MATERIALS_DRYICE)
			materialid_dryice = materialid_dryice + 1
		end
	end
	
	local function OnInit(inst)
		local build = "swap_"..name.."_moonglass"
		
		inst.AnimState:SetBuild(build)
		inst.components.lootdropper:SetLoot({MATERIALS_DRYICE.prefab})
		inst.components.symbolswapdata:SetData(build, "swap_body")
	end
	
	local function fn()
		local inst = Prefabs[name.."_moonglass"].fn()
		ChessPiecePreInit(inst)
		
		inst.AnimState:SetSymbolHue("swap_body", 0.15)
		inst.AnimState:SetSymbolSaturation("swap_body", 0.48)
		inst.AnimState:SetSymbolBrightness("swap_body", 1.23)
		
		if inst.prefab then -- NOTE: Reusing spawning prefab rather than unifying it later! Makes the dryice patch easier and won't cause big problems if mod is removed
			inst:SetPrefabNameOverride(inst.prefab)
			inst:SetPrefabName(inst.prefab.."_dryice")
		end
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		if materialid_dryice > 0 then
			inst.materialid = materialid_dryice
		end
		
		if inst.components.equippable then
			if OldOnEquip == nil then
				OldOnEquip = inst.components.equippable.onequipfn
			end
			if OldOnUnequip == nil then
				OldOnUnequip = inst.components.equippable.onunequipfn
			end
			
			inst.components.equippable:SetOnEquip(OnEquip)
			inst.components.equippable:SetOnUnequip(OnUnequip)
		end
		
		--[[inst:AddComponent("polarmistemitter")
		inst.components.polarmistemitter.maxmist = 8
		inst.components.polarmistemitter.scale = 1.5
		inst.components.polarmistemitter:StartMisting()]]
		
		inst:DoTaskInTime(0, OnInit)
		
		return inst
	end
	
	return Prefab(name.."_dryice", fn)
end

--

local chesspieces_prefs = {}

for k, v in pairs(AllRecipes) do
	if string.sub(v.name, 0, 11) == "chesspiece_" and string.sub(v.name, -8) == "_builder" then
		chesspieces_prefs[string.sub(v.name, 0, -9)] = true
	end
end

local prefs = {}
for chesspiece_name in pairs(chesspieces_prefs) do
	table.insert(prefs, makepiece_dryice(chesspiece_name))
end

return unpack(prefs)