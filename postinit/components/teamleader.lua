local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local TeamLeader = require("components/teamleader")
	
	-- ?? Why is this reseting all the time ??
	local OldOrganizeTeams = TeamLeader.OrganizeTeams
	function TeamLeader:OrganizeTeams(...)
		OldOrganizeTeams(self, ...)
		
		if self.team_type == "thronekrampus" then
			self.radius = 30
		end
	end