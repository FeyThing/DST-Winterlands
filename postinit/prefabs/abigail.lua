local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local function PolarInit(inst)
	if inst.event_listeners.do_ghost_hauntat and inst.event_listeners.do_ghost_hauntat[inst] then
		local DoGhostHauntAt = inst.event_listeners.do_ghost_hauntat[inst][1]
		
		--	Ghost players can plooOOoow High Snow, so we'll allow Abigail to do as much
		inst.event_listeners.do_ghost_hauntat[inst][1] = function(src, pos, ...)
			if DoGhostHauntAt then
				DoGhostHauntAt(src, pos, ...)
			end
			
			if pos and TheWorld.Map:IsPolarSnowAtPoint(pos.x, pos.y, pos.z, true) and inst._haunt_target == nil then
				local marker = SpawnPrefab("snowwave_workermarker")
				marker.Transform:SetPosition(pos:Get())
				
				inst._haunt_target = marker
			end
		end
	end
end

ENV.AddPrefabPostInit("abigail", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst:DoTaskInTime(0, PolarInit)
end)