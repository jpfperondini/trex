local cloud = {}

local BG_SPEED = 30

local map = {}
local spritesheet
local width = 46
local quad
local timer = 0
local max = 4

local function newCloud()
    return {
        x = GAME_WIDTH,
        y = 80 + math.random(-40, 40)
    }
end

function cloud:load(spritesheetParam)
    if spritesheet == nil then
        spritesheet = spritesheetParam
    end
    if quad == nil then
        quad = love.graphics.newQuad(473, 14, width, 13, spritesheet:getDimensions())
    end
    table.insert(map, newCloud())
end

function cloud:update(dt)
    timer = timer + dt
    for i = #map, 1, -1 do
        map[i].x = map[i].x - BG_SPEED * dt
        if map[i].x < -width then
            table.remove(map, i)
        end
    end

    if #map <= max and timer > 3 then
        table.insert(map, newCloud())
        timer = 0
    end
end

function cloud:draw()
    for i = 1, #map do
        love.graphics.draw(spritesheet, quad, map[i].x, map[i].y)
    end
end

return cloud
