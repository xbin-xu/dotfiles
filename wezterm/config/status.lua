local wezterm = require("wezterm")
local nerdfonts = wezterm.nerdfonts

local SOLID_LEFT_ARROW = nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = nerdfonts.ple_right_half_circle_thick
local SOLID_SCREEN_FULL = nerdfonts.oct_screen_full
local DEFAULT_COLOR_SCHEME = "OneHalfDark"
local SCHEME = wezterm.get_builtin_color_schemes()[DEFAULT_COLOR_SCHEME]

local function window_mode(window)
  if window:leader_is_active() then
    return nerdfonts.seti_shell
  end

  local key_table = window:active_key_table()
  if key_table == "show_launcher" then
    return nerdfonts.cod_server_process
  elseif key_table == "resize" then
    return nerdfonts.md_resize
  elseif key_table == "copy_mode" then
    return nerdfonts.cod_copy
  elseif key_table == "tab" then
    return nerdfonts.cod_window
  elseif key_table == "search_mode" then
    return nerdfonts.oct_search
  end

  return nerdfonts.fa_terminal
end

local function tab_title(tabinfo, max_width)
  local title = tabinfo.tab_title
  if not title or #title <= 0 then
    title = string.gsub(
      tabinfo.active_pane.foreground_process_name,
      "(.*[/\\])(.*)",
      "%2"
    )
  end
  if not title or #title <= 0 then
    title = tabinfo.active_pane.title
  end

  local left_str = tabinfo.tab_index .. ":"
  local right_str = (
    tabinfo.active_pane.is_zoomed and (" " .. SOLID_SCREEN_FULL .. " ") or ""
  )
  local available_width = math.max(max_width - #left_str - #right_str, 0)

  title = title:gsub("%.exe", "")
  title = wezterm.truncate_right(title, available_width)
  return left_str .. title .. right_str
end

wezterm.on("update-status", function(window, _)
  local icon = window_mode(window)
  window:set_left_status(wezterm.format({
    { Text = " " },
    { Text = icon .. " " },
    { Text = wezterm.mux.get_active_workspace() .. " " },
  }))

  local name = window:active_key_table()
  window:set_right_status(name or "")
end)

wezterm.on("format-tab-title", function(tab, _, _, config, hover, max_width)
  local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
    or SCHEME

  local bg, fg
  if tab.is_active then
    bg, fg = scheme.selection_bg, scheme.selection_fg
  elseif hover then
    bg, fg = scheme.cursor_bg, scheme.cursor_fg
  else
    bg, fg = scheme.background, scheme.foreground
  end

  return wezterm.format({
    { Background = { Color = scheme.background } },
    { Foreground = { Color = bg } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = tab_title(tab, max_width) },
    { Background = { Color = scheme.background } },
    { Foreground = { Color = bg } },
    { Text = SOLID_RIGHT_ARROW },
  })
end)

return {}
