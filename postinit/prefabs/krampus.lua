local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function OnPolarInit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil then
		inst.AnimState:OverrideSymbol("krampus_neck", "krampus_polar", "krampus_neck")
		inst.AnimState:OverrideSymbol("krampus_torso", "krampus_polar", "krampus_torso")
	end
end

ENV.AddPrefabPostInit("krampus", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:DoTaskInTime(0, OnPolarInit)
end)