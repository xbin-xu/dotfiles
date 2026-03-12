local M = {}
local wezterm = require("wezterm")

function M.apply_to_config(config)
	-- Color Scheme
	config.color_scheme = "OneHalfDark"
	-- config.color_scheme = "tokyonight-storm"

	-- Window
	config.window_decorations = "RESIZE"
	config.window_background_opacity = 1.0
	config.window_close_confirmation = "NeverPrompt"
	config.adjust_window_size_when_changing_font_size = false
	config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

	-- Tab Bar
	config.enable_tab_bar = true
	config.tab_bar_at_bottom = true
	config.use_fancy_tab_bar = false
	config.show_new_tab_button_in_tab_bar = true

	-- Fonts
	config.font_size = 12
	config.font = wezterm.font("JetBrainsMono Nerd Font")

	-- Cursor Style: Steady/Blinking, Block/Underline/Bar
	config.default_cursor_style = "BlinkingBar"
	config.animation_fps = 1
	config.cursor_blink_ease_in = "Constant"
	config.cursor_blink_ease_out = "Constant"

	-- Scroll
	config.scrollback_lines = 10000

	-- Pane
	config.inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.9,
	}
end

return M
