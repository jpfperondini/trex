local score = {}
local highScore = 0
local currentScore = 0
local spritesheet
local quads

local scoreWidth = (9 + 1) * 5
local hiTextWidth = 20
local scoreRightPadding = 10
local currentScoreX = GAME_WIDTH - scoreRightPadding - scoreWidth
local highScoreX = currentScoreX - scoreWidth - scoreRightPadding
local hiTextX = highScoreX - hiTextWidth - scoreRightPadding

function score:load(spritesheetParam)
    if spritesheet == nil then
        spritesheet = spritesheetParam
        quads = {}
        quads["hi"] = love.graphics.newQuad(589, 66, 20, 11, spritesheet:getDimensions())
        quads["0"] = love.graphics.newQuad(594, 79, 9, 11, spritesheet:getDimensions())
        for i = 1, 9 do
            local xPadding = 0
            if i > 5 then
                xPadding = 1
            end
            local yPadding = (i * (11 + 2))
            if i >= 4 then
                yPadding = yPadding - 1
            end
            if i >= 7 then
                yPadding = yPadding - 1
            end
            if i >= 8 then
                yPadding = yPadding - 1
            end

            quads[tostring(i)] =
                love.graphics.newQuad(595 + xPadding, 79 + yPadding, 9, 11, spritesheet:getDimensions())
        end
    end

    score:reset()
end

function score:reset()
    if currentScore > highScore then
        highScore = currentScore
    end

    currentScore = 0
end

function score:update(dt)
    currentScore = currentScore + 0.3
end

local function renderScore(score, x)
    local textScore = string.format("%05d", score)
    for i = 1, textScore:len() do
        local digit = textScore:sub(i, i)
        love.graphics.draw(spritesheet, quads[digit], x + ((i - 1) * (9 + 1)), 10)
    end
end

function score:render()
    renderScore(currentScore, currentScoreX)
    renderScore(highScore, highScoreX)
    love.graphics.draw(spritesheet, quads["hi"], hiTextX, 10)
end

return score
