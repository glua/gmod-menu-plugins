menup.options.addOption("noLoadingUrl", "url", 0)
menup.options.addOption("noLoadingUrl", "steamid", 0)

local oldGD = GameDetails
function GameDetails(name, url, mapname, maxply, steamid, gamemode)
	local val = menup.options.getOption("noLoadingUrl", "url")
	if tonumber(val) == 1 then
		url = "http://loading.garrysmod.com/"
	elseif isstring(val) and #val > 1 then
		url = val
	end

	local sid = menup.options.getOption("noLoadingUrl", "steamid")
	if tonumber(sid) ~= 0 then
		steamid = sid
	end


	return oldGD(name, url, mapname, maxply, steamid, gamemode)
end