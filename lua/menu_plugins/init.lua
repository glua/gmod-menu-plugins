MsgC(Color(255, 255, 255), "\nMenu Plugins: \n")
MsgC(Color(0, 0, 255), "\tloading...\n")

local menup = {}

menup.include = function(path)
	return include("menu_plugins/"..path)
end

menup.require = function(modul)
	return require("../../menu_plugins/modules/"..modul)
end

for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	include("menu_plugins/"..fil)
end

MsgC(Color(0, 255, 00), "All menu plgins loaded!\n")
MsgC("\n")