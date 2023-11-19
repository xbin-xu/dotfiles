local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    require("plugins.colorscheme"),
    require("plugins.util"),
    require("plugins.ui"),
    require("plugins.coding"),
    require("plugins.git"),
    require("plugins.telescope"),
    require("plugins.treesitter"),
    require("plugins.cmp"),
    require("plugins.mason"),
    require("plugins.lsp"),
    require("plugins.dap"),
    require("plugins.lang"),
    require("plugins.which-key"),
    require("plugins.toggleterm"),
})
