local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

--	Sculpting Table

local sculptable_materials

local oldgiveitem
local function giveitem(inst, itemname, ...)
	if inst.chesspiece_dryice then
		inst.AnimState:SetSymbolHue("swap_body", 0)
		inst.AnimState:SetSymbolSaturation("swap_body", 1)
		inst.AnimState:SetSymbolBrightness("swap_body", 1)
		inst.chesspiece_dryice = nil
	end
	
	if oldgiveitem then
		oldgiveitem(inst, itemname, ...)
	end
	
	if itemname and itemname:sub(1, 11) == "chesspiece_" and itemname:sub(-7) == "_dryice" then
		inst.AnimState:SetSymbolHue("swap_body", 0.15)
		inst.AnimState:SetSymbolSaturation("swap_body", 0.48)
		inst.AnimState:SetSymbolBrightness("swap_body", 1.23)
		
		local build = "swap_"..itemname:gsub("_dryice$", "_moonglass")
		inst.AnimState:OverrideSymbol("swap_body", build, "swap_body")
		
		inst.chesspiece_dryice = true
	end
end

local OldCreateItem
local function CreateItem(inst, item, ...)
	local base_ingredient
	if inst.components.pickable then
		base_ingredient = inst.components.pickable.caninteractwith and inst.components.pickable.product or nil
	end
	
	if OldCreateItem then
		OldCreateItem(inst, item, ...)
	end
end

AddPrefabPostInit("sculptingtable", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.inspectable and sculptable_materials == nil then
		sculptable_materials = PolarUpvalue(inst.components.inspectable.getstatus, "sculptable_materials")
	end
	if sculptable_materials and sculptable_materials["polar_dryice"] == nil then
		sculptable_materials["polar_dryice"] = {swapfile = "polar_dryice", symbol = "dryice", material = "dryice"}
	end
	
	if inst.OnLoad and oldgiveitem == nil then
		oldgiveitem = PolarUpvalue(inst.OnLoad, "giveitem")
		
		PolarUpvalue(inst.OnLoad, "giveitem", giveitem)
	end
	if not OldCreateItem then
		OldCreateItem = inst.CreateItem
	end
	inst.CreateItem = CreateItem
end)

--	Winch

local function OnItemGet(inst, data)
	local item = data and data.item
	
	if item and item.prefab:sub(1, 11) == "chesspiece_" and item.prefab:sub(-7) == "_dryice" then
		inst.AnimState:SetSymbolHue("swap_body", 0.15)
		inst.AnimState:SetSymbolSaturation("swap_body", 0.48)
		inst.AnimState:SetSymbolBrightness("swap_body", 1.23)
	end
end

local function OnItemLose(inst, data)
	local item = data and data.item
	
	if item and item.prefab:sub(1, 11) == "chesspiece_" and item.prefab:sub(-7) == "_dryice" then
		inst.AnimState:SetSymbolHue("swap_body", 0)
		inst.AnimState:SetSymbolSaturation("swap_body", 1)
		inst.AnimState:SetSymbolBrightness("swap_body", 1)
	end
end

AddPrefabPostInit("winch", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:ListenForEvent("itemget", OnItemGet)
	inst:ListenForEvent("itemlose", OnItemLose)
end)

--	Mighty Gym (component postinit)