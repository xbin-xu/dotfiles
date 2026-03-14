local M = {}
local wezterm = require("wezterm")
local act = wezterm.action
local default_keys = wezterm.gui.default_key_tables()

local function get_key_id(item)
  return item.key .. (item.mods or "NONE")
end

local function tbl_extend(src, tbl)
  local ret = src

  if tbl then
    local map = {}
    for k, v in pairs(src) do
      map[get_key_id(v)] = k
    end

    for _, v in pairs(tbl) do
      local id = get_key_id(v)
      if map[id] then
        ret[map[id]] = v
      else
        table.insert(ret, v)
      end
    end
  end

  return ret
end

local function move_pane(direction)
  return wezterm.action_callback(function(window, pane)
    local panes_info = pane:tab():panes_with_info()
    local pane_id = pane:pane_id()
    local is_zoomed = false

    for _, paneinfo in ipairs(panes_info) do
      if paneinfo.pane:pane_id() == pane_id then
        is_zoomed = paneinfo.is_zoomed
        break
      end
    end

    window:perform_action(act.ActivatePaneDirection(direction), pane)
    if is_zoomed then
      window:perform_action(act.TogglePaneZoomState, pane)
    end
  end)
end

local function adjust_opacity(windown, delta, warp)
  local overrides = windown:get_config_overrides() or {}
  local config = windown:effective_config()

  local opacity = config.window_background_opacity + delta
  opacity = warp and (opacity - math.floor(opacity))
    or math.min(math.max(opacity, 0), 1)
  overrides.window_background_opacity = opacity
  windown:set_config_overrides(overrides)
end

local leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local key_tables = {
  copy_mode = tbl_extend(default_keys.copy_mode, {
    -- Move
    { key = "H", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    {
      key = "L",
      mods = "NONE",
      action = act.CopyMode("MoveToEndOfLineContent"),
    },
    -- Select
    {
      key = "v",
      mods = "SHIFT",
      action = act({
        Multiple = {
          act.CopyMode("MoveToStartOfLineContent"),
          act.CopyMode({ SetSelectionMode = "Cell" }),
          act.CopyMode("MoveToEndOfLineContent"),
        },
      }),
    },
    -- Copy
    {
      key = "y",
      mods = "SHIFT",
      action = act({
        Multiple = {
          act.CopyMode({ SetSelectionMode = "Cell" }),
          act.CopyMode("MoveToEndOfLineContent"),
          act({ CopyTo = "ClipboardAndPrimarySelection" }),
          act.CopyMode("Close"),
        },
      }),
    },
    -- Search
    {
      key = "/",
      mods = "NONE",
      action = act.CopyMode("EditPattern"),
      -- action = act.Search("CurrentSelectionOrEmptyString"),
    },
    {
      key = "n",
      mods = "NONE",
      action = act.Multiple({
        act.CopyMode("NextMatch"),
        act.CopyMode("ClearSelectionMode"),
      }),
    },
    {
      key = "N",
      mods = "NONE",
      action = act.Multiple({
        act.CopyMode("PriorMatch"),
        act.CopyMode("ClearSelectionMode"),
      }),
    },
    {
      key = "n",
      mods = "CTRL",
      action = act.Multiple({
        act.CopyMode("NextMatch"),
        act.CopyMode("ClearSelectionMode"),
      }),
    },
    {
      key = "p",
      mods = "CTRL",
      action = act.Multiple({
        act.CopyMode("PriorMatch"),
        act.CopyMode("ClearSelectionMode"),
      }),
    },
    -- Close
    {
      key = "Escape",
      mods = "NONE",
      action = act.Multiple({
        act.ClearSelection,
        act.CopyMode("ClearPattern"),
        act.CopyMode("Close"),
      }),
    },
  }),
  search_mode = tbl_extend(default_keys.search_mode, {
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
    { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
    { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
    { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
    {
      key = "Enter",
      mods = "NONE",
      action = act.Multiple({
        act.CopyMode("ClearSelectionMode"),
        act.ActivateCopyMode,
      }),
    },
  }),
  resize = {
    { key = "0", action = act.ResetFontSize },
    { key = "-", action = act.DecreaseFontSize },
    { key = "=", action = act.IncreaseFontSize },
    { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
    {
      key = "o",
      action = wezterm.action_callback(function(window, _)
        adjust_opacity(window, -0.1, false)
      end),
    },
    {
      key = "O",
      action = wezterm.action_callback(function(window, _)
        adjust_opacity(window, 0.1, false)
      end),
    },
    { key = "Escape", action = "PopKeyTable" },
  },
}

local keys = {
  -- Press LEADER twice to send to the terminal
  {
    key = leader.key,
    mods = "LEADER" .. "|" .. leader.mods,
    action = act.SendKey({ key = leader.key, mods = leader.mods }),
  },
  { key = "l", mods = "LEADER", action = act.ShowLauncher },
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "]", mods = "LEADER", action = act.QuickSelect },
  {
    key = "/",
    mods = "LEADER",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
  {
    key = "K",
    mods = "LEADER",
    action = wezterm.action({ ClearScrollback = "ScrollbackOnly" }),
  },
  {
    key = "r",
    mods = "LEADER",
    action = act.ActivateKeyTable({
      name = "resize",
      one_shot = false,
      timeout_milliseconds = 1000,
    }),
  },
  {
    key = "u",
    mods = "LEADER",
    action = wezterm.action.QuickSelectArgs({
      label = "open url",
      patterns = {
        "\\((https?://\\S+)\\)",
        "\\[(https?://\\S+)\\]",
        "\\{(https?://\\S+)\\}",
        "<(https?://\\S+)>",
        "\\bhttps?://\\S+[)/a-zA-Z0-9-]+",
      },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening: " .. url)
        wezterm.open_with(url)
      end),
    }),
  },

  -- Command Palette
  { key = "P", mods = "CTRL", action = act.ActivateCommandPalette },

  -- Font
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },

  -- Copy/Paste
  { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
  { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  {
    key = "Insert",
    mods = "SHIFT",
    action = act.PasteFrom("PrimarySelection"),
  },
  { key = "Insert", mods = "CTRL", action = act.CopyTo("PrimarySelection") },

  -- Domain

  -- Workspace/Session
  {
    key = "w",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  {
    key = "c",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },
  {
    key = "<",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine({
      description = "Rname workspace name:",
      action = wezterm.action_callback(function(_, _, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },

  -- Tab
  {
    key = "t",
    mods = "LEADER",
    action = act.ShowTabNavigator,
  },
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Rename tab title:",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  { key = "t", mods = "CTRL", action = act.SpawnTab("DefaultDomain") },
  {
    key = "q",
    mods = "CTRL",
    action = act.CloseCurrentTab({ confirm = false }),
  },
  { key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },

  -- Pane
  { key = "p", mods = "CTRL|ALT", action = act.PaneSelect },
  {
    key = "s",
    mods = "CTRL|ALT",
    action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
  },
  {
    key = "\\",
    mods = "CTRL|ALT",
    action = act.SplitPane({ direction = "Right" }),
  },
  {
    key = "-",
    mods = "CTRL|ALT",
    action = act.SplitPane({ direction = "Down" }),
  },
  { key = "m", mods = "CTRL|ALT", action = act.TogglePaneZoomState },
  { key = "h", mods = "CTRL|ALT", action = move_pane("Left") },
  { key = "j", mods = "CTRL|ALT", action = move_pane("Down") },
  { key = "k", mods = "CTRL|ALT", action = move_pane("Up") },
  { key = "l", mods = "CTRL|ALT", action = move_pane("Right") },
}
local mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
  -- Drag
  {
    event = { Drag = { streak = 1, button = "Left" } },
    mods = "CTRL|ALT",
    action = act.StartWindowDrag,
  },
  -- Copy/Paste
  -- {
  --   event = { Up = { streak = 1, button = "Right" } },
  --   mods = "NONE",
  --   action = act.PasteFrom("Clipboard"),
  -- },
}

function M.apply_to_config(config)
  config.disable_default_key_bindings = true
  config.disable_default_mouse_bindings = false
  config.leader = leader
  config.keys = keys
  config.key_tables = key_tables
  config.mouse_bindings = mouse_bindings
end

return M
