local snowstorm = {}

snowstorm.flakeSize = 8 --base size for snow flakes
snowstorm.flakeSizeVariation = 2 --how much should the falkes vary in size


snowstorm.flakeSpeed = 100 --base speed
snowstorm.flakeSpeedVariation = 25 --how much should the falkes vary in speed

snowstorm.flakeRotationSpeed = 100 --max rotation
snowstorm.flakeRotationSpeedVariation = 25 --max rotation variation

snowstorm.size = 100 --base size of the storm (how many flakes)

snowstorm.flakes = {}

function snowstorm.makeFlake(x, y, size, speed)
	local flake = {}
	flake.size = size or math.random(snowstorm.flakeSize - snowstorm.flakeSizeVariation, snowstorm.flakeSize + snowstorm.flakeSizeVariation)
	flake.sizeHalved = flake.size / 2 --caching

	flake.x = x or math.random(0, ScrW())
	flake.y = y or 0 - flake.size --make them fall in from the top so they just pop up

	flake.speed = speed or math.random(snowstorm.flakeSpeed - snowstorm.flakeSpeedVariation, snowstorm.flakeSpeed + snowstorm.flakeSpeedVariation)

	flake.rotation = 0
	local speed = math.random(snowstorm.flakeRotationSpeed - snowstorm.flakeRotationSpeedVariation, snowstorm.flakeRotationSpeed + snowstorm.flakeRotationSpeedVariation)
	if math.random(0, 1) == 1 then
		flake.rotationSpeed = snowstorm.flakeRotationSpeed
	else
		flake.rotationSpeed = snowstorm.flakeRotationSpeed  * -1
	end

	return flake
end

function snowstorm.addFlake(x, y, size, speed)
	table.insert(snowstorm.flakes, snowstorm.makeFlake(x, y, size, speed))
end

local function mathCircEaseOut(x)
	local y = 1 - math.sqrt(1 - x*x)
	return y
end

function snowstorm.create(alreadyStarted)
	if alreadyStarted then
		for i=1, snowstorm.size do
			snowstorm.addFlake(math.random(0, ScrW()), math.random(0, ScrH())) --pop
		end
	end

	timer.Create("snowflakePopulator", .05, 0, function()
		if not gui.IsGameUIVisible() then return end
		local toadd = math.Approach(#snowstorm.flakes, snowstorm.size, mathCircEaseOut(1 - #snowstorm.flakes / snowstorm.size) * 25) - #snowstorm.flakes
		for i=1, math.ceil(toadd) do
			snowstorm.addFlake()
		end
	end)
end

if not (tonumber(os.date("%m", os.time())) == 12) then return end -- Only continue if it's December

menup.options.addOption("snowstorm", "enabled", 1)

if tonumber(menup.options.getOption("snowstorm", "enabled")) == 1 then
	snowstorm.create(true)

	hook.Add("DrawOverlay", "MenuP_Snowstorm", function()
		if not gui.IsGameUIVisible() then return end

		surface.SetTexture(surface.GetTextureID("particle/snow"))
		surface.SetDrawColor(color_white)
		for k, flake in ipairs(snowstorm.flakes) do
			surface.DrawTexturedRectRotated(flake.x - flake.sizeHalved / 2, flake.y - flake.sizeHalved / 2, flake.size, flake.size, flake.rotation)

			flake.y = flake.y + flake.speed * FrameTime()

			flake.rotation = flake.rotation + flake.rotationSpeed * FrameTime()
			if flake.rotation > 360 then flake.rotation = -360 end
			if flake.rotation < -360 then flake.rotation = 360 end

			if flake.y > ScrH() then table.remove(snowstorm.flakes, k) end --remove flake
		end
	end)
end
