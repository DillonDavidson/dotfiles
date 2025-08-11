local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()
local mux = wezterm.mux

config.default_domain = "WSL:archlinux"

wezterm.on("gui-startup", function(window)
	local tab, pane, window = mux.spawn_window(cmd or {})
	local gui_window = window:gui_window()
	gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

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

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.enable_scroll_bar = false
config.font_size = 16
config.color_scheme = "Kanagawa (Gogh)"

config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0cell",
	bottom = "0cell",
}

return config
