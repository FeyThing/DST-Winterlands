--	[[	To Server	]]	--

--	Ask coordinates for Chilly Compass to point at
AddModRPCHandler("Winterlands", "PolarCaveEntrance_GetPos", function(player)
	if player then
		local entrance = TheSim:FindFirstEntityWithTag("polarcave_entrance")
		local pt = entrance and entrance:GetPosition()
		
		SendModRPCToClient(GetClientModRPC("Winterlands", "PolarCaveEntrance_SetPos"), player.userid, player, pt and pt.x or nil, pt and pt.z or nil)
	end
end)

--	Apply the emoting player camera angle to the Snow Angel
AddModRPCHandler("Winterlands", "SnowAngel_SetOwnerRotation", function(player, angel, rot)
	if angel and rot then
		angel.Transform:SetRotation(rot)
	end
end)

--	Removing Arctic Fools' Fish from the player back (from Self-inspect)
AddModRPCHandler("Winterlands", "UnstickArticFoolFish", function(player)
	if player and player.RemoveArcticFoolFish then
		player:RemoveArcticFoolFish()
	end
end)

--	Player caught in Bear Trap has pushed struggle "action"...
AddModRPCHandler("Winterlands", "WalrusTrap_Remove", function(player, isblink, act_x, act_y, act_z, use_invobject, has_target)
	if player and player.AnimState:IsCurrentAnimation("beartrap_snared_loop") then
		local x, y, z = player.Transform:GetWorldPosition()
		
		if isblink then
			local invobject = (use_invobject and player.components.inventory) and player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			local pos = Vector3(act_x, act_y, act_z)
			local act = BufferedAction(player, nil, ACTIONS.BLINK, invobject, pos)
			
			player:FacePoint(pos)
			player:PushBufferedAction(act)
		elseif y <= 2 then
			player:PushEvent("walrus_beartrapped", {doer = player, struggle = true})
		end
	end
end)

--	[[	To Client	]]	--

--	Send coordinates for Chilly Compass overlay (TODO: Later, also point at [SPOILER], after cave has been opened up)
AddClientModRPCHandler("Winterlands", "PolarCaveEntrance_SetPos", function(player, x, z)
	if player then
		local data = {}
		if x and z then
			data.pt = Vector3(x, 0, z)
		end
		
		player:PushEvent("polarcave_compass_get_position", data)
	end
end)