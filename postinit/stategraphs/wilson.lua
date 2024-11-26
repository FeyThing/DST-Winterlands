local ENV = env
GLOBAL.setfenv(1, GLOBAL)

ENV.AddStategraphPostInit("wilson", function(sg)
	local oldattack = sg.states["attack"].onenter
	sg.states["attack"].onenter = function(inst, ...)
		oldattack(inst, ...)
		
		local equip = inst.components.inventory and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if equip and equip:HasTag("antlerstick") then
			 inst.SoundEmitter:PlaySound("polarsounds/antler_tree/swoop", nil, nil, true)
		end
	end
end)