--- Transparency + colorscheme configuration
local M = { opacity = 0.85 }

-- Theme registry: colorscheme-name pattern -> { module_name, opts_builder }
local themes = {
  ["^one"] = {
    "onedarkpro",
    function(s)
      return { options = { transparency = s } }
    end,
  },
  ["^tokyonight"] = {
    "tokyonight",
    function(s)
      return { transparent = s }
    end,
  },
  ["^catppuccin"] = {
    "catppuccin",
    function(s)
      return { transparent_background = s }
    end,
  },
}

-- stylua: ignore
local hl_groups = {
  "Normal", "NormalNC", "NormalFloat", "LineNr", "LineNrNC",
  "SignColumn", "SignColumnNC", "NonText", "StatusLine",
  "StatusLineNC", "TabLine", "TabLineFill", "WinSeparator",
  "VertSplit", "FloatBorder", "FoldColumn", "Folded", "FoldedNC",
  "WinBar", "WinBarNC", "Question",
  "NeoTreeNormalNC", "TelescopeNormal", "TelescopeBorder",
  "NvimTreeNormalNC", "ToggleTerm", "DapUIFloatBorder",
  "BufferCurrent", "BufferCurrentTarget", "BlinkCmpDocBorder",
  "BlinkCmpMenuBorder", "BlinkCmpSignatureHelpBorder",
}

local function find_theme(name)
  for pattern, entry in pairs(themes) do
    if name:match(pattern) then
      return entry
    end
  end
end

local function setup_theme(name, state)
  local entry = find_theme(name)
  if not entry then
    return
  end
  local ok, mod = pcall(require, entry[1])
  if ok then
    mod.setup(entry[2](state))
  end
end

local function apply_neovide(state)
  if not vim.g.neovide then
    return
  end
  local v = state and M.opacity or 1.0
  vim.g.neovide_opacity = v
  vim.g.neovide_normal_opacity = v
end

local group = vim.api.nvim_create_augroup("lazyvim_color_scheme_transparency", { clear = true })
-- Plugin themes: configure before colorscheme loads
vim.api.nvim_create_autocmd("ColorSchemePre", {
  group = group,
  callback = function(args)
    if vim.g.neovide then
      return
    end
    setup_theme(args.match, vim.g.transparency)
  end,
})

-- Built-in themes: clear backgrounds after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    if not vim.g.transparency or vim.g.neovide then
      return
    end
    if find_theme(vim.g.colors_name) then
      return
    end
    -- clear backgrounds
    for _, hl in ipairs(hl_groups) do
      vim.api.nvim_set_hl(0, hl, { bg = nil })
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  once = true,
  callback = function()
    Snacks.toggle({
      name = "Transparency",
      get = function()
        return vim.g.transparency
      end,
      set = function(state)
        vim.g.transparency = state
        if vim.g.neovide then
          apply_neovide(state)
        elseif vim.g.colors_name then
          vim.cmd("colorscheme " .. vim.g.colors_name)
        end
      end,
    }):map("<leader>uo")
  end,
})

return {
  -- Add colorscheme
  {
    "olimorris/onedarkpro.nvim",
    -- "folke/tokyonight.nvim",
    -- "catppuccin/nvim",

    -- Ensure it loads first
    priority = 1000,
    init = function()
      apply_neovide(vim.g.transparency)
    end,
  },

  -- Configure LazyVim to load colorsheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- opts: onedark, tokyonight, catppuccin, ...
      colorscheme = "onedark",
    },
  },
}
