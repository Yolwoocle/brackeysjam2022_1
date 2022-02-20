-- brackeysjam2022_1
local Class = require "class"
local Player = require "code/player"

local entities = {}

function love.load()
    table.insert(entities, Player:new(200,200))
end 

function love.update(dt)
    for i,ent in ipairs(entities) do
        ent:update(dt)
    end
end

function love.draw()
    for i,ent in ipairs(entities) do
        ent:draw()
    end
end