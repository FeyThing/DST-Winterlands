local function ListingOrConsolePlayer(input)
	if type(input) == "string" or type(input) == "number" then
		return UserToPlayer(input)
	end
	
	return input or ConsoleCommandPlayer()
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

--	Toggle Blizzard
function c_blizzard(duration)
	if TheWorld.components.polarstorm then
		local active = TheWorld.components.polarstorm:IsPolarStormActive()
		
		if active and (duration == nil or duration <= 0) then
			TheWorld.components.polarstorm:PushBlizzard(0)
			print("Removing Blizzard")
		elseif not active or (duration and duration > 0) then
			TheWorld.components.polarstorm:PushBlizzard(duration or 480)
			print((active and "Changed Blizzard duration to " or "Activating Blizzard for ")..(duration and duration.." seconds" or "a day"))
		end
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