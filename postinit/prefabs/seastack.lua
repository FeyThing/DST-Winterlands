local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnKelpFreeze(inst, forming)
	local replace_pref = forming and "bullkelp_beachedroot" or "bullkelp_plant"
	if replace_pref ~= inst.prefab then
		inst = ReplacePrefab(inst, replace_pref)
	end
	
	if inst.components.pickable then
		inst.components.pickable:MakeEmpty()
	end
end

local function OnPolarFreeze(inst, forming)
	if forming then
		DestroyEntity(inst, TheWorld, true, true)
	end
end

local SEASTUFF = {
	bullkelp_beachedroot = OnKelpFreeze,
	bullkelp_plant = OnKelpFreeze,
	seastack = OnPolarFreeze,
	wobster_den = OnPolarFreeze,
	moonglass_wobster_den = OnPolarFreeze,
}

for prefab, fn in pairs(SEASTUFF) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst.OnPolarFreeze = fn
	end)
end