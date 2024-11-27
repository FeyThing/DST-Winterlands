local UIAnim = require "widgets/uianim"

local SnowDustOver = Class(UIAnim, function(self, owner)
    self.owner = owner
    UIAnim._ctor(self)

    self:SetClickable(false)

    self:SetHAnchor(ANCHOR_MIDDLE)
    self:SetVAnchor(ANCHOR_MIDDLE)
    self:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

    self:GetAnimState():SetBank("snow_over")
    self:GetAnimState():SetBuild("snow_over")
    self:GetAnimState():PlayAnimation("dust_loop", true)
    self:GetAnimState():AnimateWhilePaused(false)
end)

return SnowDustOver
