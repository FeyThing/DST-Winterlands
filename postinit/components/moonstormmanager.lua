local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddComponentPostInit("moonstormmanager", function(self)
	local OldNodeCanHaveMoonstorm = PolarUpvalue(self.CalcNewMoonstormBaseNodeIndex, "NodeCanHaveMoonstorm")
	local function NodeCanHaveMoonstorm(node, ...)
		local test
		if OldNodeCanHaveMoonstorm then
			test = OldNodeCanHaveMoonstorm(node, ...)
		end
		
		return not table.contains(node.tags, "polararea") and test
	end
	
	PolarUpvalue(self.CalcNewMoonstormBaseNodeIndex, "NodeCanHaveMoonstorm", NodeCanHaveMoonstorm)
end)