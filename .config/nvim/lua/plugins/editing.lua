-- Stage 7b: editing polish. (Commenting is built into Neovim 0.10+: gcc for a
-- line, gc<motion>, and gc in visual mode — no plugin needed.)
return {
  -- Surround with tpope-compatible bindings: ys<motion><char> add,
  -- cs<old><new> change, ds<char> delete. Matches your vim-surround habits.
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto-insert matching brackets/quotes.
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {},
  },

  -- Richer text objects: adds `a` (argument) and `f` (function call) on top of
  -- the builtins, so e.g. `cia` changes an argument, `daf` deletes a call.
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = {},
  },
}
