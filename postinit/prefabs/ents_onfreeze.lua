local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPolarFreezeKelp(inst, forming)
	local replace_pref = forming and "bullkelp_beachedroot" or "bullkelp_plant"
	if replace_pref ~= inst.prefab then
		inst = ReplacePrefab(inst, replace_pref)
	end
	
	if inst.components.pickable then
		inst.components.pickable:MakeEmpty()
	end
end

local function OnPolarFreezeWaterplant(inst, forming)
	if forming then
		local pos = inst:GetPosition()
		inst.components.lootdropper:SpawnLootPrefab("waterplant_planter", pos)

		local rock = SpawnPrefab("waterplant_rock")
		rock.Transform:SetPosition(inst.Transform:GetWorldPosition())

		inst.base:Remove()
		inst:Remove()

		DestroyEntity(rock, TheWorld, false, true)
	end
end

local function OnPolarFreezeCookieCutter(inst, forming)
	if forming then
		inst:Remove()
	end
end

local function OnPolarFreezeBoatFragment(inst, forming)
	if forming then
		DestroyEntity(inst, TheWorld)
	end
end

local SEASTUFF = {
	bullkelp_beachedroot = OnPolarFreezeKelp,
	bullkelp_plant = OnPolarFreezeKelp,
	waterplant = OnPolarFreezeWaterplant,
	cookiecutter = OnPolarFreezeCookieCutter,
	boatfragment03 = OnPolarFreezeBoatFragment,
	boatfragment04 = OnPolarFreezeBoatFragment,
	boatfragment05 = OnPolarFreezeBoatFragment,
}

for prefab, fn in pairs(SEASTUFF) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst.OnPolarFreeze = fn
	end)
end