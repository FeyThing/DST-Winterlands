local events = {
    EventHandler("stopinfighting", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("yell")
		end
    end),
    EventHandler("trialstartfailed", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("reject")
		end
    end),
    EventHandler("trialstarted", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("trial_begin")
		end
    end),
    EventHandler("trial_end_won", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("congratulate")
		end
    end),
    EventHandler("trial_end_lost", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("reject")
		end
    end),
    EventHandler("trial_end_interrupted", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("reject")
		end
    end)
}

local states = {
    State{
        name = "idle",
        tags = { "idle" },

        onenter = function(inst)
            if inst.sg.mem.sleeping then
                inst.sg:GoToState("sleep")
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end
    },
 
    State{
        name = "sleep",
        tags = { "sleeping" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pre")
            inst.AnimState:PushAnimation("sleep_loop", true)
        end
    },

    State{
        name = "wake",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pst")
        end,

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end)
        }
    },

    State{
        name = "reject",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("unimpressed")
            inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
        end,

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end)
        }
    },

    State{
        name = "trial_begin",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("happy")
        end,

        timeline = {
            TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy") end)
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end)
        }
    },

    State{
        name = "congratulate",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("happy")
        end,

        timeline = {
            TimeEvent(6 * FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingHappy") end)
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end)
        }
    },

    State{
        name = "yell", -- This state for stopping bear infighting
        tags = { "yelling" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("unimpressed")
            inst.SoundEmitter:PlaySound("dontstarve/pig/PigKingReject")
        end,

        timeline = {
            TimeEvent(30*FRAMES, function(inst)
                inst:DoRoar()
            end)
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end)
        }
    }
}

return StateGraph("polarbearking", states, events, "idle")