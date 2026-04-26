--------------------------------------------------------------------------
--[[ Basic skin functions ]]
--------------------------------------------------------------------------
antler_tree_stick_init_fn = function(inst, build_name)
	basic_init_fn(inst, build_name, "antler_tree_stick")
	
	local sounds = SKIN_SOUND_FX[inst:GetSkinName()]
	if sounds then
		inst.hit_skin_sound = sounds.hit
	end
end

antler_tree_stick_clear_fn = function(inst)
	basic_clear_fn(inst, "antler_tree_stick")
	
	inst.hit_skin_sound = nil
end

polarmoosehat_init_fn = function(inst, build_name) basic_init_fn(inst, build_name, "hat_polarmoose") end
polarmoosehat_clear_fn = function(inst) basic_clear_fn(inst, "hat_polarmoose") end

polarbear_rug_init_fn = function(inst, build_name) basic_init_fn(inst, build_name, "polarbear_rug") end
polarbear_rug_clear_fn = function(inst) basic_clear_fn(inst, "polarbear_rug") end

polarflea_init_fn = function(inst, build_name) end -- Mainly for stackability control purposes
polarflea_clear_fn = function(inst) end

--------------------------------------------------------------------------
--[[ Mob Heads skin functions ]]
--------------------------------------------------------------------------
function polarheadstick_init_fn(inst, build_name)
	if inst.components.constructionsite and inst.material_loaded then
		inst.components.constructionsite:DropAllMaterials()
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
		if inst.components.constructionsite == nil then
			inst:AddComponent("constructionsite")
		end
		inst.components.constructionsite:SetConstructionPrefab("construction_container")
		inst.components.constructionsite:SetOnConstructedFn(inst.Stick_OnConstructed)
	end
end

function polarheadstick_clear_fn(inst)
	inst:SetPrefabName("polarheadstick")
	
	inst.constructionname = "polarbearhead"
end