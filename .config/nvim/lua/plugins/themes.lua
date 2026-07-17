-- A shelf of well-regarded themes to preview and choose from.
-- None of these call `colorscheme`, so they just register themselves and stay
-- inactive — the active theme is set in ui.lua. Preview live with <leader>st,
-- then tell me (or edit ui.lua) to make your pick permanent.
return {
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 900 }, -- mocha/macchiato/frappe/latte
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 900 },             -- warm retro
  { "rebelot/kanagawa.nvim", lazy = false, priority = 900 },                -- muted, painterly
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 900 }, -- soft, low-contrast
  { "navarasu/onedark.nvim", lazy = false, priority = 900 },                -- closest to your old onehalfdark
  { "sainnhe/everforest", lazy = false, priority = 900 },                   -- green, easy on the eyes
}
