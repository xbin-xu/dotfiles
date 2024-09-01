return {
  {
    "Civitasv/cmake-tools.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    keys = {
      { "<leader>Ck", "<cmd>CMakeSelectKit<cr>", desc = "Select kit" },
      { "<leader>Cv", "<cmd>CMakeSelectBuildType<cr>", desc = "Select build type" },
      -- NOTE: default is native build system generate
      -- NOTE: to specify a build system generate by `CMakeGenerate -G MinGW\ Makefiles`
      { "<leader>Cg", "<cmd>CMakeGenerate -G Ninja<cr>", desc = "Generate" },
      { "<leader>CB", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select Build Target" },
      { "<leader>Cb", "<cmd>CMakeBuild<cr>", desc = "Build Target" },
      { "<leader>Ci", "<cmd>CMakeInstall<cr>", desc = "Install" },
      { "<leader>Cd", "<cmd>CMakeDebug<cr>", desc = "Debug Target" },
      { "<leader>CR", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select launch target" },
      { "<leader>Cr", "<cmd>CMakeRun<cr>", desc = "Run Target" },
      { "<leader>Cc", "<cmd>CMakeClean<cr>", desc = "Clean" },
      { "<leader>Cs", "<cmd>CMakeStop<cr>", desc = "Stop" },
      { "<leader>Co", "<cmd>CMakeOpen<cr>", desc = "Open" },
      { "<leader>CC", "<cmd>CMakeClose<cr>", desc = "Close" },
    },
    opts = {},
  },

  -- which-key
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>C", group = "+cmake" }, 
      },
    },
  },
}
