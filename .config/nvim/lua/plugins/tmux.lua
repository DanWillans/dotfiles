-- Seamless <C-h/j/k/l> navigation across nvim splits AND tmux panes.
-- The tmux side (is_vim detection + C-hjkl bindings) is already in ~/.tmux.conf;
-- this is the nvim half that hands off to tmux at a split edge.
return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft", "TmuxNavigateDown",
      "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",     desc = "Nav left (split/pane)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",     desc = "Nav down (split/pane)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",       desc = "Nav up (split/pane)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>",    desc = "Nav right (split/pane)" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Nav to previous split/pane" },
    },
  },
}
