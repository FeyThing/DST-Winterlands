local function OnInitPolarStaff(inst)
	if inst.components.pickable then
		local staff = inst.components.pickable.product
		
		if staff == "iciclestaff" or staff == "polaricestaff" then
			inst.AnimState:OverrideSymbol("swap_staffs", "polarstaffs", "swap_"..staff)
		end
	end
	
	inst._initpolarstaff = nil
end

AddPrefabPostInit("moonbase", function(inst)
	inst.testpolarstaff = function(inst, data)
		if data and data.item then
			local staff = data.item.prefab
			
			if staff == "iciclestaff" or staff == "polaricestaff" then
				inst.AnimState:OverrideSymbol("swap_staffs", "polarstaffs", "swap_"..staff)
			end
		end
	end
	
	inst._initpolarstaff = inst:DoTaskInTime(0, OnInitPolarStaff)
	
	inst:ListenForEvent("trade", inst.testpolarstaff)
end)