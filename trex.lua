local Animation = require "animation"
local StateMachine = require "stateMachine"

local trex = {}
local animation
local stateMachine

local GRAVITY = 1500
local JUMP_SPEED = -500

-- RUN STATE
local function runEnter(target, previous)
    animation:set("run")
end

-- JUMP STATE
local function jumpEnter(target, previous)
    animation:set("idle")
    target.vy = JUMP_SPEED
end

local function jumpUpdate(dt, target)
    target.vy = target.vy + GRAVITY * dt
    target.y = math.min(GROUND - target.height, target.y + target.vy * dt)
    if target.y == GROUND - target.height then
        state:set("run")
    end
end

-- DEATH STATE
local function deathEnter(target, previous)
    animation:set("death")
end

local function jumpExit(target)
    target.vy = 0
end

function trex:load(spritesheet)
    if animation == nil then
        animation = Animation.new(spritesheet, 10)
        animation:add(
            "run",
            {
                {x = 6, y = 123, w = 40, h = 43},
                {x = 55, y = 123, w = 40, h = 43}
            }
        )
        animation:add("idle", {{x = 7, y = 47, w = 40, h = 43}})
        animation:add("death", {{x = 69, y = 49, w = 40, h = 43}})
    end

    if state == nil then
        state = StateMachine.new(self)
        state:add("run", runEnter, nil, nil)
        state:add("jump", jumpEnter, jumpUpdate, jumpExit)
        state:add("death", deathEnter, nil, nil)
    end

    trex:reset()
end

function trex:reset()
    state:set("run")
    self.width = 40
    self.height = 43
    self.x = 100
    self.y = GROUND - self.height
    self.vy = 0
end

function trex:handleCollision()
    state:set("death")
end

function trex:jump()
    state:set("jump")
end

function trex:rect()
    return {
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height
    }
end

function trex:update(dt)
    state:update(dt)
    animation:update(dt)
end

function trex:render()
    animation:render(self.x, self.y)
end

return trex
