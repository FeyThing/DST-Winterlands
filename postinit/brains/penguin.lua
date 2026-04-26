local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local PenguinBrain = require("brains/penguinbrain")
	
	local StealAction = PolarUpvalue(PenguinBrain.OnStart, "StealAction")
	
	local OldFindScaryPredator = PolarUpvalue(StealAction, "FindScaryPredator")
	local function FindScaryPredator(inst, radius, ...)
		if radius and GetClosestInstWithTag("emperorpengullcrowned", inst, radius + 1) then
			return -- Someone wears the Emperor Crown nearby, allow players to collect "taxes" (our gegs)
		end
		
		if OldFindScaryPredator then
			return OldFindScaryPredator(inst, radius, ...)
		end
	end
	
	local OldShouldRunAway = PolarUpvalue(PenguinBrain.OnStart, "ShouldRunAway")
	local function ShouldRunAway(inst, hunter, ...)
		if hunter and hunter:HasTag("emperorpengullcrowned") then
			return false
		end
		
		if OldShouldRunAway then
			return OldShouldRunAway(inst, hunter, ...)
		end
	end
	
	PolarUpvalue(StealAction, "FindScaryPredator", FindScaryPredator)
	PolarUpvalue(PenguinBrain.OnStart, "ShouldRunAway", ShouldRunAway)