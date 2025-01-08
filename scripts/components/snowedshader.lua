local SHADER_PATH = "shaders/snowed.ksh"

local function UpdateFloatParams(inst, submerge, freeze)
    local pitch_offset = (TheCamera.pitch - TheCamera.mindistpitch) / (TheCamera.maxdistpitch - TheCamera.mindistpitch) -- min = 30, max = 60
    inst.AnimState:SetFloatParams(freeze, TUNING.SNOWED_SHADER_MAX_SUBMERGE * submerge, (-0.2 - 0.25 * pitch_offset) * submerge)
    -- (-0.2 - 0.25 * pitch_offset)
    -- LukaS: This value is hard-coded, used to counteract the effects of perspective from the camera
    -- WILL NOT WORK PROPERLY IF THE CAMERA MIN/MAX PITCH VALUES ARE CHANGED, shouldn't be a problem tho
end 

local SnowedShader = Class(function(self, inst)
    self.inst = inst

    self.inst.AnimState:SetDefaultEffectHandle(resolvefilepath(SHADER_PATH))

    self.max_depth = 0.5 -- In in-game units (4 = tile)

    self.submerge = net_float(inst.GUID, "snowedshader.submerge", "submergedirty")
    self.freeze = net_float(inst.GUID, "snowedshader.freeze", "freezedirty")

    if not TheWorld.ismastersim then
        inst:ListenForEvent("submergedirty", function() UpdateFloatParams(inst, self.submerge:value(), self.freeze:value()) end)
        inst:ListenForEvent("freezedirty", function() UpdateFloatParams(inst, self.submerge:value(), self.freeze:value()) end)
    end
end)

function SnowedShader:OnRemoveFromEntity()
	self.inst.AnimState:ClearDefaultEffectHandle() -- LukaS: Should probably accomodate for when the player has some other default shader set up
    self.inst.AnimState:SetFloatParams(0, 0, 0)
end

function SnowedShader:SetMaxSubmergeDepth(depth)
    if depth >= 0 then -- LukaS: '0' still renders the wavy effect under the players feet, less then that is pointless tho
        self.max_depth = depth
    end
end

function SnowedShader:SetSubmergedAmount(amount)
    self.submerge:set(math.clamp(amount, 0, 1))
end

function SnowedShader:SetFreezeAmount(amount)
    self.freeze:set(math.clamp(amount, 0, 1))
end

return SnowedShader