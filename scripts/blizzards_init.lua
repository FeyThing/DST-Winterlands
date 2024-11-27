local i = 0
for key, val in pairs(GLOBAL.STORM_TYPES) do
    i = i + 1
end

GLOBAL.STORM_TYPES.BLIZZARDSTORM = i

AddPrefabPostInit("forest", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end
    
    inst:AddComponent("blizzardstorms")
end)

local SnowOver = require("widgets/snowover")
local SnowDustOver = require("widgets/snowdustover")
local PlayerHud = require("screens/playerhud")
local old_PlayerHud_CreateOverlays = PlayerHud.CreateOverlays
PlayerHud.CreateOverlays = function(self, owner, ...)
    old_PlayerHud_CreateOverlays(self, owner, ...)

    self.snowdustover = self.storm_overlays:AddChild(SnowDustOver(owner))
    self.snowover = self.overlayroot:AddChild(SnowOver(owner, self.snowdustover))
end

AddPlayerPostInit(function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    inst:AddComponent("blizzardstormwatcher")
end)

local StormWatcher = require("components/stormwatcher")
local old_StormWatcher_ctor = StormWatcher._ctor
StormWatcher._ctor = function(self, ...)
    old_StormWatcher_ctor(self, ...)
    if GLOBAL.TheWorld.components.blizzardstorms and GLOBAL.TheWorld.components.blizzardstorms:IsBlizzardStormActive() then
        self:UpdateStorms({ stormtype = GLOBAL.STORM_TYPES.BLIZZARDSTORM, setting = true })
    end
end

local old_StormWatcher_UpdateStormLevel = StormWatcher.UpdateStormLevel
StormWatcher.UpdateStormLevel = function(self, ...)
    old_StormWatcher_UpdateStormLevel(self, ...)
    
    if self.currentstorm ~= GLOBAL.STORM_TYPES.NONE then
        if self.currentstorm == GLOBAL.STORM_TYPES.BLIZZARDSTORM then
			self.stormlevel = math.floor(GLOBAL.TheWorld.components.blizzardstorms:GetBlizzardStormLevel(self.inst) * 7 + 0.5) / 7
            self.inst.components.blizzardstormwatcher:UpdateBlizzardStormLevel()
        end
    else
        if self.laststorm ~= GLOBAL.STORM_TYPES.NONE then
            if self.laststorm == GLOBAL.STORM_TYPES.BLIZZARDSTORM then
                self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "blizzardstorm")
            end
        end
    end
end

local old_StormWatcher_GetCurrentStorm = StormWatcher.GetCurrentStorm
StormWatcher.GetCurrentStorm = function(self, ...)
    local currentstorm = old_StormWatcher_GetCurrentStorm(self, ...)
    if GLOBAL.TheWorld.components.blizzardstorms:IsInBlizzardStorm(self.inst) then
        GLOBAL.assert(currentstorm == GLOBAL.STORM_TYPES.NONE,"CAN'T BE IN TWO STORMS AT ONCE")
        currentstorm = GLOBAL.STORM_TYPES.BLIZZARDSTORM
    end

    return currentstorm
end