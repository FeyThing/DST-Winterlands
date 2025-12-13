local function OnLoad(inst, scenariorunner)
	local walrus_nodes = {}
	
	for i, v in ipairs(TheWorld.topology.ids) do
		if string.find(v, "PolarIsland_Walrus") then
			table.insert(walrus_nodes, TheWorld.topology.nodes[i])
		end
	end
	
	local ax, ay, az = inst.Transform:GetWorldPosition()
	
	if #walrus_nodes > 0 then
		local area = walrus_nodes[math.random(#walrus_nodes)]
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
		inst.components.writeable:SetText(STRINGS.WINTERLANDS_WALRUS_ARROWSIGNTEXT[math.random(#STRINGS.WINTERLANDS_WALRUS_ARROWSIGNTEXT)])
	end
	
	inst.AnimState:SetScale(1, 0.8)
end

return {
	OnLoad = OnLoad,
}