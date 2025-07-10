local spicedfoods = {}
local polarfoods = require("polar_preparedfoods")
local polarfoods_warly = require("polar_preparedfoods_warly")

local polarfoods_prefabs = {}
for k, data in pairs(polarfoods) do
	if not data.noprefab then -- We don't want spiced 'emperor icecream' to generate !
		polarfoods_prefabs[k] = data
	end
end

GenerateSpicedFoods(polarfoods_prefabs)
GenerateSpicedFoods(polarfoods_warly)

local spices = require("spicedfoods")

for k, data in pairs(spices) do
	for name, v in pairs(polarfoods_prefabs) do
		if data.basename == name then
			spicedfoods[k] = data
		end
	end
	
	for name, v in pairs(polarfoods_warly) do
		if data.basename == name then
			spicedfoods[k] = data
		end
	end
end

return spicedfoods