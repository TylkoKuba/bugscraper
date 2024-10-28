require "scripts.util"
local images = require "data.images"
local Projectile = require "scripts.actor.enemies.projectile"
local Larva = require "scripts.actor.enemies.larva"

local LarvaProjectile = Projectile:inherit()

function LarvaProjectile:init(x, y)
    self.super.init(self, x, y, images.larva_projectile, 8, 8, __invul_duration, __angle, min_speed, max_speed)
    self.gravity_mult = 0.4
    self.name = "larva_projectile"

    self.larva = nil
    self.spr.rot = random_range(0, pi2)
end

function LarvaProjectile:update(dt)
    self.super.update(self, dt)
    
    self.spr.rot = self.spr.rot + dt
end

function LarvaProjectile:on_projectile_land()
    self:kill()

    local larva = Larva:new(self.mid_x, self.mid_y)
    larva.loot = {}
    game:new_actor(larva)

    self.larva = larva
end

return LarvaProjectile