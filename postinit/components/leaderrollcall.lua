local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local LeaderRollCall = require("components/leaderrollcall")
	
	local ONEOF_TAGS = PolarUpvalue(LeaderRollCall.DoRollCall, "ONEOF_TAGS")
	print("BUUUUH?", ONEOF_TAGS)
	if ONEOF_TAGS and not table.contains(ONEOF_TAGS, "polarbear") then
		table.insert(ONEOF_TAGS, "polarbear")
	end