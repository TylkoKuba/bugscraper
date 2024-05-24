require "scripts.util"
local Enemy = require "scripts.actor.enemy"
local sounds = require "data.sounds"
local images = require "data.images"

local Guns = require "data.guns"
local Slug = require "scripts.actor.enemies.slug"
local PongBall = require "scripts.actor.enemies.pong_ball"

local SnailShelled = PongBall:inherit()

function SnailShelled:init(x, y, spr)
    self:init_snail_shelled(x, y, spr)
end

function SnailShelled:init_snail_shelled(x, y, spr)
    self:init_pong_ball(x,y, spr or images.snail_shell, 16, 16)
    self.name = "snail_shelled"

    self.is_flying = true
    self.follow_player = false
    self.do_stomp_animation = false

    -- self.destroy_bullet_on_impact = false
    -- self.is_bouncy_to_bullets = true
    -- self.is_immune_to_bullets = true

    self.sound_death = "snail_shell_crack"
    self.sound_stomp = "snail_shell_crack"
end

function SnailShelled:update(dt)
    self:update_snail_shelled(dt)
end
function SnailShelled:update_snail_shelled(dt)
    self:update_pong_ball(dt)
end

function SnailShelled:draw()
    self:draw_pong_ball()
end

function SnailShelled:on_death()
    Particles:image(self.mid_x, self.mid_y, 30, images.snail_shell_fragment, 13, nil, 0, 10)
    local slug = Slug:new(self.x, self.y)
    slug.vy = -200
    slug.harmless_timer = 0.5
    game:new_actor(slug)
end

return SnailShelled