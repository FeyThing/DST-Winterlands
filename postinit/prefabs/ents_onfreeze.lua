local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- This is for stuff that gets ice formed over (naturally or with Chillest Amulet), if we expect special behaviors or conditional DestroyEntity

local function OnFreeze_Ignore(inst, forming)
	-- do nothing
end

local function OnFreeze_DestroyOnForming(inst, forming)
	if forming then
		DestroyEntity(inst, TheWorld)
	end
end

local function OnFreeze_RemoveOnForming(inst, forming)
	if forming then
		inst:Remove()
	end
end

--

local function OnFreeze_Kelp(inst, forming)
	local replace_pref = forming and "bullkelp_beachedroot" or "bullkelp_plant"
	if replace_pref ~= inst.prefab then
		inst = ReplacePrefab(inst, replace_pref)
	end
	
	if inst.components.pickable then
		inst.components.pickable:MakeEmpty()
	end
end

local function OnFreeze_Waterplant(inst, forming)
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

local function OnFreeze_SaltStack(inst, forming)
	if forming and inst.components.workable and inst.components.workable:CanBeWorked() then
		inst.components.workable:Destroy(TheWorld)
	end
end

local SEASTUFF = {
	bullkelp_beachedroot = OnFreeze_Kelp,
	bullkelp_plant = OnFreeze_Kelp,
	waterplant = OnFreeze_Waterplant,
	saltstack = OnFreeze_SaltStack,
	--
	cookiecutter = OnFreeze_RemoveOnForming,
	boatfragment03 = OnFreeze_DestroyOnForming,
	boatfragment04 = OnFreeze_DestroyOnForming,
	boatfragment05 = OnFreeze_DestroyOnForming,
	fishschoolspawnblocker = OnFreeze_Ignore,
}

for prefab, fn in pairs(SEASTUFF) do
	ENV.AddPrefabPostInit(prefab, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst.OnPolarFreeze = fn
	end)
end