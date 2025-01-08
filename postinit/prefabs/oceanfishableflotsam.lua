local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldOnPicked
local function OnPicked(inst, ...)
	if inst.icefishingloot then
		local x, y, z = inst.Transform:GetWorldPosition()
		SpawnPrefab(inst.icefishingloot).Transform:SetPosition(x, y, z)
	end
	
	if OldOnPicked then
		return OldOnPicked(inst, ...)
	end
	
	return true
end

local OldOnSave
local function OnSave(inst, data, ...)
	if OldOnSave then
		OldOnSave(inst, data, ...)
	end
	data.icefishingloot = inst.icefishingloot
end

local OldOnLoad
local function OnLoad(inst, data, ...)
	if OldOnLoad then
		OldOnLoad(inst, data, ...)
	end
	if data and data.icefishingloot then
		inst:SetIceFishingLoot(data.icefishingloot)
	end
end

local function SetIceFishingLoot(inst, loot)
	inst.icefishingloot = loot
end

local function OnRemoved(inst)
	local floatsam_prefab = inst.prefab == "oceanfishableflotsam" and "oceanfishableflotsam_water" or "oceanfishableflotsam"
	local floatsam
	
	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 3)
	for i, v in pairs(ents) do
		if v.prefab == floatsam_prefab and v.icefishingloot == nil and v:GetTimeAlive() < 0.1 then
			floatsam = v
			break
		end
	end
	
	if floatsam and inst.icefishingloot then
		floatsam:SetIceFishingLoot(inst.icefishingloot)
	end
end

ENV.AddPrefabPostInit("oceanfishableflotsam", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.pickable then
		if OldOnPicked == nil then
			OldOnPicked = inst.components.pickable.onpickedfn
		end
		inst.components.pickable.onpickedfn = OnPicked -- TODO: won't work with haunting...
	end
	
	if not OldOnSave then
		OldOnSave = inst.OnSave
	end
	inst.OnSave = OnSave
	
	if not OldOnLoad then
		OldOnLoad = inst.OnLoad
	end
	inst.OnLoad = OnLoad
	
	inst.SetIceFishingLoot = SetIceFishingLoot
	
	inst:ListenForEvent("onremove", OnRemoved)
end)

--

local OldOnSalvage
local function OnSalvage(inst, ...)
	local product
	if OldOnSalvage then
		product = OldOnSalvage(inst, ...)
	end
	
	if product and inst.icefishingloot then
		product:SetIceFishingLoot(inst.icefishingloot)
	end
	
	return product
end

local Water_OldOnSave
local function Water_OnSave(inst, data, ...)
	if Water_OldOnSave then
		Water_OldOnSave(inst, data, ...)
	end
	data.icefishingloot = inst.icefishingloot
end

local Water_OldOnLoad
local function Water_OnLoad(inst, data, ...)
	if Water_OldOnLoad then
		Water_OldOnLoad(inst, data, ...)
	end
	if data and data.icefishingloot then
		inst:SetIceFishingLoot(data.icefishingloot)
	end
end

ENV.AddPrefabPostInit("oceanfishableflotsam_water", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.winchtarget then
		if OldOnSalvage == nil then
			OldOnSalvage = inst.components.winchtarget.salvagefn
		end
		inst.components.winchtarget:SetSalvageFn(OnSalvage)
	end
	
	if not Water_OldOnSave then
		Water_OldOnSave = inst.OnSave
	end
	inst.OnSave = Water_OnSave
	
	if not Water_OldOnLoad then
		Water_OldOnLoad = inst.OnLoad
	end
	inst.OnLoad = Water_OnLoad
	
	inst.SetIceFishingLoot = SetIceFishingLoot
	
	inst:ListenForEvent("onremove", OnRemoved)
end)