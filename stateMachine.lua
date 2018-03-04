local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:add(name, enter, update, exit)
    local state = {
        enter = enter,
        update = update,
        exit = exit
    }

    if state.update == nil then
        state.update = function()
        end
    end

    if state.enter == nil then
        state.enter = function()
        end
    end

    if state.exit == nil then
        state.exit = function()
        end
    end

    self.states[name] = state

    if current == nil then
        current = name
    end
end

function StateMachine:set(name)
    if self.current == name then
        return
    end

    self.previous = self.current
    if self.previous ~= nil then
        self.states[self.current].exit(self.target)
    end
    self.current = name
    self.states[self.current].enter(self.target, self.previous)
end

function StateMachine:update(dt)
    self.states[self.current].update(dt, self.target)
end

local Module = {}

function Module.new(target)
    return setmetatable(
        {
            states = {},
            current = nil,
            previous = nil,
            target = target
        },
        StateMachine
    )
end

return Module
