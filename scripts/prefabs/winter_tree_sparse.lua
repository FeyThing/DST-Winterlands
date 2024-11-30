local assets = {
	Asset("ANIM", "anim/evergreen_new_2.zip"),
	Asset("ANIM", "anim/wintertree.zip"),
	Asset("ANIM", "anim/wintertree_build.zip"),
}

local function OnPolarDecorate(inst)
	if inst.components.container then
		for i = 1, inst.components.container:GetNumSlots() do
			if inst.components.container:GetItemInSlot(i) == nil then
				local item
				local rnd = math.random(6)
				
				if rnd == 1 then
					item = GetRandomBasicWinterOrnament()
				elseif rnd == 2 then
					item = GetRandomFancyWinterOrnament()
				elseif rnd == 3 then
					item = GetRandomLightWinterOrnament()
				end
				
				if item then
					local ornament = SpawnPrefab(item)
					inst.components.container:GiveItem(ornament, i)
				end
			end
		end
	end
end

local OldOnLoad
local function OnLoad(inst, data, ...)
	if OldOnLoad then
		OldOnLoad(inst, data, ...)
	end
	
	if data and data.polar_decorate then
		inst:OnPolarDecorate()
	end
end

local function fn()
	local inst = Prefabs.winter_tree.fn()
	
	inst.AnimState:SetBuild("evergreen_new_2")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.OnPolarDecorate = OnPolarDecorate
	
	if OldOnLoad == nil then
		OldOnLoad = inst.OnLoad
	end
	inst.OnLoad = OnLoad
	
	return inst
end

return Prefab("winter_tree_sparse", fn, assets)