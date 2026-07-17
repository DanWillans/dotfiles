-- Stage 6: LSP — real language intelligence (go-to-def, references, hover,
-- rename, diagnostics, format). Mason installs the servers; mason-lspconfig
-- auto-enables them via Neovim's built-in vim.lsp; keymaps attach per-buffer.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Tell every server which completion capabilities the client supports.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- lua_ls: recognise the `vim` global so editing this config is warning-free.
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- rust_analyzer: as-you-type squiggles for unresolved names/methods
      -- (E0425/E0599-class); off by default upstream. Borrow-check errors
      -- still arrive via cargo check on save.
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = { diagnostics = { experimental = { enable = true } } },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "ruff",
          "rust_analyzer", "bashls", "jsonls", "taplo", "yamlls",
        },
      })

      -- We prefer the classic mnemonic scheme (gd/gr/gi) over Neovim 0.12's
      -- gr* defaults. Delete the gr*-prefix defaults so a plain `gr` fires
      -- instantly instead of waiting `timeoutlen` for a longer match.
      for _, k in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
        pcall(vim.keymap.del, "n", k)
      end
      pcall(vim.keymap.del, "x", "gra")

      -- Buffer-local maps, set once a server attaches. Navigation goes through
      -- Telescope (floating picker + preview) rather than the quickfix list.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local tb = require("telescope.builtin")
          local function m(modes, keys, fn, desc)
            vim.keymap.set(modes, keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          m("n", "gd", tb.lsp_definitions,      "Definition")
          m("n", "gr", tb.lsp_references,       "References")
          m("n", "gi", tb.lsp_implementations,  "Implementation")
          m("n", "gD", vim.lsp.buf.declaration, "Declaration")
          m("n", "<leader>D",  vim.lsp.buf.type_definition, "Type definition")
          -- rename/code-action under <leader>c (code); <leader>r is taken by
          -- recent-files, so <leader>cr avoids re-introducing prefix lag.
          m("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          m({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          -- One-key whole-buffer format (gq needs a motion; this is friendlier).
          m("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          -- K (hover), <C-]> (def), [d/]d (diagnostics) stay default.
        end,
      })

      -- Format on save. Synchronous (default) so the file written to disk is
      -- the formatted one. Skipped if no attached client can format the buffer,
      -- or if toggled off. :FormatToggle for the session, :FormatToggle! for
      -- just the current buffer.
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
        callback = function(ev)
          if vim.g.disable_autoformat or vim.b[ev.buf].disable_autoformat then return end
          for _, c in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
            if c:supports_method("textDocument/formatting") then
              vim.lsp.buf.format({ bufnr = ev.buf, timeout_ms = 3000 })
              return
            end
          end
        end,
      })
      vim.api.nvim_create_user_command("FormatToggle", function(a)
        if a.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
        vim.notify("Format-on-save " .. ((vim.g.disable_autoformat or vim.b.disable_autoformat) and "OFF" or "ON"))
      end, { bang = true, desc = "Toggle format-on-save (! = current buffer)" })

      -- Full diagnostic message + source in a popup. <C-W>d is the built-in
      -- equivalent; <leader>e is the easier-to-reach, which-key-discoverable one.
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

      vim.diagnostic.config({
        virtual_text = { source = "if_many", spacing = 2 },  -- inline message at EOL
        signs = true,          -- gutter icons (needs signcolumn, set in init.lua)
        underline = true,      -- squiggle under the offending text
        update_in_insert = true,  -- show diagnostics while typing, VSCode-style
        severity_sort = true,  -- errors drawn over warnings
        float = { border = "rounded", source = true },
      })
    end,
  },
}
