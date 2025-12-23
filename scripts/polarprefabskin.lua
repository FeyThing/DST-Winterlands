--------------------------------------------------------------------------
--[[ Basic skin functions ]]
--------------------------------------------------------------------------
polarmoosehat_init_fn = function(inst, build_name) basic_init_fn(inst, build_name, "hat_polarmoose") end
polarmoosehat_clear_fn = function(inst) basic_clear_fn(inst, "hat_polarmoose") end

--------------------------------------------------------------------------
--[[ Mob Heads skin functions ]]
--------------------------------------------------------------------------
function polarheadstick_init_fn(inst, build_name)
	if inst.components.constructionsite then
		inst:RemoveComponent("constructionsite")
	end
	
	if build_name == "pig_head" then
		inst:SetPrefabName("polarheadstick_pig")
		
		inst.constructionname = "pighead"
	elseif build_name == "merm_head" then
		inst:SetPrefabName("polarheadstick_merm")
		
		inst.constructionname = "mermhead"
	elseif build_name == "polarwalrus_head" then
		inst:SetPrefabName("polarheadstick_walrus")
		
		inst.constructionname = "polarwalrushead"
	end
	
	if inst.net_constructionname then
		inst.net_constructionname:set(inst.constructionname)
	end
	
	if inst.Stick_OnConstructed then
		inst:AddComponent("constructionsite")
		inst.components.constructionsite:SetConstructionPrefab("construction_container")
		inst.components.constructionsite:SetOnConstructedFn(inst.Stick_OnConstructed)
	end
end

function polarheadstick_clear_fn(inst)
	inst:SetPrefabName("polarheadstick")
	
	inst.constructionname = "polarbearhead"
end