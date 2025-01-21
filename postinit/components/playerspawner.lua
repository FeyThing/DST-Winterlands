local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("playerspawner", function(self)
	local _polarpts = {}
	
	local function UnregisterPolarPoint(spawnpt)
		table.removearrayvalue(_polarpts, spawnpt)
	end
	
	local function OnRegisterPolarPoint(inst, spawnpt)
		if not table.contains(_polarpts, spawnpt) then
			table.insert(_polarpts, spawnpt)
		end
		
		inst:ListenForEvent("onremove", UnregisterPolarPoint, spawnpt)
	end
	
	local CAMPFIRE_TAGS = {"campfire"}
	
	function self:PolarSpawnWelcome(player, x, y, z)
		local ents = TheSim:FindEntities(x, y, z, 8, CAMPFIRE_TAGS)
		local fire
		
		for i, v in ipairs(ents) do
			if v.prefab == "campfire" and v.components.fueled and not v.components.fueled:IsEmpty() then
				fire = v
			end
		end
		
		if fire == nil then
			local pt = Vector3(x, y, z)
			local offset = FindWalkableOffset(pt, TWOPI * math.random(), 4, 8)
			
			if offset then
				fire = SpawnPrefab("campfire")
				fire.Transform:SetPosition((pt + offset):Get())
				
				if fire.components.fueled then
					fire.components.fueled:SetPercent(0.2)
				end
			end
		end
		
		player:DoTaskInTime(0, function()
			if player.sg and player.sg:HasStateTag("idle") then
				player.sg:GoToState("polarspawn")
			end
		end)
		
		if fire == nil or not fire:IsValid() or fire.components.fueled == nil or fire.components.fueled:GetPercent() >= 0.7 then
			return
		end
		
		fire:DoTaskInTime(1, function() SpawnPrefab("sanity_raise").Transform:SetPosition(fire.Transform:GetWorldPosition()) end)
		fire:DoTaskInTime(1.4, function() fire.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel") end)
		fire:DoTaskInTime(1.6, function() fire.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel") fire.components.fueled:SetPercent(0.7) end)
	end
	
	local OldSpawnAtLocation = self.SpawnAtLocation
	function self:SpawnAtLocation(inst, player, x, y, z, isloading, ...)
		local moonportal = TheSim:FindFirstEntityWithTag("moontrader")
		local polarpt
		
		if not moonportal and not isloading and #_polarpts > 0 then
			polarpt = _polarpts[math.random(#_polarpts)]
			x, y, z = polarpt.Transform:GetWorldPosition()
		end
		
		OldSpawnAtLocation(self, inst, player, x, y, z, isloading, ...)
		if polarpt then
			player.Transform:SetPosition(x, y, z)
			self:PolarSpawnWelcome(player, x, y, z)
		end
	end
	
	self.inst:ListenForEvent("ms_registerspawnpoint_polar", OnRegisterPolarPoint)
end)