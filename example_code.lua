local Bullet = require "bullet"
local Class = require "class"
local Weapon = require "weapon"
local SeedGun = require "seed_gun"

local image = require "images"
require "utility"
require "collision"

local Player = Class:inherit()

function Player:initialize(parent, x, y, speed, sprite)
    self.parent = parent
    self.type = "player"
    self.id = "player"
    self.name = "Player"

    self.sprite = sprite
    
    self.life = 100
    self.x = x
    self.y = y
    self.dx = 0.0
    self.dy = 0.0
    self.r = r
    self.speed = speed
    self.friction = 0.9
    self.mass = 300
    
    self.damage_cooldown = 1.0
    self.last_damaged = 0.0

    self.target_x = 0
    self.target_y = 0
    self.rel_target_x = 0
    self.rel_target_y = 0
    self.target_angle = 0

    self.weapon = SeedGun:new()
    self.bullets = {}

    self.hitbox = {
        r = 20
    }
    self.nudgable = true

    self.debug = ""
end

function Player:movement(dt)
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

function Player:update_target(dt)
    local mx, my = love.mouse.getPosition()
    self.target_x = mx
    self.target_y = my

    self.rel_target_x = mx - self.x
    self.rel_target_y = my - self.y

    self.target_angle = math.atan2(self.rel_target_y, self.rel_target_x)
end

function Player:shoot(dt)
    local bullet_dx = math.cos(self.target_angle) * 700 
    local bullet_dy = math.sin(self.target_angle) * 700
    local a = self.target_angle
    local bullet = Bullet:new(
        self.parent,
        self.x + math.cos(a)*50, 
        self.y + math.sin(a)*50, 
        bullet_dx, bullet_dy, 
        math.randomchoice(image.seed),
        math.random(-math.pi, math.pi),
        self.weapon.damage, 0.4
    )
    self.parent[bullet] = bullet
    self.weapon:shoot()
end

function Player:do_shooting(dt)
    self:update_target(dt)
    if love.mouse.isDown(1) and self.weapon:can_shoot() then
        self:shoot(dt)
    end
end

function Player:damage(n)
    if self.last_damaged + self.damage_cooldown <= love.timer.getTime() then
        self.life = self.life - n
        self.last_damaged = love.timer.getTime()
    end
end

function Player:check_collision()
    for _,v in pairs(self.parent) do
        if v.type == "enemy" then
            if circles_collide(self,v) then
                self:damage(v.damage)
            end
        end
    end
end

function Player:update(dt)
    self:movement(dt)
    self:do_shooting(dt)
    self:check_collision()
end

function Player:draw()
    love.graphics.circle("fill", self.x, self.y, 20)
    love.graphics.print("ammo "..tostring(self.weapon.ammo), self.x-30, self.y - 40)
    love.graphics.print("life "..tostring(self.life), self.x-30, self.y - 60)
    local a = self.target_angle
    self.weapon:draw(self.x + math.cos(a)*30, self.y + math.sin(a)*30, self.target_angle)
end

return Player