local Class = require "class"
local Collision = require "collision"
local Player = require "player"
local Enemies = require "enemies"
local Bullet = require "bullet"
local TileMap = require "tilemap"
local WorldGenerator = require "worldgenerator"
local Inventory = require "inventory"

local images = require "images"
require "util"
require "constants"

local Game = Class:inherit()

function Game:init()
	-- Global singletons
	collision = Collision:new()

	self.number_of_player = 2

	self.map = TileMap:new(30, 17)
	self.world_generator = WorldGenerator:new(self.map)
	self.world_generator:generate(10203)

	-- Bounding box
	local map_w = self.map.width * BW
	local map_h = self.map.height * BW
	self.box_up = {name="box_up",     is_solid = true, x = -BW, y = -BW,      w=map_w + 2*BW, h=BW}
	self.box_down = {name="box_down", is_solid = true, x = -BW, y = map_h, w=map_w + 2*BW, h=BW}
	collision:add(self.box_up)
	collision:add(self.box_down)
	
	self.actors = {}
	self:init_players()
	self:new_actor(Enemies.Bug:new(64,64))

	self.inventory = Inventory:new()

	-- Debugging
	self.debug_mode = false
	self.msg_log = {}
end

function Game:update(dt)
	self.map:update(dt)

	for k,actor in pairs(self.actors) do
		actor.debug_timer = 0
	end

	for k,actor in pairs(self.actors) do
		if not actor.debug_timer then    actor.debug_timer = 0    end
		actor.debug_timer = actor.debug_timer + 1
		actor:update(dt)
	end

	-- Delete actors
	for i = #self.actors, 1, -1 do
		local actor = self.actors[i]
		if actor.is_removed then
			table.remove(self.actors, i)
		end
	end

	if love.keyboard.isDown("r") then   
		self.world_generator.seed = self.world_generator.seed - 0.05
		self.world_generator:generate(self.map)
	end
	if love.keyboard.isDown("t") then   
		self.world_generator.seed = self.world_generator.seed + 0.05
		self.world_generator:generate(self.map)
	end
end

function Game:draw()
	-- Sky
	gfx.clear(COL_SKY)

	self.map:draw()
	for k,actor in pairs(self.actors) do
		actor:draw()
	end

	if self.debug_mode then
		self:draw_debug()
	end

	gfx.print(concat("FPS: ",love.timer.getFPS()), 0, 0)
end

function Game:new_actor(actor)
	table.insert(self.actors, actor)
end

function Game:draw_debug()
	local items, len = collision.world:getItems()
	for i,it in pairs(items) do
		local x,y,w,h = collision.world:getRect(it)
		rect_color({0,1,0},"line", x, y, w, h)
	end
	
	-- Print FPS
	rect_color({0,0,0,0.5}, "fill", 0, 0, 50, 32)
	print_color(COL_WHITE, love.timer.getFPS(), 0, 0) 
	
	self.world_generator:draw()
	draw_log()
end

function Game:init_players()
	local control_schemes = {
		[1] = {
			type = "keyboard",
			left = {"a"},
			right = {"d"},
			up = {"w"},
			down = {"s"},
			jump = {"c"},
			fire = {"v"},
		},
		[2] = {
			type = "keyboard",
			left = {"left"},
			right = {"right"},
			up = {"up"},
			down = {"down"},
			jump = {"."},
			fire = {","},
		}
	}

	local sprs = {
		images.ant,
		images.caterpillar
	}

	self.players = {}

	-- Spawn at middle
	local mx = floor((self.map.width - self.number_of_player) / 2)
	local my = floor(self.map.height / 2)

	for i=1, self.number_of_player do
		local player = Player:new(i, mx*16 + i*16, my*16, sprs[i], control_schemes[i])
		self.players[i] = player
		self:new_actor(player)
	end
end

function Game:keypressed(key, scancode, isrepeat)
	if key == "f3" then
		self.debug_mode = not self.debug_mode
	end

	for i, ply in pairs(self.players) do
		--ply:keypressed(key, scancode, isrepeat)
	end
end

function Game:keyreleased(key, scancode)
	for i, ply in pairs(self.players) do
		--ply:keyreleased(key, scancode)
	end
end

return Game