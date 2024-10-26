local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local FLOWERS = {"flower", "flower_evil"}

local function PolarInit(inst)
	if IsInPolar(inst) then
		local ded = SpawnPrefab("flower_withered")
		local pt = inst:GetPosition()
		
		ded.Transform:SetPosition(pt:Get())
		
		TheWorld:PushEvent("plantkilled", {pos = pt})
		
		inst:Remove()
	end
end

for i, v in ipairs(FLOWERS) do
	ENV.AddPrefabPostInit(v, function(inst)
		if not TheWorld.ismastersim then
			return
		end
		
		inst:DoTaskInTime(math.random(2, 7), PolarInit)
	end)
end