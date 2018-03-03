local hazards = {}

local map = {}
local spritesheet
local width = 46
local height = 13
local quads
local timer = 0
local max = 4

local function newHazard(type)
    return {
        x = GAME_WIDTH,
        y = GROUND - (type == 4 and 46 or 33),
        quad = type
    }
end

local function resetTimer()
    timer = math.random(0.7, 1.4)
end

function hazards:reset()
    map = {}
    resetTimer()
end

function hazards:load(spritesheetParam)
    if spritesheet == nil then
        spritesheet = spritesheetParam
    end
    if quads == nil then
        quads = {
            love.graphics.newQuad(227, 117, 15, 33, spritesheet:getDimensions()),
            love.graphics.newQuad(161, 116, 32, 33, spritesheet:getDimensions()),
            love.graphics.newQuad(157, 69, 49, 33, spritesheet:getDimensions()),
            love.graphics.newQuad(227, 62, 23, 46, spritesheet:getDimensions())
        }
    end
    resetTimer()
end

function hazards:update(dt)
    timer = timer - dt

    for i = #map, 1, -1 do
        map[i].x = map[i].x - GAME_SPEED * dt
        if map[i].x < -width then
            table.remove(map, i)
        end
    end

    if timer < 0 then
        table.insert(map, newHazard(math.random(4)))
        resetTimer()
    end
end

function hazards:rects()
    local rects = {}
    for i = 1, #map do
        local h = map[i]
        local x, y, width, height = quads[h.quad]:getViewport()
        table.insert(
            rects,
            {
                x = h.x,
                y = h.y,
                width = width,
                height = height
            }
        )
    end
    return rects
end

function hazards:draw()
    for i = 1, #map do
        love.graphics.draw(spritesheet, quads[map[i].quad], map[i].x, map[i].y)
    end
end

return hazards
