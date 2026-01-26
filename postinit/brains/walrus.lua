local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local WalrusBrain = require("brains/walrusbrain")
	
	local OldShouldRunAway = PolarUpvalue(WalrusBrain.OnStart, "ShouldRunAway")
	local function ShouldRunAway(guy, ...)
		if guy and guy:HasTag("walruspal") then
			return false
		end
		
		if OldShouldRunAway then
			return OldShouldRunAway(guy, ...)
		end
	end
	
	local PLAYER_ALLY_TAGS = {"walruspal"}
	local PLAYER_ALLY_NOT_TAGS = {"INLIMBO", "isdead"}
	
	local OldGetNoLeaderFollowTarget = PolarUpvalue(WalrusBrain.OnStart, "GetNoLeaderFollowTarget")
	local function GetNoLeaderFollowTarget(inst, ...)
		local target = OldGetNoLeaderFollowTarget and OldGetNoLeaderFollowTarget(inst, ...) or nil
		
		if target then
			local ally = FindEntity(inst, 10, nil, PLAYER_ALLY_TAGS, PLAYER_ALLY_NOT_TAGS)
			
			if ally ~= nil or target:HasTag("spawnprotection") or (target.components.age and target.components.age:GetAge() < 10) then
				return -- Don't follow if player has spawned recently or uses bagpipes
			end
		end
		
		return target
	end
	
	PolarUpvalue(WalrusBrain.OnStart, "ShouldRunAway", ShouldRunAway)
	PolarUpvalue(WalrusBrain.OnStart, "GetNoLeaderFollowTarget", GetNoLeaderFollowTarget)