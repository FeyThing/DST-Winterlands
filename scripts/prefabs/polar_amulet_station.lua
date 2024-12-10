local assets = {
	Asset("ANIM", "anim/polar_amulet_station.zip"),
}

local function DoTalkQueue(inst)
	if #inst.speech_queue > 0 and inst.components.timer and not inst.components.timer:TimerExists("speak_time") then
		local speech = SpawnPrefab("polaramulet_station_speech")
		speech.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		local line = inst.speech_queue[1]
		speech:SetSpeech(inst, line)
		inst._speechstr:set(line)
		table.remove(inst.speech_queue, 1)
		
		inst.SoundEmitter:PlaySound("polarsounds/shack/chat")
		inst.components.timer:StartTimer("speak_time", TUNING.POLARAMULET_STATION_SPEAKTIME)
	end
end

local function ShadeSay(inst, line, rdm, no_override)
	if not no_override then
		inst.speech_queue = {}
	end
	
	if rdm then
		line = line[math.random(#line)]
	end
	
	if type(line) == "table" then
		for i, v in ipairs(line) do
			table.insert(inst.speech_queue, v)
		end
	else
		table.insert(inst.speech_queue, line)
	end
	
	DoTalkQueue(inst)
end

local function ClearShadeChat(inst)
	inst.speech_queue = {}
	if inst._welcometask then
		inst._welcometask:Cancel()
		inst._welcometask = nil
	end
	if inst._tiptask then
		inst._tiptask:Cancel()
		inst._tiptask = nil
	end
	if inst._activatetask then
		inst._activatetask:Cancel()
		inst._activatetask = nil
	end
	
	if inst.components.timer:TimerExists("speak_time") then
		inst.components.timer:StopTimer("speak_time")
	end
end

local function OnOpen(inst, data)
	local doer = data and data.doer
	
	inst:DoTaskInTime(0.4, function()
		if inst.components.container and inst.components.container:IsOpen()
			and doer and doer.sg and doer.sg:HasStateTag("idle") then
			doer.sg:GoToState("start_polarnecklace")
		end
	end)
end

local function OnActivate(inst, doer, recipe)
	ClearShadeChat(inst)
	
	if recipe and recipe.name == "polaramulet_builder" then
		inst.amulet_building = true
		inst:MakePrototyper(true)
		
		if #inst.speech_queue == 0 then
			inst:ShadeSay(STRINGS.POLARAMULET_STATION_BUILDER_PRE, true)
		end
		
		inst._activatetask = inst:DoTaskInTime(6 + math.random(4), function()
			if #inst.speech_queue == 0 then
				inst:ShadeSay(STRINGS.POLARAMULET_STATION_BUILDER_LOOP, true)
			end
		end)
		
		if inst.components.container and doer and doer:HasTag("player") then
			inst.components.container:Open(doer)
		end
	end
end

local function OpenShack(inst)
	if not inst._open then
		return
	end
	
	inst.AnimState:PlayAnimation("open")
	inst.AnimState:PushAnimation("opened", true)
	
	inst.SoundEmitter:PlaySound("polarsounds/shack/step")
	inst:DoTaskInTime(0.5, function()
		inst.SoundEmitter:PlaySound("polarsounds/shack/door_creak")
		
		if not inst.amulet_building then
			inst:MakePrototyper()
		elseif inst.components.container then
			inst.components.container.canbeopened = true
		end
	end)
	
	ClearShadeChat(inst)
	
	inst._welcometask = inst:DoTaskInTime(2 + math.random(3), function()
		if #inst.speech_queue == 0 then
			inst:ShadeSay(inst.amulet_building and STRINGS.POLARAMULET_STATION_PENDING or STRINGS.POLARAMULET_STATION_WAITING, true)
		end
	end)
	inst._tiptask = inst:DoTaskInTime(12 + math.random(3), function()
		if #inst.speech_queue == 0 then
			inst:ShadeSay(STRINGS.POLARAMULET_STATION_TOOTH_TIPS, true)
		end
	end)
end

local function OnPlayerNear(inst, player)
	if not inst._open then
		inst.SoundEmitter:PlaySound("polarsounds/shack/knock")
		
		inst:DoTaskInTime(0.5 + math.random(), OpenShack)
		inst._open = true
	end
end

local function OnPlayerFar(inst, player)
	if inst._open then
		ClearShadeChat(inst)
		
		if not (inst.AnimState:IsCurrentAnimation("idle1") or inst.AnimState:IsCurrentAnimation("idle2")) then
			if inst.AnimState:IsCurrentAnimation("open") then
				inst.AnimState:PlayAnimation("idle1")
				inst.SoundEmitter:PlaySound("polarsounds/shack/step")
			else
				inst.AnimState:PlayAnimation("close")
				inst.SoundEmitter:PlaySound("polarsounds/shack/door_creak")
				
				inst:DoTaskInTime(0.3, function()
					inst.SoundEmitter:PlaySound("polarsounds/shack/step")
				end)
				
				if math.random() < 0.4 then
					inst.AnimState:PushAnimation("idle1")
				else
					inst.AnimState:PushAnimation("close_pst"..math.random(2))
					inst.AnimState:PushAnimation("idle1")
					
					inst:DoTaskInTime(0.6, function()
						inst.SoundEmitter:PlaySound("polarsounds/shack/plank_fall")
					end)
					
					inst:DoTaskInTime(1.1, function()
						inst.SoundEmitter:PlaySound("polarsounds/shack/step")
					end)
				end
			end
		end
		
		inst:MakePrototyper(true)
		if inst.components.container then
			inst.components.container.canbeopened = false
		end
		
		inst._open = nil
	end
end

local function GetStatus(inst)
	return inst._open and "OPEN" or nil
end

--

local function UnlockTrade(inst, item)
	local part = POLARAMULET_PARTS[item]
	
	if inst.components.craftingstation and part and part.unlock_recipe and not inst.components.craftingstation:KnowsItem(part.unlock_recipe) then
		inst.components.craftingstation:LearnItem(part.unlock_recipe, part.unlock_recipe)
	end
end

local function MakeAmulet(inst, doer)
	ClearShadeChat(inst)
	
	if inst.components.container and inst.components.container:IsFull() then
		local amulet = SpawnPrefab("polaramulet")
		local parts = {}
		
		local items = inst.components.container:GetAllItems()
		for i, v in ipairs(items) do
			table.insert(parts, v.prefab)
			
			inst:UnlockTrade(v.prefab)
			v:Remove()
		end
		
		amulet:SetAmuletParts(parts, {doer = doer})
		if doer and doer.components.inventory then
			doer.components.inventory:GiveItem(amulet, nil, inst:GetPosition())
			doer:PushEvent("finish_polarnecklace", amulet)
		else
			local x, y, z = inst.Transform:GetWorldPosition()
			doer.components.inventoryitem:DoDropPhysics(x, y, z, true)
		end
		
		if inst.components.container:IsOpen() then
			inst.components.container:Close()
		end
		
		inst:ShadeSay(STRINGS.POLARAMULET_STATION_BUILDER_PST, true)
		
		inst.amulet_building = nil
		inst:MakePrototyper()
		
		return true, amulet
	end
	
	return false
end

local function MakePrototyper(inst, disable)
	if disable then
		inst:RemoveComponent("prototyper")
	elseif inst.components.prototyper == nil then
		inst:AddComponent("prototyper")
		inst.components.prototyper.onactivate = OnActivate
		inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.POLARAMULET_STATION
	end
	
	if inst.components.container then
		inst.components.container.canbeopened = disable or false
	end
end

local function Creepy(inst, sound, min_time, max_time)
	inst.SoundEmitter:PlaySound("polarsounds/shack/"..sound)
	inst._creepytasks[sound] = inst:DoTaskInTime(min_time + math.random(max_time), Creepy, sound, min_time, max_time)
end

local function OnEntitySleep(inst)
	if inst._creepytasks then
		for _, task in pairs(inst._creepytasks) do
			task:Cancel()
		end
		
		inst._creepytasks = nil
	end
end

local function OnEntityWake(inst)
	if inst._creepytasks == nil then
		inst._creepytasks = {}
		
		inst:DoTaskInTime(0, Creepy, "creak", 2, math.random(4))
	end
end

local function OnSave(inst, data)
	data.amulet_building = inst.amulet_building
end

local function OnLoad(inst, data)
	if data and data.amulet_building then
		inst.amulet_building = true
	end
end

local function OnAnimOver(inst)
	if inst.AnimState:IsCurrentAnimation("idle1") or inst.AnimState:IsCurrentAnimation("idle2") then
		inst.AnimState:PlayAnimation("idle"..tostring(math.random() < 0.9 and 1 or 2))
	end
end

local function OnTimerDone(inst, data)
	if data.name == "speak_time" then
		DoTalkQueue(inst)
	end
end

local function OnSpeechStrDirty(inst)
	local speech = SpawnPrefab("polaramulet_station_speech")
	speech.Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	speech:SetSpeech(inst, inst._speechstr:value())
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.35)
	
	inst.MiniMapEntity:SetIcon("polaramulet_station.png")
	inst.MiniMapEntity:SetPriority(5)
	
	inst.AnimState:SetBank("polar_amulet_station")
	inst.AnimState:SetBuild("polar_amulet_station")
	inst.AnimState:PlayAnimation("idle1")
	
	inst:AddTag("snowblocker")
	
	inst.SoundEmitter:PlaySound("polarsounds/shack/woowoo", "woowoo")
	
	inst._snowblockrange = net_tinybyte(inst.GUID, "polar_amulet_station._snowblockrange")
	inst._snowblockrange:set(7)
	
	inst._speechstr = net_string(inst.GUID, "polaramulet_station._speechstr", "speechstrdirty")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		inst:ListenForEvent("speechstrdirty", OnSpeechStrDirty)
		
		return inst
	end
	
	inst.speech_queue = {}
	
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("polaramulet_station")
	inst.components.container.onopenfn = OnOpen
	inst.components.container.canbeopened = false
	
	inst:AddComponent("craftingstation")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = GetStatus
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(3, 4.5)
	inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
	inst.components.playerprox:SetOnPlayerFar(OnPlayerFar)
	
	inst:AddComponent("timer")
	
	--MakeSnowCovered(inst)
	
	inst.MakeAmulet = MakeAmulet
	inst.MakePrototyper = MakePrototyper
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.ShadeSay = ShadeSay
	inst.UnlockTrade = UnlockTrade
	
	inst:ListenForEvent("animover", OnAnimOver)
	inst:ListenForEvent("timerdone", OnTimerDone)
	
	return inst
end

--

local function SetSpeech(inst, target, str)
	--[[if target then
		inst.Follower:FollowSymbol(target.GUID, "face", 0, 0, 0)
	end]]
	
	if str then
		inst.speech_pos = {GetRandomMinMax(-25, 25), 0, 0}
		inst.Label:SetUIOffset(unpack(inst.speech_pos))
		inst.Label:SetText(str)
		
		inst:DoPeriodicTask(FRAMES, inst.UpdateSpeech)
	else
		inst:Remove()
	end
end

local function UpdateSpeech(inst)
	local time_alive = inst:GetTimeAlive()
	local fade_time = TUNING.POLARAMULET_STATION_SPEAKTIME + 2
	local shrink_time = 0.5
	local base_size = 25
	local elevate_rate = 0.8
	
	local font_size = time_alive <= 0.5 and Lerp(fade_time, base_size, time_alive * 2)
		or time_alive <= fade_time and base_size
		or Lerp(base_size, 0, (time_alive - fade_time) / shrink_time)
	
	inst.speech_pos[2] = inst.speech_pos[2] + elevate_rate
	inst.Label:SetUIOffset(unpack(inst.speech_pos))
	inst.Label:SetFontSize(font_size)
	
	if time_alive >= fade_time + shrink_time then
		inst:Remove()
	end
end


local function speech()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddFollower()
	inst.entity:AddLabel()
	inst.entity:AddNetwork()
	
	local colour = 110 + math.random(20)
	
	inst.Label:SetFontSize(1)
	inst.Label:SetFont(TALKINGFONT)
	inst.Label:SetWorldOffset(0, 2.35, 0) -- If following head, just 1
	inst.Label:SetUIOffset(0, 0, 0)
	inst.Label:SetColour(colour / 255, colour / 255, colour / 255)
	inst.Label:Enable(true)
	
	inst:AddTag("FX")
	
	inst.SetSpeech = SetSpeech
	inst.UpdateSpeech = UpdateSpeech
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.persists = false
	
	return inst
end

return Prefab("polaramulet_station", fn, assets),
	Prefab("polaramulet_station_speech", speech, assets)