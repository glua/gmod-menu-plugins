MsgC(Color(255, 255, 255), "Menu Plugins: ", Color(0, 0, 255), "loading...\n")

local bList = {
	steamworks = true,
	include = function(path)
		local path = "lua/menu_plugins/"..path
		local toRun = CompileString(file.Read(path, "GAME"), path)
	
		setfenv(toRun, getfenv())
		toRun()
	end
}

local function illegalCheck(_, k)
	if not bList[k] then return _G[k] end

	if type(bList[k]) ==  'function' then
		return bList[k]
	else
		error(("Attempted to call illegal function: '%s'"):format(k))
	end
end

local nFenv = {}
setmetatable(nFenv, {__index = illegalCheck}) --thx rejax


for k, fil in pairs(file.Find("lua/menu_plugins/*.lua", "GAmE")) do
	if fil == "init.lua" then continue end

	local path = "lua/menu_plugins/"..fil
	local toRun = CompileString(file.Read(path, "GAME"), path)

	setfenv(toRun, nFenv)
	toRun()
end