require "scripts.util"
local Upgrade = require "scripts.upgrade.upgrade"
local images= require "data.images"
local EffectSlowness = require "scripts.effect.effect_slowness"

local UpgradeMilk = Upgrade:inherit()

function UpgradeMilk:init()
    self.name = "milk"
    self:init_upgrade()
    self.sprite = images.upgrade_milk
    self.strength = 1

    self.color = COL_WHITE
end

function UpgradeMilk:update(dt)
    self:update_upgrade(dt)
end

function UpgradeMilk:on_apply(player)
    for _, p in pairs(game.players) do
        p:add_max_life(self.strength)
        p:heal(self.strength)
    end 
end

function UpgradeMilk:on_finish(player)
end

return UpgradeMilk