local M = {}

function M.get_first_unpinned_index()
  local state = require("bufferline.state")
  local groups = require("bufferline.groups")

  for i, item in ipairs(state.components) do
    if not groups._is_pinned(item:as_element()) then
      return i
    end
  end
  return 0
end

function M.close_other_unpinned()
  local commands = require("bufferline.commands")
  local state = require("bufferline.state")
  -- local utils = require("bufferline.utils")

  local first_unppinned_index = M.get_first_unpinned_index()
  -- utils.notify("first_unppinned_index: " .. first_unppinned_index, "info")
  if first_unppinned_index == 0 then
    return
  end
  local index = commands.get_current_element_index(state)
  -- utils.notify("get_current_element_index: " .. index, "info")
  if not index then
    return
  end

  if index >= first_unppinned_index then
    commands.move_to(first_unppinned_index)
    index = commands.get_current_element_index(state)
    commands.close_in_direction("right")
  elseif index < first_unppinned_index then
    commands.go_to(first_unppinned_index - 1, true)
    commands.close_in_direction("right")
    commands.go_to(index, true)
  end
end

return {
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "<S-h>", false },
      { "<S-l>", false },
      -- stylua: ignore
      { "<leader>bo", function() M.close_other_unpinned() end, desc = "Delete other unpinned buffers" },
      { "<leader>bO", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
    },
    opts = {
      options = {
        always_show_bufferline = true,
      },
    },
  },
}
