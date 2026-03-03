local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddStategraphPostInit("hound", function(sg)
	if sg.states["howl"] then -- There is some unknown mod out there that completely overrides the hound SG, causing this one state to be missing
		local oldhowl = sg.states["howl"].onenter
		sg.states["howl"].onenter = function(inst, data, ...)
			if data == nil then
				data = {} -- Required to not crash, but event does not pass any data in our use case for it.
			end
			
			oldhowl(inst, data, ...)
		end
	end
end)