local wezterm = require("wezterm")
local config = wezterm.config_builder()

--------------------------------------------------------------------------------
-- Launching Programs
--------------------------------------------------------------------------------
-- Specifying the current working directory
config.default_cwd = "D:/workbench"
-- Spawn a fish shell in login mode
config.default_prog = { "bash", "-l" }
-- Launch Menu
config.launch_menu = {
	{ label = "bash", args = { "bash", "-l" } },
	{ label = "cmd", args = { "cmd" } },
	{ label = "powershell", args = { "powershell" } },
}

config.automatically_reload_config = false
require("config.apperance").apply_to_config(config)
require("config.status")
require("config.keymaps").apply_to_config(config)

return config
