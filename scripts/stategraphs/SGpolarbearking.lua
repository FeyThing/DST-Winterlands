local events = {
    EventHandler("stopinfighting", function(inst)
		if not inst.sg:HasStateTag("sleeping") and not inst.sg:HasStateTag("yelling") then
			inst.sg:GoToState("yell")
		end
    end),
    EventHandler("calmdown", function(inst)
		if not inst.sg:HasStateTag("sleeping") then
			inst.sg:GoToState("calmdown")
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
                inst.sg:GoToState("sleep", true)
            elseif inst.sg.mem.angry then
                inst.AnimState:PlayAnimation("idle_angry")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/grrrr")
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
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
        name = "sleep",
        tags = { "sleeping" },

        onenter = function(inst, notsleeping)
            if notsleeping then
                inst.AnimState:PlayAnimation("sleep_pre")
                inst.SoundEmitter:PlaySound("polarsounds/polarbear/hit")
            else
                inst.AnimState:PlayAnimation("sleep_loop")
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/sleep")
            end
        end,

        timeline = {
            TimeEvent(30*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/sleep")
            end)
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("sleep")
                end
            end)
        }
    },

    State{
        name = "wake",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pst")
            inst.SoundEmitter:PlaySound("polarsounds/polarbear/sniff")
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
            inst.AnimState:PlayAnimation("no")
            inst.SoundEmitter:PlaySound("polarsounds/polarbear/sniff")
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
            inst.AnimState:PlayAnimation("yes")
            inst.SoundEmitter:PlaySound("polarsounds/polarbear/sniff")
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
        name = "congratulate",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("yes")
            inst.SoundEmitter:PlaySound("polarsounds/polarbear/sniff")
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
        name = "yell", -- This state for stopping bear infighting
        tags = { "yelling" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("roar")
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/grrrr")
        end,

        timeline = {
            TimeEvent(27*FRAMES, function(inst)
                inst:DoRoar()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/taunt")
            end)
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
        name = "calmdown",

        onenter = function(inst)
            inst.AnimState:PlayAnimation("calmdown")
            inst.SoundEmitter:PlaySound("polarsounds/polarbear/sniff")
        end,

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