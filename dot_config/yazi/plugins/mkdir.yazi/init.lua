local state = ya.sync(function() return cx.active.current.cwd end)

local function entry()
	local _permit = ya.hide()

	print("\x1b[2J\x1b[1;1H")
	os.execute("nu -c \"sudo zpool import -lf -R /run/media/sorath Legion\"")
	ya.manager_emit("cd", { "/run/media/sorath/Legion" })
end

return { entry = entry }
