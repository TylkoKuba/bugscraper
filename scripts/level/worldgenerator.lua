require "scripts.util"
local Class = require "scripts.meta.class"

local WorldGenerator = Class:inherit()

function WorldGenerator:init(map)
	self.map = map

	self.screen_w = math.ceil(CANVAS_WIDTH / BW)
	self.screen_h = math.ceil(CANVAS_HEIGHT / BW)
end

function WorldGenerator:reset()
	self.map:reset()
end

function WorldGenerator:set_shaft_rect(x, y, w, h)
	self.shaft_x = x
	self.shaft_y = y
	self.shaft_w = w
	self.shaft_h = h
end

function WorldGenerator:generate_cabin()

	self:reset()

	local map = self.map
	
	-- local ax, ay = floor((map.width - w)/2) + ox, floor((map.height - h)/2) + oy
	-- local bx, by = ax+w-1, ay+h-1
	local x, y, w, h = self.shaft_x, self.shaft_y, self.shaft_w, self.shaft_h
	local ax, ay = x, y
	local bx, by = ax+w-1, ay+h-1
	self.box_ax,  self.box_ay,  self.box_bx,  self.box_by  = ax,    ay,    bx,    by
	self.box_rax, self.box_ray, self.box_rbx, self.box_rby = ax*BW, ay*BW, bx*BW, by*BW

	-- cabin
	self:write_rect(ax, ay, bx, by, 1)
	
	-- chains
	for iy = 0,ay-1 do
		map:set_tile(4, iy, 4)
		map:set_tile(self.box_bx-2, iy, 4)
	end
end

function WorldGenerator:generate_cafeteria()
	self:reset()
	self:write_rect(2, 2, 68, 15, 1)

	-- table
	self:write_rect(27, 13, 40, 13, 3)
end

function WorldGenerator:write_rect(ax, ay, bx, by, value)
	-- Floor/Ceiling
	for ix=ax, bx do
		self.map:set_tile(ix, ay, value)
		self.map:set_tile(ix, by, value)
	end
	-- Left/Right walls
	for iy=ay, by do
		self.map:set_tile(ax, iy, value)
		self.map:set_tile(bx, iy, value)
	end
end

function WorldGenerator:write_rect_fill(ax, ay, bx, by, value)
	for ix=ax, bx do
		for iy=ay, by do
			self.map:set_tile(ix, iy, value)
		end
	end
end

function WorldGenerator:make_floor()
	local map = self.map
	
	local i = 0
	for iy=map.height-4, map.height-1 do
		for ix=0, map.width-1 do
			local s = (i==0) and 1 or 2
			map:set_tile(ix, iy, s)
		end
		i=i+1
	end
end

function WorldGenerator:draw()
	if self.canvas then
		gfx.draw(self.canvas, 0,0)
	end
end



return WorldGenerator