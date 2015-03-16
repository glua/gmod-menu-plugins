MsgC(Color(255, 255, 255), "\nMenu Plugins: \n")
MsgC(Color(0, 0, 255), "\tloading...\n")

menup = {} --we will store menu plugin functions/vars here

for k, fil in pairs(file.Find("lua/menu_plugins/modules/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	MsgC(Color(0, 0, 255), "Loading module '"..fil.."'...")
	include("menu_plugins/modules/"..fil)
end

for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	MsgC(Color(0, 0, 255), "Loading module '"..fil.."'...")
	menup.include(fil)
end

MsgC(Color(0, 255, 00), "All menu plugins loaded!\n")
MsgC("\n")

hook.Add("DrawOverlay", "MenuVGUIReady", function()
	hook.Run("MenuVGUIReady")
	hook.Remove("DrawOverlay", "MenuVGUIReady")
end)