GAME_WIDTH = 512
GAME_HEIGHT = 288
GAME_SPEED = 300
GROUND = GAME_HEIGHT - 50

local isRunning = true

local push = require "lib/push"
local trex = require "trex"
local ground = require "ground"
local cloud = require "cloud"
local hazards = require "hazards"
local collision = require "collision"

local screenWidth = GAME_WIDTH * 2
local screenHeight = GAME_HEIGHT * 2

local spritesheet = love.graphics.newImage("assets/spritesheet.png")

function love.load()
    love.window.setTitle("tRex")
    math.randomseed(os.time())
    push:setupScreen(
        GAME_WIDTH,
        GAME_HEIGHT,
        screenWidth,
        screenHeight,
        {
            fullscreen = false,
            resizable = false,
            vsync = true
        }
    )
    trex:load(spritesheet)
    ground:load(spritesheet)
    cloud:load(spritesheet)
    hazards:load(spritesheet)
end


local function reset()
    hazards:reset()
    trex:reset()
    isRunning = true
end


function love.update(dt)
    if not isRunning then
        return
    end

    ground:update(dt)
    cloud:update(dt)
    hazards:update(dt)
    trex:update(dt)

    local t = trex:rect()
    local hs = hazards:rects()
    for i = 1, #hs do
        if collision.check(t, hs[i]) then
            trex:handleCollision()
            isRunning = false
        end
    end
end

function love.keypressed(key)
    if key == "space" then
        if isRunning then
            trex:jump()
        else
            reset()
        end
    elseif key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
    ground:draw()
    cloud:draw()
    hazards:draw()
    trex:render()
    push:finish()
end
