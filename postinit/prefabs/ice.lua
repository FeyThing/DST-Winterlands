local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddPrefabPostInit("ice", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.repairer then
		if inst.components.repairer.healthrepairvalue == 0 then
			inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH
		end
		
		inst.components.repairer.boatrepairsound = inst.components.repairer.boatrepairsound or "dontstarve_DLC001/common/iceboulder_hit"
	end
end)