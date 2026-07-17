-- Stage 7a: git. gitsigns for inline hunk work; fugitive for the full porcelain
-- (:Git status/commit/blame/diff) you used in your vimrc.
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function m(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = buf, desc = "Git: " .. desc })
        end
        -- Navigate hunks (]h / [h), then stage/reset/preview them inline.
        m("]h", function() gs.nav_hunk("next") end, "Next hunk")
        m("[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        m("<leader>hs", gs.stage_hunk,   "Stage hunk")
        m("<leader>hr", gs.reset_hunk,   "Reset hunk")
        m("<leader>hp", gs.preview_hunk, "Preview hunk")
        m("<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        m("<leader>hd", gs.diffthis,     "Diff this file")
      end,
    },
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gvdiffsplit", "Gwrite", "Gread", "Gedit", "Gclog" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>",          desc = "Git status" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>",  desc = "Git diff (split)" },
      { "<leader>gc", "<cmd>Git commit<cr>",   desc = "Git commit" },
      { "<leader>gb", "<cmd>Git blame<cr>",    desc = "Git blame" },
      { "<leader>gl", "<cmd>Gclog<cr>",        desc = "Git log" },
      { "<leader>gp", "<cmd>Git push<cr>",     desc = "Git push" },
      { "<leader>gw", "<cmd>Gwrite<cr>",       desc = "Git write (stage file)" },
      { "<leader>ge", "<cmd>Gedit<cr>",        desc = "Git edit" },
    },
  },
}
