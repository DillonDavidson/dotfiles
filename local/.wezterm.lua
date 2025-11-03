local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.enable_scroll_bar = false
config.font_size = 16
config.color_scheme = "Kanagawa (Gogh)"

wezterm.on("toggle-tabbar", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if overrides.enable_tab_bar == false then
		wezterm.log_info("tab bar shown")
		overrides.enable_tab_bar = true
	else
		wezterm.log_info("tab bar hidden")
		overrides.enable_tab_bar = false
	end
	window:set_config_overrides(overrides)
end)

config.keys = {
	{ key = "t", mods = "ALT", action = act.EmitEvent("toggle-tabbar") },
}

config.window_padding = {
	left = "0.1cell",
	right = "0.1cell",
	top = "0.1cell",
	bottom = "0.1cell",
}

return config
