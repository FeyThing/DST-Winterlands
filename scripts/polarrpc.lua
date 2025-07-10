AddModRPCHandler("Winterlands", "UnstickArticFoolFish", function(player)
	if player and player.RemoveArcticFoolFish then
		player:RemoveArcticFoolFish()
	end
end)

AddModRPCHandler("Winterlands", "PolarCaveEntrance_GetPos", function(player)
	if player then
		local entrance = TheSim:FindFirstEntityWithTag("polarcave_entrance")
		local pt = entrance and entrance:GetPosition()
		
		SendModRPCToClient(GetClientModRPC("Winterlands", "PolarCaveEntrance_SetPos"), player.userid, player, pt and pt.x or nil, pt and pt.z or nil)
	end
end)

AddClientModRPCHandler("Winterlands", "PolarCaveEntrance_SetPos", function(player, x, z)
	if player then
		local data = {}
		if x and z then
			data.pt = Vector3(x, 0, z)
		end
		
		player:PushEvent("polarcave_compass_get_position", data)
	end
end)