local Animation = {}
Animation.__index = Animation

function Animation:add(name, quadsDimension)
    assert(type(name) == "string", "name should be string")
    assert(type(quadsDimension) == "table", "quadsDimension should be table")

    local frames = {}
    for i = 1, #quadsDimension do
        local q = quadsDimension[i]
        local quad = love.graphics.newQuad(q.x, q.y, q.w, q.h, self.spritesheet:getDimensions())
        table.insert(frames, quad)
    end
    self.states[name] = frames

    if self.currentState == nil then
        self:set(name)
    end
end

function Animation:set(name)
    self.currentState = name
    self.currentFrame = 1
end

function Animation:update(dt)
    self.timer = self.timer + dt
    if self.timer > 1 / self.fps then
        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > #self.states[self.currentState] then
            self.currentFrame = 1
        end
        self.timer = 0
    end
end

function Animation:render(x, y)
    love.graphics.draw(self.spritesheet, self.states[self.currentState][self.currentFrame], x, y)
end

local AnimationModule = {}

function AnimationModule.new(spritesheet, fps)
    return setmetatable(
        {
            currentFrame = 1,
            currentState = nil,
            fps = fps,
            states = {},
            spritesheet = spritesheet,
            timer = 0
        },
        Animation
    )
end

return AnimationModule