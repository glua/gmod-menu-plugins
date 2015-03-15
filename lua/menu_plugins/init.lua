menup = {} --we will store menu plugin functions/vars here

function menup.Message(col, str)
	MsgC(col, "Menu Plugins: "..str, "\n")
end
function menup.Error(str)
	MsgC(Color(200, 0, 0), "[Menu Plugins ERROR]: "..str, "\n")
end

menup.Message(Color(0, 200, 0), "Loading plugins...")

for k, fil in pairs(file.Find("lua/menu_plugins/modules/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	menup.Message(Color(0, 0, 200), "Loading module '"..fil.."'...")
	include("menu_plugins/modules/"..fil)
end

for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAME")) do
	if fil == "init.lua" then continue end

	menup.Message(Color(0, 0, 200), "Loading module '"..fil.."'...")
	menup.include(fil)
end

menup.Message(Color(0, 200, 0), "All menu plugins loaded!\n")

hook.Run("MenuP_Loaded") -- Currently unused

hook.Add("DrawOverlay", "MenuValid", function()
	hook.Run("MenuValid")
	hook.Remove("DrawOverlay", "MenuValid")
end)
