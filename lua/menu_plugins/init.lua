local Chartreuse = Color(127, 255, 0,   255)
local Aquamarine = Color(127, 255, 212, 255)
local LightBlue  = Color(72,  209, 204, 255)
MsgC(LightBlue, "\n.-~= Menu Plugins =~-.\n")

menup = {} --we will store menu plugin functions/vars here

for k, fil in pairs(file.Find("lua/menu_plugins/modules/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	MsgC(Aquamarine, "Loading module '")
	MsgC(Chartreuse, fil)
	MsgC(Aquamarine, "'...\n")
	include("menu_plugins/modules/"..fil)
end

for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	MsgC(Aquamarine, "Loading module '")
	MsgC(Chartreuse, fil)
	MsgC(Aquamarine, "'...\n")
	
	menup.include(fil)
end

MsgC(LightBlue, "All menu plugins loaded!\n")
MsgC("\n")

hook.Add("DrawOverlay", "MenuVGUIReady", function()
	hook.Run("MenuVGUIReady")
	hook.Remove("DrawOverlay", "MenuVGUIReady")
end)
