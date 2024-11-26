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
				local item = c_give(v, amt - has)
				
				local equipslot = (item and item.components.equippable) and item.components.equippable.equipslot
				if equipslot and player.components.inventory:GetEquippedItem(equipslot) == nil then
					player.components.inventory:Equip(item, nil, true)
				end
			end
		end
	end
end