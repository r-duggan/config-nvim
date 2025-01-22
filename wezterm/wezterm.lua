-- Pull in wezterm API
local wezterm = require("wezterm")

-- Hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font("Liga SFMono Nerd Font")
config.font_size = 14
config.line_height = 1.05

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.color_scheme = "Tokyo Night"

-- config.window_background_opacity = 0.8
-- config.macos_window_background_blur = 10

return config
