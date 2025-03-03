local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldDoRetrofitting = require("map/retrofit_savedata").DoRetrofitting

require("map/retrofit_savedata").DoRetrofitting = function(savedata, world_map, ...)
	local dirty = false
	
	if TUNING.POLAR_RETROFIT == 1 and savedata.map ~= nil and Polar_CompatibleShard(savedata.map.prefab) then
		if savedata.ents ~= nil and savedata.ents.pillar_polarcave ~= nil then
			print("Retrofitting for The Winterlands - Ice Cave found, it seems the island already exists.")
		else
			print("Retrofitting for The Winterlands - Looking to generate new Winterlands.")
			require("map/retrofit_polar").PolarRetrofitting_Island(TheWorld.Map, savedata)
		end
		dirty = true
	end
	
	if dirty then
		savedata.map.tiles = world_map:GetStringEncode()
		savedata.map.nodeidtilemap = world_map:GetNodeIdTileMapStringEncode()
	end
	
	OldDoRetrofitting(savedata, world_map, ...)
end