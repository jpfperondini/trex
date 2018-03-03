local collision = {}

function collision.check(a, b)
    local d1x = b.x - (a.x + a.width)
    local d1y = b.y - (a.y + a.height)
    local d2x = a.x - (b.x + b.width)
    local d2y = a.y - (b.y + b.height)
    return d1x <= 0 and d1y <= 0 and d2x <= 0 and d2y <= 0
end

return collision
