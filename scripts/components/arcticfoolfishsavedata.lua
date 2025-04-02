return Class(function(self, inst)
	assert(TheWorld.ismastersim, "Arctic Fool Fish save data should not exist on client")
	self.inst = inst
	
	local arctic_fool_fishes = {}
	
	function self:UpdateArcticFoolFish(fish, target, enable)
		if enable then
			arctic_fool_fishes[fish] = target
		else
			arctic_fool_fishes[fish] = nil
		end
	end
	
	function self:GetFishForTarget(target)
		for fish, _target in pairs(arctic_fool_fishes) do
			if target == _target then
				return fish
			end
		end
	end
	
	function self:OnSave()
		local data = {
			targets = {},
		}
		local ents = {}
		
		for fish, target in pairs(arctic_fool_fishes) do
			if fish and fish:IsValid() and target and target:IsValid() then
				table.insert(ents, target.GUID)
				
				data.targets[target.GUID] = fish.components.arcticfoolfish.pranker_id
			end
		end
		
		return data, ents
	end
	
	function self:LoadPostPass(newents, savedata)
		if savedata and savedata.targets then
			for target_guid, player_userid in pairs(savedata.targets) do
				if newents[target_guid] then
					local target = newents[target_guid].entity
					
					local fish = SpawnPrefab("arctic_fool_fish")
					local back = fish.components.arcticfoolfish:StickOnBack(target)
					
					if back and back.components.arcticfoolfish then
						back.components.arcticfoolfish.pranker_id = player_userid
					end
				end
			end
		end
	end
end)