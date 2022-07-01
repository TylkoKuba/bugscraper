local Class = require "class"
local Game = require "game"
require "util"

game = nil 
is_fullscreen = false

function love.load(arg)
	love.window.setMode(0, 0, {
		fullscreen = true, 
		resizable = true, 
		vsync = true, 
		minwidth = 400, 
		minheight = 300,
	})	
	gfx.setDefaultFilter("nearest", "nearest")
	
	SCREEN_WIDTH, SCREEN_HEIGHT = gfx.getDimensions()
	CANVAS_WIDTH = 480
	CANVAS_HEIGHT = 270

	WINDOW_WIDTH = CANVAS_WIDTH * 3
	WINDOW_HEIGHT = CANVAS_WIDTH * 3

	screen_sx = SCREEN_WIDTH / CANVAS_WIDTH or SCREEN_WIDTH
	screen_sy = SCREEN_HEIGHT / CANVAS_HEIGHT or SCREEN_HEIGHT
	CANVAS_SCALE = min(screen_sx, screen_sy)
	CANVAS_OX = max(0, (SCREEN_WIDTH  - CANVAS_WIDTH  * CANVAS_SCALE)/2)
	CANVAS_OY = max(0, (SCREEN_HEIGHT - CANVAS_HEIGHT * CANVAS_SCALE)/2)

	canvas = gfx.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)

	love.window.setTitle("Elevator game")

	-- Load fonts
	FONT_REGULAR = gfx.newFont("fonts/HopeGold.ttf", 16)
	FONT_7SEG = gfx.newImageFont("fonts/7seg_font.png", " 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	FONT_MINI = gfx.newFont("fonts/Kenney Mini.ttf", 8)
	gfx.setFont(FONT_REGULAR)

	game = Game:new()
end

t = 0
fdt = 1/60 -- fixed frame delta time
local function fixed_update()
	--update that happens at the fixed fdt interval
	game:update(fdt)
end

function love.update(dt)
	t = t + dt
	local cap = 4
	local i = 0
	while t > fdt and cap > 0 do
		t = t - fdt
		fixed_update()
		cap = cap - 1
		i=i+1
	end
	-- if t > 0 then    t = 0    end
	if game then   game.frame_repeat = i end
end

function love.draw()
	gfx.setCanvas(canvas)
    gfx.clear(0,0,0)
    gfx.translate(0, 0)

	game:draw()
	
    -- Canvas for that sweet pixel art
    gfx.setCanvas()
    gfx.origin()
    gfx.scale(1, 1)
    gfx.draw(canvas, CANVAS_OX, CANVAS_OY, 0, CANVAS_SCALE, CANVAS_SCALE)

end

function love.keypressed(key, scancode, isrepeat)
	if key == "f5" then
		if love.keyboard.isDown("lshift") then
			love.event.quit("restart")
		end

	elseif key == "f4" then
		if love.keyboard.isDown("lshift") then
			love.event.quit()
		end
	
	elseif key == "f11" then
		--is_fullscreen = not is_fullscreen
		love.window.setFullscreen(is_fullscreen)

	elseif key == "m" then
		game.sound_on = not game.sound_on

	end

	if game.keypressed then  game:keypressed(key, scancode, isrepeat)  end
end

function love.keyreleased(key, scancode)
	if game.keyreleased then  game:keyreleased(key, scancode)  end
end

function love.mousepressed(x, y, button, istouch, presses)
	if game.mousepressed then   game:mousepressed(x, y, button)   end
end

--function love.quit()
--	game:quit()
--end

function love.resize(w, h)
	WINDOW_WIDTH = w
	WINDOW_HEIGHT = h
	if game.resize then   game:resize(w,h)   end
end

function love.textinput(text)
	if game.textinput then  game:textinput(text)  end
end

old_print = print
msg_log = {}
function print(...)
	old_print(...)
	
	table.insert(msg_log, concatsep({...}, " "))

	if #msg_log > 10 then
		table.remove(msg_log, 1)
	end
end
