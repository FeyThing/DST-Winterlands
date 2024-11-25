local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldOnOwnerChange
local function OnOwnerChange(inst, data, ...)
	if OldOnOwnerChange then
		OldOnOwnerChange(inst, data, ...)
	end
end

ENV.AddPrefabPostInit("bearger", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if OldOnOwnerChange == nil and inst._onownerchange then
		OldOnOwnerChange = inst._onownerchange
	end
	
	inst._onownerchange = OnOwnerChange
end)