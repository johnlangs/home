local wezterm = require("wezterm")
local config = {}

config.font = wezterm.font({
	family = "FiraMono",
	harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
})
config.font_size = 13

config.color_scheme = "carbonfox"

config.window_padding = {
	left = 5,
	right = 0,
	top = 0,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

config.window_decorations = "RESIZE"

return config
