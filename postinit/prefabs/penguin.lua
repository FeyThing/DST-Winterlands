local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local CASTLE_FLOOR_TAGS = {"polarcastlefloor"}
local ICE_ENTS_TAGS = {"plant", "frozen", "flower"}
local ICE_ENTS_NOT_TAGS = {"character", "INLIMBO", "irreplaceable", "structure", "wall"}

local penguin_prefabs = {
	"penguin",
	"penguin_ice",
	"penguinherd",
	"mutated_penguin",
	"rock_ice",
}

--	Emperor Castle gets spawned from existing colonies when re-visited, chances grow as the season goes

function GetIceCastleRemovableEnts(pt)
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 16, nil, ICE_ENTS_NOT_TAGS, ICE_ENTS_TAGS)
	
	return ents
end

local function OnEntityWake(inst)
	local pt = inst:GetPosition()
	
	if FindEntity(inst, 8, nil, CASTLE_FLOOR_TAGS) then
		inst:Remove() -- penguinspawner keeps respawning penguin_ice on load, we don't want it to stay under the castle !
		return
	end
	
	local ice_ents = GetIceCastleRemovableEnts(pt)
	table.insert(ice_ents, inst)
	
	for i, v in ipairs(ice_ents) do
		v:AddTag("penguinicepart")
	end
	
	if TheWorld.components.emperorpenguinspawner and TheWorld.components.emperorpenguinspawner:TrySpawnCastleAtColony(inst) then
		print(#ice_ents > 0 and "	Removing some stuff in vacinity:" or "Space is clear.")
		for i, v in ipairs(ice_ents) do
			print("		- Removed", v)
			v:Remove()
		end
	else
		for i, v in ipairs(ice_ents) do
			v:RemoveTag("penguinicepart")
		end
	end
end

--	Penguin rookery stuff gets removed inside of the Winterlands, we rely on our own pengull/herd entities to stay outside of winter

local function OnPolarInit(inst)
	local pt = inst:GetPosition()
	
	if GetClosestPolarTileToPoint(pt.x, pt.y, pt.z, 32) ~= nil and (inst.prefab ~= "rock_ice" or inst.remove_on_dryup) then
		inst:Hide()
		inst:DoTaskInTime(0.1, inst.Remove)
	end
end

-- Penguins shouldn't die and drop their loot when drowning, make them sink (but not really)

local function OnPolarFreeze(inst, forming)
	if not forming then
		inst:Remove()
	end
end

--	Penguins only defend each others if part of the same "herd", we don't want that in the castle or nearby guards

local function OnAttacked_Castle(inst, data)
	local attacker = data and data.attacker
	
	if inst.components.combat and attacker and attacker:IsValid() and not (attacker.components.health and attacker.components.health:IsDead()) then
		inst.components.combat:ShareTarget(attacker, 20, function(dude)
			return dude:HasTag("penguin_guard") and not (dude.components.health and dude.components.health:IsDead())
		end, 5)
		
		if TheWorld.components.emperorpenguinspawner then
			TheWorld.components.emperorpenguinspawner:ProvokeCastle(inst, attacker)
		end
	end
end

--

for i, v in ipairs(penguin_prefabs) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		if v == "penguin" then
			inst.OnPolarFreeze = OnPolarFreeze
			
			inst:ListenForEvent("attacked", OnAttacked_Castle)
		elseif v == "penguin_ice" then
			inst:ListenForEvent("entitywake", OnEntityWake)
		end
		
		inst:DoTaskInTime(0, OnPolarInit)
	end)
end