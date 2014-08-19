--menu plugin globals
menup = {}

menup.include = function(path)
	return include("menu_plugins/"..path)
end