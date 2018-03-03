local trex = {}

local runAnimation
local idleAnimation
local deathAnimation
local currentAnimation
local spritesheet

local runFPS = 10
local runSPF = 1 / runFPS
local timer = 0
local currentQuad = 1
local GRAVITY = 1500
local JUMP_SPEED = -500

function trex:load(spritesheetParam)
    if spritesheet == nil then
        spritesheet = spritesheetParam
    end

    if runAnimation == nil then
        runAnimation = {
            love.graphics.newQuad(6, 123, 40, 43, spritesheet:getDimensions()),
            love.graphics.newQuad(55, 123, 40, 43, spritesheet:getDimensions())
        }
    end

    if idleAnimation == nil then
        idleAnimation = {
            love.graphics.newQuad(7, 47, 40, 43, spritesheet:getDimensions())
        }
    end

    if deathAnimation == nil then
        deathAnimation = {
            love.graphics.newQuad(70, 49, 40, 43, spritesheet:getDimensions())
        }
    end
    trex:reset()
end

function trex:handleCollision()
    currentAnimation = deathAnimation
    currentQuad = 1
end

function trex:reset()
    currentAnimation = runAnimation
    self.width = 40
    self.height = 43
    self.x = 100
    self.y = GROUND - self.height
    self.vy = 0
end

function trex:jump()
    if not isJumping then
        isJumping = true
        currentAnimation = idleAnimation
        currentQuad = 1
        self.vy = JUMP_SPEED
    end
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
    self.vy = self.vy + GRAVITY * dt
    self.y = math.min(GROUND - self.height, self.y + self.vy * dt)
    if self.y == GROUND - self.height then
        if isJumping then
            isJumping = false
            currentAnimation = runAnimation
        end
        self.vy = 0
    end

    timer = timer + dt
    if timer > runSPF then
        currentQuad = currentQuad + 1
        if currentQuad > #currentAnimation then
            currentQuad = 1
        end
        timer = 0
    end
end


function trex:draw()
    love.graphics.draw(spritesheet, currentAnimation[currentQuad], self.x, self.y)
end

return trex
