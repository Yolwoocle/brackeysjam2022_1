local Class = require "class"
require "code/sprites"

local Player = Class:inherit()

function Player:initialize(x,y)
    self.x = x
    self.y = y
    self.dx = 0
    self.dy = 0

    self.speed = 200
    self.friction = 0.7
end

function Player:update(dt)
    self:move(dt)
end

function Player:draw()
    love.graphics.rectangle("fill", self.x, self.y, 32, 32)
end

function Player:move(dt)
    local dir_vector = {x = 0, y = 0}
    if love.keyboard.isDown("q") or love.keyboard.isDown("a") then
        dir_vector.x = dir_vector.x - 1
    end 
    if love.keyboard.isDown("d") then
        dir_vector.x = dir_vector.x + 1
    end 
    if love.keyboard.isDown("z") or love.keyboard.isDown("w") then
        dir_vector.y = dir_vector.y - 1
    end 
    if love.keyboard.isDown("s") then
        dir_vector.y = dir_vector.y + 1
    end 
    -- Normalize the direction vector
    local norm = math.sqrt(dir_vector.x * dir_vector.x + dir_vector.y * dir_vector.y) + 0.0001
    dir_vector.x = dir_vector.x / norm
    dir_vector.y = dir_vector.y / norm

    self.dx = (self.dx + dir_vector.x * self.speed) * self.friction
    self.dy = (self.dy + dir_vector.y * self.speed) * self.friction

    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

return Player
