require("stategraphs/commonstates")

local events = {
    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
            inst.sg:GoToState("hit")
        end
    end),

    EventHandler("doattack", function(inst, data)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack", data.target)
        end
    end),

    EventHandler("locomote", function(inst)
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
            if wants_to_move and not is_moving then
                inst.sg:GoToState("moving")
            elseif not wants_to_move then
                inst.sg:GoToState("idle")
            end
        end
    end),

    EventHandler("death", function(inst) inst.sg:GoToState("death") end)
}

local states = {
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            inst.components.lootdropper:DropLoot(inst:GetPosition())
        end
    },

    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        ontimeout = function(inst)
            inst.sg:GoToState("taunt")
        end,

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
        end
    },

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.components.locomotor:WalkForward()
            inst.AnimState:PushAnimation("walk_loop")
        end,

        timeline = {
            -- TimeEvent(0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "walk_spider")) end), -- TODO
            -- TimeEvent(3*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "walk_spider")) end),
            -- TimeEvent(7*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "walk_spider")) end),
            -- TimeEvent(12*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "walk_spider")) end),
        },

        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end)
        }
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,

        timeline = {
            -- TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "Attack")) end), -- TODO
            -- TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound(SoundPath(inst, "attack_grunt")) end),
            TimeEvent(25*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end)
        },

        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        }
    },

    State{
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        }
    }
}

CommonStates.AddVoidFallStates(states)

return StateGraph("frosty", states, events, "idle")