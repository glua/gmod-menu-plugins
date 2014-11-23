local sx = ScrW()/2
local sy = ScrH()/2
local lx = ScrW()/2
local ly = ScrH()/2
local directionx = 0
local directiony = 0
local tile = {}
local Egg = {}
local CountDown = 1
local Startime = CurTime()
local LastEat = CurTime()
local Speed = 200
local Toggle = true
local buff = false

--[[---------------------------------------------------------
NAME: Restart
desc: 
-----------------------------------------------------------]]
local function Restart()

Speed = 2
sx = ScrW()/2
sy = ScrH()/2
tile = {}

end

--[[---------------------------------------------------------
NAME: Eat
desc: 
-----------------------------------------------------------]]
local function Eat( x, y )
	for i= 1,6 do
		table.insert(tile,{x = x-5, y = y } )
	end

end

--[[---------------------------------------------------------
NAME: AddEgg
desc: 
-----------------------------------------------------------]]
local function AddEgg( x, y )

table.insert(Egg,{x = x, y = y})

end

--[[---------------------------------------------------------
NAME: DrawGame
desc: 
-----------------------------------------------------------]]
local function DrawGame()
// easy pause
if( input.IsKeyDown( KEY_BACKSPACE ) ) then
	if( !buff) then	
		buff = true
		// press
		if( Toggle ) then
			Toggle = false
		else
			Toggle = true
		end					
	end		
else
buff = false 
end

if( !Toggle ) then return end

directionx,directiony = 0,0
	if(input.IsKeyDown(KEY_UP) ) then
		Dir = 1
	elseif(input.IsKeyDown(KEY_DOWN) ) then
		Dir = 2
	elseif(input.IsKeyDown(KEY_RIGHT) ) then
		Dir = 3
	elseif(input.IsKeyDown(KEY_LEFT) ) then
		Dir = 4
	end

	if(Dir == 1 ) then directiony = -1 elseif(Dir == 2 ) then directiony = 1 elseif(Dir == 3 ) then directionx = 1 elseif(Dir == 4 ) then directionx = -1 end
	
	lx,ly = sx,sy
	sx = sx + directionx * Speed * FrameTime()
	sy = sy + directiony * Speed * FrameTime()

	if( (sy <= 0) or ( sy >= ScrH()) or(sx <= 0) or ( sx >= ScrW() ) ) then
	Restart()
	end
 
	if( #Egg > 0 ) then
		if( sx +15 >= Egg[1].x  && sx <= Egg[1].x+15  && sy+15  >= Egg[1].y && sy <= Egg[1].y+15) then
			Eat( lx, ly )
			LastEat = CurTime()
			table.Empty(Egg)
		end
	end

	if( CurTime() >= LastEat + CountDown and #Egg < 1 ) then
		AddEgg( math.Round(math.random(20,ScrW()-20)), math.Round(math.random(20,ScrH()-ScrH()*0.125)) )
	end

	for i=#tile,2,-1 do
		tile[i] = tile[i-1]
		if(sx == tile[i].x  && sy == tile[i].y ) then
			Die()
			break
		end
	end		
		tile[1] = {x=lx,y=ly}


	local col = math.abs(math.sin(CurTime() * 2.5))

	for k,v in ipairs(tile) do
		surface.SetDrawColor(120 + (135 * col),50,150 * col,255)
		surface.DrawRect(v.x ,v.y,15,15)
	end

	for k,v in ipairs(Egg) do

		surface.SetDrawColor(120 + (135 * col),50,0,255)
		surface.DrawRect(v.x ,v.y,15,15)

	end
	
	surface.SetDrawColor(50,120 + (135 * col),150 * col,255)
	surface.DrawRect(sx,sy,15,15)

end

hook.Add("DrawOverlay","Draw_Game",DrawGame)
