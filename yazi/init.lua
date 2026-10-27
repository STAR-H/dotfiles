require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

ps.sub("ind-app-title", function(args)
	args.value = "Yazi: " .. tostring(cx.active.current.cwd)
	return args
end)
