local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local TREES = {"evergreen", "evergreen_sparse", "leif", "leif_sparse"}

local function OnInit(inst)
	if IsInPolar(inst) then
		inst.AnimState:SetSymbolSaturation("pieces", 3)
	end
end

for i, v in ipairs(TREES) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:DoTaskInTime(0, OnInit)
	end)
end