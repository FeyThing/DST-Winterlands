local assets = {
	Asset("ANIM", "anim/warg_polar.zip"),
}

local prefabs = Prefabs.warg.deps

local OldSimulateKoalefantDrops = SimulateKoalefantDrops
function SimulateKoalefantDrops(inst, ...)
	if IsInPolar(inst) then
		for i = 1, 2 do
			local loot = SpawnPrefab("meat")
			inst.components.lootdropper:FlingItem(loot)
		end
		if math.random() < 0.5 then
			local loot = SpawnPrefab("trunk_winter")
			inst.components.lootdropper:FlingItem(loot)
		end
	else
		OldSimulateKoalefantDrops(inst, ...)
	end
end

local CARCASS_TAGS = {"meat_carcass"}

local function OnPolarInit(inst)
	if inst.event_listeners.spawnedforhunt and inst.event_listeners.spawnedforhunt[inst] then
		local OldOnSpawnedForHunt = inst.event_listeners.spawnedforhunt[inst][1]
		inst.event_listeners.spawnedforhunt[inst][1] = function(src, data, ...)
			if IsInPolar(inst) and OldOnSpawnedForHunt then
				OldOnSpawnedForHunt(src, data, ...)
				
				local carcass = GetClosestInstWithTag(CARCASS_TAGS, inst, 4)
				if carcass and carcass.MakeWinter and not carcass.winter then
					carcass:MakeWinter()
				end
			end
		end
	end
end

local OldOnSpawnedForHunt
local function OnSpawnedForHunt(inst, data, ...)
	if OldOnSpawnedForHunt then
		OldOnSpawnedForHunt(inst, data, ...)
	end
	
	if IsInPolar(inst) then
		local carcass = GetClosestInstWithTag(CARCASS_TAGS, inst, 4)
		if carcass and carcass.MakeWinter and not carcass.winter then
			carcass:MakeWinter()
		end
	end
end

local FREEZABLE_TAGS = {"freezable"}
local NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO"}

local function DoIceExplosion(inst)
	if inst.components.freezable == nil then
		MakeMediumFreezableCharacter(inst, "hound_body")
	end
	inst.components.freezable:SpawnShatterFX()
	
	inst:RemoveComponent("freezable")
	
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 4, FREEZABLE_TAGS, NO_TAGS)
	
	for i, v in pairs(ents) do
		if v.components.freezable then
			v.components.freezable:AddColdness(8)
		end
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/icehound_explo")
end

local function DoForceBreath(inst)
	if inst.components.frostybreather and inst.sg and not inst.sg:HasStateTag("busy") then
		inst.components.frostybreather:EmitOnce()
	end
end

local function fn()
	local inst = Prefabs.warg.fn()
	
	inst.AnimState:SetBuild("warg_polar")
	
	inst:AddComponent("frostybreather")
	inst.components.frostybreather.offset = Vector3(1.3, 1.4, 0)
	inst.components.frostybreather:StartBreath()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.combat:SetDefaultDamage(TUNING.POLARWARG_DAMAGE)
	
	inst.components.health:SetMaxHealth(TUNING.POLARWARG_HEALTH)
	
	inst:RemoveComponent("freezable")
	
	if inst.event_listeners.spawnedforhunt and inst.event_listeners.spawnedforhunt[inst] then
		if OldOnSpawnedForHunt == nil then
			OldOnSpawnedForHunt = inst.event_listeners.spawnedforhunt[inst][1]
		end
		inst.event_listeners.spawnedforhunt[inst][1] = OnSpawnedForHunt
	end
	
	inst._breathtask = inst:DoPeriodicTask(2, DoForceBreath)
	
	inst:ListenForEvent("death", DoIceExplosion)
	
	return inst
end

return Prefab("polarwarg", fn, assets, prefabs)