if vim.loader then
  vim.loader.enable()
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- vscode
if vim.g.vscode then
  -- VSCode Neovim
  require "user.vscode"
end
