local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddPrefabPostInit("ice", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.repairer and inst.components.repairer.healthrepairvalue == 0 then
		inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH
	end
end)