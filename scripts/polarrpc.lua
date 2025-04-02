AddModRPCHandler("Winterlands", "UnstickArticFoolFish", function(player)
	if player and player.RemoveArcticFoolFish then
		player:RemoveArcticFoolFish()
	end
end)