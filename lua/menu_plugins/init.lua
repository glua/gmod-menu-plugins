local Lime = Color(127, 255, 0,   255)
local Aquamarine = Color(127, 255, 212, 255)
local LightBlue  = Color(72,  209, 204, 255)

-- TODO: Improve startup banner, it's not fancy enough
local message =
{
	"+-------------------oOo-------------------+",
	"|~ ~ ~ ~ ~ Print this if you are ~ ~ ~ ~ ~|",
	"|~ ~ ~  a beautiful strong lua script  ~ ~|",
	"|~ ~ who is about to load menu plugins ~ ~|",
	"+-------------------oOo-------------------+",
}

local longest = 0
for k, v in pairs(message) do
	if v:len() > longest then longest = v:len() end
end

MsgN()

for k, line in pairs(message) do
	for i=1, line:len() do
		local hue = ((i-1) / longest) * 360
		MsgC(HSVToColor(hue, 0.375, 1), line:sub(i, i))
	end
	MsgN()
end

MsgN()

menup = {} -- We will store menu plugin functions/vars here

for k, fil in pairs(file.Find("lua/menu_plugins/modules/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	MsgC(Aquamarine, "Loading module ")
	MsgC(Lime, fil)
	MsgC(Aquamarine, "...\n")
	
	include("menu_plugins/modules/"..fil)
end

for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	MsgC(Aquamarine, "Loading module '")
	MsgC(Lime, fil)
	MsgC(Aquamarine, "'...\n")
	
	menup.include(fil)
end

MsgC(LightBlue, "\nAll menu plugins loaded!\n\n")

hook.Add("DrawOverlay", "MenuVGUIReady", function()
	hook.Run("MenuVGUIReady")
	hook.Remove("DrawOverlay", "MenuVGUIReady")
end)
