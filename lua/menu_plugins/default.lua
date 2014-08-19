--loads default menu plugins
for k, fil in pairs(file.Find("lua/menu_plugins/default/*.lua", "GAME")) do
	menup.include("default/"..fil)
end