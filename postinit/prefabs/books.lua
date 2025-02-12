local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local OldOnRead_Bird
local function OnRead_Bird(inst, reader, ...)
	if reader and TheWorld.components.polarstorm and TheWorld.components.polarstorm:IsInPolarStorm(reader) then
		return false
	end
	
	if OldOnRead_Bird then
		return OldOnRead_Bird(inst, reader, ...)
	end
end

ENV.AddPrefabPostInit("book_birds", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book then
		if OldOnRead_Bird == nil then
			OldOnRead_Bird = inst.components.book.onread
		end
		
		inst.components.book:SetOnRead(OnRead_Bird)
	end
end)

--

local OldOnRead_Rain
local function OnRead_Rain(inst, reader, ...)
	local x, y, z = inst.Transform:GetWorldPosition()
	if GetClosestPolarTileToPoint(x, 0, z, 32) ~= nil and TheWorld.components.polarstorm then
		local active = TheWorld.components.polarstorm:IsPolarStormActive()
		
		if TheWorld.components.polarstorm:IsPolarStormActive() then
			TheWorld.components.polarstorm:PushBlizzard(0)
		else
			TheWorld.components.polarstorm:PushBlizzard(TUNING.BOOK_RAIN_BLIZARD_DURATION)
		end
		
		return true
	end
	
	if OldOnRead_Rain then
		return OldOnRead_Rain(inst, reader, ...)
	end
end

ENV.AddPrefabPostInit("book_rain", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	
	if inst.components.book then
		if OldOnRead_Rain == nil then
			OldOnRead_Rain = inst.components.book.onread
		end
		
		inst.components.book:SetOnRead(OnRead_Rain)
	end
end)