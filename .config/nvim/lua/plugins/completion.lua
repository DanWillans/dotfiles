-- Stage 6: completion engine. blink.cmp is the modern choice — a Rust-based
-- fuzzy matcher (downloaded prebuilt), sensible defaults, fast.
return {
  {
    "saghen/blink.cmp",
    version = "*",            -- release tag → fetches the prebuilt matcher binary
    event = "InsertEnter",
    -- snippet library for the `snippets` source (LSPs like pyright emit no
    -- snippets of their own); blink picks it up from the runtimepath
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      -- 'default' preset: <C-y> accept, <C-n>/<C-p> or arrows to cycle,
      -- <C-space> open/docs, <C-e> hide. <Tab> jumps snippet fields.
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      signature = { enabled = true },   -- show function signature while typing args
    },
  },
}
