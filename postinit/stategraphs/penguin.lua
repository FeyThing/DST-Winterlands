local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local events = {
	EventHandler("ploof", function(inst, data)
		if inst.components.health and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			if data and data.pt then
				inst.sg:GoToState("ploof", data.pt)
			end
		end
	end),
}

local states = {
	State{
		name = "ploof",
		tags = {"busy"},
		
		onenter = function(inst, pt)
			inst.AnimState:PlayAnimation("slide_bounce")
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
		end,
		
		events = {
			EventHandler("animover", function(inst)
				local x, y, z = inst.Transform:GetWorldPosition()
				
				if not TheWorld.Map:IsPassableAtPoint(x, 0, z) then
					SpawnPrefab("splash_sink").Transform:SetPosition(x, y, z)
					inst:Remove()
				else
					inst.Physics:ClearCollisionMask()
					inst.Physics:CollidesWith(COLLISION.WORLD)
					inst.Physics:CollidesWith(COLLISION.OBSTACLES)
					inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
					inst.Physics:CollidesWith(COLLISION.CHARACTERS)
					inst.Physics:CollidesWith(COLLISION.GIANTS)
					inst.sg:GoToState("run_stop")
				end
			end)
		},
	}
}

ENV.AddStategraphPostInit("penguin", function(sg)
	for _, event in pairs(events) do
		sg.events[event.name] = event
	end
	
	for _, state in pairs(states) do
		sg.states[state.name] = state
	end
	
	--	Fix spawning in shadow, remove non-polar penguin on spawn
	
	local oldappear_enter = sg.states["appear"].onenter
	sg.states["appear"].onenter = function(inst, ...)
		if inst.prefab == "penguin" and IsInPolar(inst) then
			inst:Remove()
			return
		end
		
		if inst.DynamicShadow then
			inst.DynamicShadow:Enable(false)
		end
		
		oldappear_enter(inst, ...)
	end
	
	local oldappear_exit = sg.states["appear"].onexit
	sg.states["appear"].onexit = function(inst, ...)
		if inst.DynamicShadow then
			inst.DynamicShadow:Enable(true)
		end
		
		if oldappear_exit then
			oldappear_exit(inst, ...)
		end
	end
end)