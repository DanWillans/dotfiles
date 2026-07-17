-- Stage 2: look & feel + keymap discoverability.
return {
  -- Colorscheme. tokyonight is a modern, well-maintained theme with good
  -- treesitter/LSP highlight support (onehalfdark predates both).
  {
    "folke/tokyonight.nvim",
    lazy = false,      -- load during startup
    priority = 1000,   -- ...before other plugins, so the theme is set first
    config = function()
      require("tokyonight").setup({ style = "storm" })
      vim.cmd.colorscheme("onedark")
    end,
  },

  -- Statusline (replaces vim-airline). Pure-lua, no powerline font needed.
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = { theme = "auto", globalstatus = true },  -- statusline follows the active colorscheme
    },
  },

  -- which-key: press a prefix (e.g. <leader>) and a popup lists what follows.
  -- Turns your own config into something discoverable — great while learning.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
