-- Stage 4: file navigation. Two complementary tools —
--   neo-tree : persistent sidebar tree (your NERDTree replacement)
--   oil      : edit the filesystem as a normal buffer (rename/create/delete
--              with vim motions, then :w). Very idiomatic modern nvim.
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<C-n>",     "<cmd>Neotree toggle<cr>",       desc = "Toggle file tree" },
      { "<leader>n", "<cmd>Neotree reveal<cr>",       desc = "Reveal current file in tree" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },  -- highlight the open buffer
        hijack_netrw_behavior = "disabled",         -- let oil own directory buffers
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,  -- so it can hijack netrw when you open a directory
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent dir (oil)" },
    },
    opts = {
      view_options = { show_hidden = true },
    },
  },
}
