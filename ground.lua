local ground = {}
local map = {}
local size = 2
local quads
local spritesheet

function ground:load(spritesheetParam)
    if spritesheet == nil then
        spritesheet = spritesheetParam
    end
    if quads == nil then
        quads = {
            love.graphics.newQuad(16, 271, 544, 11, spritesheet:getDimensions()),
            love.graphics.newQuad(447, 250, 28, 11, spritesheet:getDimensions()),
            love.graphics.newQuad(478, 250, 28, 11, spritesheet:getDimensions())
        }
    end
    self.width = 544
    self.x = 0
    self.y = GROUND - 11
    for i = 1, size do
        map[i] = {}
        map[i].quad = 1
        map[i].x = (i - 1) * self.width
    end
end

function ground:update(dt)
    for i = 1, size do
        map[i].x = map[i].x - GAME_SPEED * dt
        if map[i].x < -self.width then
            map[i].x = map[i].x + size * self.width
        end
    end
end

function ground:draw()
    for i = 1, size do
        love.graphics.draw(spritesheet, quads[map[i].quad], map[i].x, self.y)
    end
end

return ground
