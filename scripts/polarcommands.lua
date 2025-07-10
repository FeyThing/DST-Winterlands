local function ListingOrConsolePlayer(input)
	if type(input) == "string" or type(input) == "number" then
		return UserToPlayer(input)
	end
	
	return input or ConsoleCommandPlayer()
end



--	Toggle Blizzard
function c_blizzard(duration, in_cooldown)
	if TheWorld.components.polarstorm then
		local active = TheWorld.components.polarstorm:IsPolarStormActive()
		
		if active and (duration == nil or duration <= 0) then
			TheWorld.components.polarstorm:PushBlizzard(0)
			print("Removing Blizzard")
		elseif not active or (duration and duration > 0) then
			if in_cooldown then
				TheWorld.components.polarstorm:RequeueBlizzard(duration or 480)
				print("Blizzard will start in "..(duration and duration.." seconds" or "a day"))
			else
				TheWorld.components.polarstorm:PushBlizzard(duration or 480)
				print((active and "Changed Blizzard duration to " or "Activating Blizzard for ")..(duration and duration.." seconds" or "a day"))
			end
		end
	end
end

--	Gives the stuff to brave this frosty place
function c_polartime(player)
	player = ListingOrConsolePlayer(player)
	
	local items = {"antler_tree_stick", "torch", "shovel", "polarmoosehat", "raincoat", "log", "cutgrass", "twigs", "rocks", "smallmeat_dried"}
	if player then
		c_select(player)
		
		if player.components.inventory then
			for i, v in pairs(items) do
				local amt = i > 5 and 20 or 1
				local need, has = player.components.inventory:Has(v, amt)
				local item = c_give(v, amt - has, true)
				
				local equipslot = (item and item.components.equippable) and item.components.equippable.equipslot
				if equipslot and player.components.inventory:GetEquippedItem(equipslot) == nil then
					player.components.inventory:Equip(item, nil, true)
				end
			end
		end
	end
end

--	We love casting spellz
function c_icewizard(player)
	player = ListingOrConsolePlayer(player)
	
	local items = {"polaricestaff", "iciclestaff", "polarcrownhat", "frostwalkeramulet"}
	if player then
		c_select(player)
		
		if player.components.inventory then
			for i, v in ipairs(items) do
				local need, has = player.components.inventory:Has(v, 1)
				
				if has == 0 then
					local item = c_give(v, nil, true)
					
					local equipslot = (item and item.components.equippable) and item.components.equippable.equipslot
					if equipslot and player.components.inventory:GetEquippedItem(equipslot) == nil then
						player.components.inventory:Equip(item, nil, true)
					end
				end
			end
		end
	end
end

--	Get a free ice cube, and fish
function c_fishcube(name)
	if TheWorld.components.oceanfish_in_ice_spawner then
		local x, y, z = ConsoleWorldPosition():Get()
		TheWorld.components.oceanfish_in_ice_spawner:SpawnIceCubeAt(x, y, z, name)
	else
		print("World has no oceanfish_in_ice_spawner!")
	end
end

--	Time for arts and crafts
function c_teethnecklace(player)
	player = ListingOrConsolePlayer(player)
	
	local items = {"rope"}
	for k, v in pairs(POLARAMULET_PARTS) do
		if not v.ornament then
			table.insert(items, k)
		end
	end
	
	if player then
		c_select(player)
		
		if player.components.inventory then
			for i, v in ipairs(items) do
				local amt = v == "rope" and 9 or 3
				local need, has = player.components.inventory:Has(v, amt)
				
				c_give(v, amt - has, true)
			end
		end
	end
end

--	It tickles!
function c_addfleas(num, target)
	num = num or 1
	target = target or c_select()
	
	if target == nil or not target:IsValid() then
		return
	end
	
	local x, y, z = target.Transform:GetWorldPosition()
	for i = 1, num do
		local flea = SpawnPrefab("polarflea")
		flea.Transform:SetPosition(x, y, z)
		flea:SetHost(target)
	end
end

--	Force the next ice fishing result
function c_icefishingsurprise(name)
	if TheWorld.components.icefishingsurprise then
		TheWorld.components.icefishingsurprise.debug_surprise = name
	end
end

--	Spawn in the Emperor and his castle
function c_icecastle(despawn, layout)
	if TheWorld.components.emperorpenguinspawner then
		if despawn then
			TheWorld.components.emperorpenguinspawner:DespawnCastle()
		else
			local x, y, z = ConsoleWorldPosition():Get()
			local _pt = Vector3(x, y, z)
			
			local ice_ents = GetIceCastleRemovableEnts(_pt) -- postinit/prefabs/penguin
			for i, v in ipairs(ice_ents) do
				v:AddTag("penguinicepart")
			end
			
			local pt, valid = TheWorld.components.emperorpenguinspawner:GetValidCastlePos(Vector3(x, y, z))
			
			if valid then
				print(#ice_ents > 0 and "	Removing some stuff in vacinity:" or "Space is clear.")
				
				for i, v in ipairs(ice_ents) do
					print("		- Removed", v)
					v:Remove()
				end
				
				local spawned = TheWorld.components.emperorpenguinspawner:SpawnCastle(pt, layout)
				if spawned then
					TheWorld.components.emperorpenguinspawner:SpawnEmperor()
				end
			else
				for i, v in ipairs(ice_ents) do
					v:RemoveTag("penguinicepart")
				end
				
				print("Couldn't find space nearby for Ice Castle!")
			end
		end
	else
		print("Ice Castle can't be spawned in this world!")
	end
end	