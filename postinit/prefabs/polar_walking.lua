local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local AddPrefabPostInit = ENV.AddPrefabPostInit

-- Inventory Helpers

local POLAR_WALKHELPERS = {
	cane = 				2,
	orangestaff = 		4,
	armordragonfly = 	true,
	beargervest = 		true,
	raincoat = 			4,
	sweatervest = 		4,
	trunkvest_summer = 	8,
	trunkvest_winter =	true,
	walking_stick = 	6,
	catcoonhat = 		4,
	deserthat = 		2,
	
	armormarble = 		-2,
	backpack = 			-1,
	--candybag = 		-1,
	icehat = 			-2,
	--icepack = 		-1,
	krampus_sack = 		-2,
	piggyback = 		-2,
	--seedpouch = 		-1,
}

for k, v in pairs(POLAR_WALKHELPERS) do
	AddPrefabPostInit(k, function(inst)
		if type(v) == "number" then
			if inst.components.equippable then
				inst.components.equippable.polar_slowtime = v -- Peak slowdown delayers
			end
		else
			inst:AddTag("polarimmunity") -- Immunity prevents debuff, not slowdown
		end
	end)
end

--	Adding slowdown to things that deserve it. Bouncing, sliding, all the funny walking mobs typically gets away with it, or if they're cool, chilly even

local POLAR_WALKERS = {
	"pigguard", "pigman", "rocky",
	"catcoon", "grassgekko", "monkey",
	"hound", "firehound", "mutatedhound", "warg", "wobybig", "wobysmall",
	"mossling", "perd", "spat"
}

for i, v in pairs(POLAR_WALKERS) do
	AddPrefabPostInit(v, function(inst)
		inst:AddComponent("polarwalker")
	end)
end