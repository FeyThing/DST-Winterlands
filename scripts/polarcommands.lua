local function ListingOrConsolePlayer(input)
	if type(input) == "string" or type(input) == "number" then
		return UserToPlayer(input)
	end
	
	return input or ConsoleCommandPlayer()
end

--	Gives the stuff to brave this frosty place
function c_polartime(player)
	player = ListingOrConsolePlayer(player)
	
	local items = {spear = 1, walking_stick = 1, torch = 1, beefalohat = 1, raincoat = 1, log = 20, cutgrass = 20, twigs = 20, rocks = 20, smallmeat_dried = 10}
	if player then
		c_select(player)
		
		if player.components.inventory then
			for k, v in pairs(items) do
				local need, has = player.components.inventory:Has(k, v)
				local item = c_give(k, v - has)
				
				local equipslot = (item and item.components.equippable) and item.components.equippable.equipslot
				if equipslot and player.components.inventory:GetEquippedItem(equipslot) == nil then
					player.components.inventory:Equip(item, nil, true)
				end
			end
		end
	end
end