return {
  -- multi cursor
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_set_statusline = 0
      vim.g.VM_silent_exit = 1

      vim.g.vm_mouse_mappings = 1
      vim.g.VM_theme = "iceblue"
      vim.g.VM_highlight_matches = "underline"
      vim.g.VM_add_cursor_at_pos_no_mappings = 1
      vim.g.VM_maps = {
        Undo = "u",
        Redo = "<C-r>",
        -- fix VM could not map goto prev(`[`) and next(`[`)
        ["Goto Prev"] = "[v",
        ["Goto Next"] = "]v",
        -- <C-Down>/<C-Up> used for increase/decrease window height
        ["Add Cursor Down"] = "<C-M-Down>",
        ["Add Cursor Up"] = "<C-M-Up>",
      }
    end,
  },

  -- which-key: add desc for vim-visual-multi
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "\\\\", group = "visual-multi", icon = { icon = "󰗧", color = "cyan" } },
      },
    },
  },

  -- lualine: show vim-visual-multi statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_a = {
        {
          "mode",
          fmt = function(mode)
            if not vim.b.visual_multi then
              return mode
            end
            local sl = vim.fn["vm#themes#statusline"]()
            return sl:match("%S+%s+(%S+)") or mode
          end,
        },
      }
      table.insert(opts.sections.lualine_b, 1, {
        function()
          local info = vim.fn.VMInfos()
          return info.ratio .. " " .. info.status
        end,
        cond = function()
          return vim.b.visual_multi ~= nil
        end,
      })
    end,
  },
}
