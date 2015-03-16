menup.options.addOption("snake", "enabled", 1)

local squarew = 15

local snake = {headx = ScrW()/2, heady = ScrH()/2, dirx = 0, diry = 0, length = 0, tail = {}}
local egg = {x = 0, y = 0}
local speed = 200
local score = 0

local function MoveEgg()
	egg.x = math.Round(math.random(20,ScrW()-20))
	egg.y = math.Round(math.random(20,ScrH()-ScrH()*0.125))
end
MoveEgg()

local function Restart()
	if score > 0 then print("You died! Final score: "..score.."!") end
	speed = 200
	score = 0
	snake = {headx = ScrW()/2, heady = ScrH()/2, dirx = 0, diry = 0, length = 0, tail = {}}
	MoveEgg()
end

local function Eat()
	snake.length = snake.length + squarew -- lol
	MoveEgg()
	speed = math.min(speed * 1.02, 600) -- 300 at ~20 eggs, 400 at ~35, 500 at 45-50, 600 at ~55; perhaps linear would be better?
	score = score + math.Round(speed/150) -- 1 until 225, 2 until 375, 3 until 525, etc.
end

local function DrawGame()
	if input.IsKeyDown(KEY_BACKSPACE) then return end -- pause or something

	-- Check movement changes
	local up, down, left, right = input.IsKeyDown(KEY_UP), input.IsKeyDown(KEY_DOWN), input.IsKeyDown(KEY_LEFT), input.IsKeyDown(KEY_RIGHT)
	if (up or down) and (snake.diry == 0) then
		snake.diry = (up) and -1 or 1
		snake.dirx = 0
	elseif (left or right) and (snake.dirx == 0) then
		snake.dirx = (left) and -1 or 1
		snake.diry = 0
	end

	-- Update tail
	table.insert(snake.tail, 1, {x = snake.headx, y = snake.heady})
	if #snake.tail > snake.length then
		table.remove(snake.tail, #snake.tail)
	end

	-- Update snake pos
	local changex = snake.dirx * speed * FrameTime()
	local changey = snake.diry * speed * FrameTime()

	snake.headx = snake.headx + changex
	snake.heady = snake.heady + changey

	-- Check if snake is outside the window
	if (snake.headx <= 0) or (snake.heady <= 0) or (snake.heady + squarew >= ScrH()) or (snake.headx + squarew >= ScrW()) then
		Restart()
	end

	-- Check if snake is eating the egg
	if (egg.x <= snake.headx + squarew) and (snake.headx <= egg.x + squarew) and (egg.y <= snake.heady + squarew) and (snake.heady <= egg.y + squarew) then
		Eat()
	end

	local col = math.abs(math.sin(CurTime() * 2.5))

	-- Draw egg
	surface.SetDrawColor(120 + (135 * col), 50, 0, 255)
	surface.DrawRect(egg.x, egg.y, squarew, squarew)

	-- Draw tail
	surface.SetDrawColor(120 + (135 * col),50,150 * col, 255)
	for i = 1, #snake.tail do
		local tile = snake.tail[i]
		if not tile then break end
		surface.DrawRect(tile.x, tile.y, squarew, squarew)
		if (i > squarew*3) and (tile.x >= snake.headx) and (tile.x <= snake.headx + squarew) and (tile.y >= snake.heady) and (tile.y <= snake.heady + squarew) then -- trust me
			Restart()
		end
	end

	-- Draw snake
	surface.SetDrawColor(50, 120 + (135 * col), 150 * col, 255)
	surface.DrawRect(snake.headx, snake.heady, squarew, squarew)

	-- Draw score
	surface.SetTextColor(color_white)
	local text = "Snake score: "..score
	surface.SetFont("DermaLarge")
	local w, h = surface.GetTextSize(text)
	surface.SetTextPos(ScrW() * 0.9 - w, ScrH() * 0.1)
	surface.DrawText(text)
end

if tonumber(menup.options.getOption("snake", "enabled")) == 1 then
	hook.Add("DrawOverlay", "MenuP_Snake_Draw", DrawGame)
end