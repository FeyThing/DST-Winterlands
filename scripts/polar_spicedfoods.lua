local spicedfoods = {}
local polarfoods = require("polar_preparedfoods")
local polarfoods_warly = require("polar_preparedfoods_warly")

GenerateSpicedFoods(polarfoods)
GenerateSpicedFoods(polarfoods_warly)

local spices = require("spicedfoods")

for k, data in pairs(spices) do
	for name, v in pairs(polarfoods) do
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