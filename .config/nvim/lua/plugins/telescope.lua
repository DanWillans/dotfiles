-- Stage 3: Telescope — fuzzy-find files, grep, buffers, symbols, and more.
-- Beats CtrlP: it searches file *contents* (live-grep via ripgrep), not just names.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native C sorter — noticeably faster/better ranking. Built with `make`.
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      -- Mirrors your CtrlP muscle memory: <leader>f = files, <leader>b = buffers.
      { "<leader>f", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>b", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>",    desc = "Recent files" },
      -- Grep lives under <leader>s (search) so <leader>g is free for git.
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",   desc = "Live grep (repo)" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",  desc = "Search help" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",    desc = "Search keymaps" },
      { "<leader>sr", "<cmd>Telescope resume<cr>",     desc = "Resume last picker" },
      -- Live-preview themes: scroll the list and the whole editor recolours.
      { "<leader>st", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end, desc = "Themes (live preview)" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({})
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
