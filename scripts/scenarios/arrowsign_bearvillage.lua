local function OnLoad(inst, scenariorunner)
	local bear_nodes = {}
	
	for i, v in ipairs(TheWorld.topology.ids) do
		if string.find(v, "PolarIsland_Village") then
			table.insert(bear_nodes, TheWorld.topology.nodes[i])
		end
	end
	
	local ax, ay, az = inst.Transform:GetWorldPosition()
	
	if #bear_nodes > 0 then
		local area = bear_nodes[math.random(#bear_nodes)]
		local points_x, points_y = TheWorld.Map:GetRandomPointsForSite(area.x, area.y, area.poly, 1)
		
		if #points_x == 1 and #points_y == 1 then
			local x = points_x[1]
			local z = points_y[1]
			
			inst:DoTaskInTime(0.1, function()
				inst:FacePoint(x, ay, z)
			end)
		end
	elseif inst.components.burnable then
		inst.AnimState:PlayAnimation("burnt")
		inst:AddTag("burnt")
	end
	if inst.components.writeable then
		inst.components.writeable:SetText(STRINGS.WINTERLANDS_BEARS_ARROWSIGNTEXT[math.random(#STRINGS.WINTERLANDS_BEARS_ARROWSIGNTEXT)])
	end
	
	inst.AnimState:SetScale(1, 1.1)
end

return {
	OnLoad = OnLoad,
}