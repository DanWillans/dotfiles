-- Neovim config — built incrementally, mirrors the essentials of ~/.vimrc.
-- Leader must be set before lazy.nvim loads so plugin mappings pick it up.
vim.g.mapleader = ","
vim.g.maplocalleader = "_"

-- Options {
local opt = vim.opt
opt.number = true               -- absolute number on the current line
opt.relativenumber = true       -- relative offsets elsewhere, so `8j`/`5k` are one glance away
opt.signcolumn = "yes"          -- always show gutter (diagnostics/git signs) — no text shift
opt.mouse = "a"                 -- mouse in all modes
opt.clipboard = "unnamedplus"   -- use system clipboard
opt.ignorecase = true           -- case-insensitive search...
opt.smartcase = true            -- ...unless an uppercase char is present
opt.incsearch = true
opt.hlsearch = true
opt.cursorline = true
opt.splitright = true           -- vsplits open to the right
opt.splitbelow = true           -- splits open below
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.wrap = false
opt.scrolloff = 8               -- keep 8 lines of context above/below cursor (also evens out <C-u>/<C-d>)
opt.termguicolors = true        -- 24-bit colour (needed by modern themes)
opt.undofile = true             -- persistent undo (nvim manages its own dir)
opt.list = true
opt.listchars = { tab = "▸ ", trail = "•", extends = ">", precedes = "<", nbsp = "." }
-- }

-- Key mappings (non-plugin) {
local map = vim.keymap.set
map("n", "<leader>/", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })
-- <C-h/j/k/l> window nav is handled by vim-tmux-navigator (see plugins/tmux.lua),
-- so it crosses seamlessly into tmux panes at a split edge.
-- Move by display line on wrapped lines, but only without a count — so 10j
-- still jumps 10 real lines (matters for relative-number motions).
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
-- }

-- Bootstrap lazy.nvim plugin manager {
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins live in lua/plugins/*.lua; empty for now, we add them per stage.
require("lazy").setup("plugins")
-- }
