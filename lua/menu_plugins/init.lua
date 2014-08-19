MsgC(Color(255, 255, 255), "\nMenu Plugins: \n")
MsgC(Color(0, 0, 255), "\tloading...\n")

for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	local path = "lua/menu_plugins/"..fil
	RunStringEx(file.Read(path, "GAME"), path)
end

MsgC(Color(0, 255, 00), "All menu plgins loaded!\n")
MsgC("\n")