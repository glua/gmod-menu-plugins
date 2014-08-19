CreateClientConVar("menu_fuckLoadingUrl", "0", {FCVAR_ARCHIVE}, [[0 uses server loading url
 	 - 1 uses default loading url
 	 - <url> for custom url]])

CreateConVar("menu_fuckLoadingSteamID", "0", {FCVAR_ARCHIVE}, [[0 your steamid
 	 - <string> whatever you wanna use]])

function cookieSetter(name, old, new)
	print(name, old, new)
	menuCookie.Set(name, new)
end

local oldGD = GameDetails
function GameDetails(name, url, mapname, maxply, steamid, gamemode)
	local val = GetConVarString("menu_fuckLoadingUrl")
	if tonumber(val) == 1 then
		url = "http://loading.garrysmod.com/"
	elseif isstring(val) and #val > 1 then
		url = val
	end

	local sid = GetConVarString("menu_fuckLoadingSteamID")
	if tonumber(sid) ~= 0 then
		steamid = sid
	end


	return oldGD(name, url, mapname, maxply, steamid, gamemode)
end