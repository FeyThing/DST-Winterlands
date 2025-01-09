local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local throne_brain = require "brains/krampus_thronebrain"
local THRONE_TAGS = {"polarthrone"}

local function MakeTeam(inst, player)
	local team = inst.components.teamattacker:SearchForTeam()
	
	if team == nil then
		team = SpawnPrefab("teamleader")
		team.components.teamleader:SetUp(player, inst)
		team.components.teamleader:BroadcastDistress(inst)
		team.components.teamleader.radius = 30
	end
	
	return team
end

local function OnAttacked(inst, data)
	local attacker = data and data.attacker or nil
	if attacker == nil or inst.components.teamattacker == nil then
		return
	end
	
    if not inst.components.teamattacker.inteam and not inst.components.teamattacker:SearchForTeam() then
        MakeTeam(inst, data.attacker)
    elseif inst.components.teamattacker.teamleader then
        inst.components.teamattacker.teamleader:BroadcastDistress(inst)
    end
end

local function OnHitOther(inst, data)
	if data.redirected or inst.sg == nil then
		return
	end
	
	if inst.sg.currentstate.name == "attack_throne" and data.target and data.target.components.inventory and not data.target:HasTag("stronggrip") then
		local item = data.target.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		
		if item and not item:HasTag("nosteal") and item.components.inventoryitem then
			data.target.components.inventory:DropItem(item)
			
			local x, y, z = item.Transform:GetWorldPosition()
			item.components.inventoryitem:DoDropPhysics(x, y, z, true)
		end
	end
end

local function OnTimerDone(inst, data)
	if data.name == "throne_exit" then
		if inst:IsAsleep() then
			inst:Remove()
		else
			inst.wants_to_exit_throne = true
			inst.persists = false
		end
	end
end

local function DoThroneCombat(inst, player)
	local throne = FindEntity(inst, 50, function(guy) return guy.prefab == "polar_throne" end, THRONE_TAGS)
	if throne == nil then
		return
	end
	
	local pt = throne:GetPosition()
	player = player or FindClosestPlayerInRange(pt.x, pt.y, pt.z, 20, true) or nil
	
	inst:AddTag("thronekrampus")
	
	if inst.components.knownlocations == nil then
		inst:AddComponent("knownlocations")
	end
	inst.components.knownlocations:RememberLocation("polarthrone", pt, true)
	
	if inst.components.thief == nil then
		inst:AddComponent("thief")
	end
	
	if inst.components.timer == nil then
		inst:AddComponent("timer")
	end
	inst.components.timer:StartTimer("throne_exit", GetRandomMinMax(TUNING.THRONE_KRAMPUS_STAY_TIME_MIN, TUNING.THRONE_KRAMPUS_STAY_TIME_MIN))
	
	if inst.components.teamattacker == nil then
		inst:AddComponent("teamattacker")
	end
	inst.components.teamattacker.team_type = "thronekrampus"
	
	if player then
		MakeTeam(inst, player)
	end
	
	inst:SetBrain(throne_brain)
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onhitother", OnHitOther)
	inst:ListenForEvent("timerdone", OnTimerDone)
end

--

local SACK_COLORS = {
	{0.9, 	0.4, 	0.4, 	1}, -- red
	{0.4, 	0.5, 	0.8, 	1}, -- blue
	{0.6, 	0.8, 	0.3, 	1}, -- green
	{0.8, 	0.6, 	0.3, 	1}, -- yellow
	{0.6, 	0.5, 	0.3, 	1}, -- brown
	{0.8, 	0.4, 	0.7, 	1}, -- pink
	{1, 	1, 		1, 		1}, -- white
}

local function SetPolarSweater(inst, sweater_color)
	local color = sweater_color or TheWorld.cur_krampus_throne_color or 1
	inst.polar_sweater_color = color
	
	local r, g, b, a = unpack(SACK_COLORS[color])
	inst.AnimState:OverrideSymbol("krampus_neck", "krampus_polar", "krampus_neck")
	inst.AnimState:OverrideSymbol("krampus_torso", "krampus_polar", "krampus_torso")
	
	inst.AnimState:SetSymbolMultColour("krampus_neck", r, g, b, a)
	inst.AnimState:SetSymbolMultColour("krampus_torso", r, g, b, a)
	--inst.AnimState:SetSymbolMultColour("krampus_bag", r, g, b, a)
	
	local next_color = color + 1
	TheWorld.cur_krampus_throne_color = next_color > #SACK_COLORS and 1 or next_color
end

local OldOnSave
local function OnSave(inst, data, ...)
	if OldOnSave then
		OldOnSave(inst, data, ...)
	end
	if inst:HasTag("thronekrampus") then
		data.throne_combat = true
	end
	data.polar_sweater_color = inst.polar_sweater_color
end

local OldOnLoad
local function OnLoad(inst, data, ...)
	if OldOnLoad then
		OldOnLoad(inst, data, ...)
	end
	if data then
		if data.polar_sweater_color then
			inst:SetPolarSweater(data.polar_sweater_color)
		end
		if data.throne_combat then
			inst:DoThroneCombat()
		end
	end
end

local function OnPolarInit(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil then
		inst:SetPolarSweater()
	end
end

ENV.AddPrefabPostInit("krampus", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	inst.DoThroneCombat = DoThroneCombat
	inst.SetPolarSweater = SetPolarSweater
	
	if not OldOnSave then
		OldOnSave = inst.OnSave
	end
	inst.OnSave = OnSave
	
	if not OldOnLoad then
		OldOnLoad = inst.OnLoad
	end
	inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(0, OnPolarInit)
end)

--

local OldOnUseKlausKey
local function OnUseKlausKey(inst, key, doer, ...)
	local success, fail_msg, consumed
	if OldOnUseKlausKey then
		success, fail_msg, consumed = OldOnUseKlausKey(inst, key, doer, ...)
	end
	
	if success then
		TheWorld:PushEvent("ms_respawnthronegifts", sack)
	end
end

ENV.AddPrefabPostInit("klaus_sack", function(inst)
	inst:AddTag("polarthrone_emptier")
	
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.klaussacklock then
		inst.components.klaussacklock:SetOnUseKey(onuseklauskey)
	end
end)