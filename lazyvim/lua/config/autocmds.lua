-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Auto close while quit as last buffer
-- vim.api.nvim_create_autocmd({ "QuitPre" }, {
--   group = augroup("quit_pre"),
--   callback = function()
--     vim.cmd("CMakeCloseRunner")
--   end,
-- })

-- Highlight current line, but only in active window
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = augroup("cursor_line_in_active_window"),
  callback = function()
    vim.opt.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = augroup("cursor_line_in_unactive_window"),
  callback = function()
    vim.opt.cursorline = false
  end,
})

-- "o" and "O" will not continue comment, but "<CR>" will
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup("continue_comment"),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - "o" + "r"
  end,
})

-- disable spell check in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_spell_check"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.spelllang = "en_us,cjk"
  end,
})

-- clean shada
-- see: https://github.com/neovim/neovim/issues/8587
if vim.fn.has("win32") == 1 then
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = augroup("clean_shada_temp"),
    callback = function()
      for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath("data") .. "/shada", "*tmp*", false, true)) do
        vim.fn.delete(f)
      end
    end,
    desc = "Delete temp ShaDa files",
  })
end

-- clnagd: switch C/C++ source/header
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("lsp_clangd_switch_source_header"),
  pattern = { "c", "cpp" },
  callback = function()
    vim.keymap.set("n", "<M-o>", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header" })
  end,
})

-- Relaod project-specific .lazy.lua on DirChanged
vim.api.nvim_create_autocmd("DirChanged", {
  group = augroup("reload_lazy_lua"),
  callback = function()
    local data = vim.secure.read(vim.fn.fnamemodify(".lazy.lua", ":p"))
    if type(data) == "string" then
      load(data, ".lazy.lua")()
    end
  end,
})

-- Clean Claude Code prompt scratch
local function is_claude_prompt(path)
  return path ~= nil and path:lower():find("claude%-prompt%-[%w%-]+%.md$") ~= nil
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = augroup("claude_prompt_scratch"),
  pattern = "*claude-prompt-*.md",
  callback = function(args)
    vim.bo[args.buf].swapfile = false
  end,
  desc = "No swap files for Claude prompt scratch files",
})

vim.api.nvim_create_autocmd("User", {
  group = augroup("clean_session_pollution"),
  pattern = "PersistenceSavePre",
  callback = function()
    -- Drop prompt scratch files from the argument list. Handles the case
    -- where the buffer was already :bdelete'd but its arg entry remains.
    pcall(vim.cmd.argdelete, "*claude-prompt-*")
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if is_claude_prompt(name) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
    local ok, paths = pcall(vim.json.decode, vim.g.BufferlinePositions or "")
    if ok and type(paths) == "table" then
      local filtered = vim.tbl_filter(function(p)
        return not is_claude_prompt(p)
      end, paths)
      if #filtered ~= #paths then
        vim.g.BufferlinePositions = vim.json.encode(filtered)
      end
    end
  end,
  desc = "Drop Claude prompt scratch files before saving sessions",
})
