local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local tracks = {"animal_track", "dirtpile"}

local function PolarInit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) then
		inst.AnimState:OverrideSymbol("art", "dirt_to_polar_builds", "art")
	end
end

local olddisplaynamefn
local function displaynamefn(inst, ...)
	local name = olddisplaynamefn and olddisplaynamefn(inst, ...)
	local x, y, z = inst.Transform:GetWorldPosition()
	
	if (name == nil or name == STRINGS.NAMES.DIRTPILE) and z and GetClosestPolarTileToPoint(x, 0, z, 32) then
		name = STRINGS.NAMES.DIRTPILE_POLAR
	end
	
	return name
end

for i, v in ipairs(tracks) do
	ENV.AddPrefabPostInit(v, function(inst)
		if inst.SoundEmitter == nil then
			inst.entity:AddSoundEmitter()
		end
		
		inst:AddTag("snowblocker")
		
		inst._snowblockrange = net_smallbyte(inst.GUID, "animal_track._snowblockrange")
		inst._snowblockrange:set(3)
		
		if v == "dirtpile" then
			if olddisplaynamefn == nil then
				olddisplaynamefn = inst.displaynamefn
			end
			inst.displaynamefn = displaynamefn
		end
		
		if not TheWorld.ismastersim then
			return
		end
		
		inst:DoTaskInTime(0, PolarInit)
	end)
end