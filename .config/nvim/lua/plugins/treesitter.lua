-- Stage 5: Treesitter — syntax-aware highlighting + indentation.
-- Uses the `main` branch (the supported one for Neovim 0.11+). The old `master`
-- branch is frozen and crashes on 0.12's list-per-capture query API when parsing
-- injections (e.g. markdown code-fences in LSP hover popups).
--
-- main-branch differences vs master: no `configs.setup{}` module — you install
-- parsers explicitly and start highlighting yourself per buffer.
local PARSERS = {
  "lua", "vim", "vimdoc", "query",
  "python", "rust", "c", "cpp",
  "bash", "json", "yaml", "toml",
  "markdown", "markdown_inline", "gitcommit", "diff",
}

-- Incremental selection: the main branch dropped the incremental_selection
-- module, so this reimplements it on the core vim.treesitter API. A per-buffer
-- stack of visited nodes lets <BS> shrink back exactly along the grow path.
-- TSNodes go stale when the buffer changes, so the stack is only trusted while
-- the buffer's changedtick matches the one recorded when it was built.
local sel_stack = {} -- bufnr -> { tick = changedtick, nodes = { TSNode, ... } }

local function get_stack(buf)
  local s = sel_stack[buf]
  if s and s.tick == vim.b[buf].changedtick then return s.nodes end
end

local function select_node(node)
  local sr, sc, er, ec = node:range() -- 0-based, end col exclusive
  if sr == er and sc == ec then return end -- zero-width, e.g. root of empty buffer
  if ec == 0 then
    -- node ends at col 0 of the line below: clamp to the end of the last line
    er = er - 1
    ec = #vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1]
  end
  vim.api.nvim_buf_set_mark(0, "<", sr + 1, sc, {})
  vim.api.nvim_buf_set_mark(0, ">", er + 1, math.max(ec - 1, 0), {})
  vim.cmd("normal! gv")
  if vim.api.nvim_get_mode().mode ~= "v" then
    vim.cmd("normal! v") -- gv restores the last visual *mode* too; force charwise
  end
end

local function same_range(a, b)
  local ar = { a:range() }
  local br = { b:range() }
  return ar[1] == br[1] and ar[2] == br[2] and ar[3] == br[3] and ar[4] == br[4]
end

local function init_selection()
  -- parse first: get_node() returns nil on a not-yet-parsed buffer
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok or not parser then return end
  parser:parse(true)
  local node = vim.treesitter.get_node()
  if not node then return end
  local buf = vim.api.nvim_get_current_buf()
  sel_stack[buf] = { tick = vim.b[buf].changedtick, nodes = { node } }
  select_node(node)
end

local function grow_selection()
  local nodes = get_stack(vim.api.nvim_get_current_buf())
  local top = nodes and nodes[#nodes]
  if not top then -- no fresh stack (manual `v`, or buffer edited): start over
    return init_selection()
  end
  local parent = top:parent()
  while parent and same_range(parent, top) do -- skip wrappers with identical extent
    parent = parent:parent()
  end
  if parent then
    nodes[#nodes + 1] = parent
    top = parent
  end
  select_node(top)
end

local function shrink_selection()
  local nodes = get_stack(vim.api.nvim_get_current_buf())
  if not nodes or #nodes == 0 then return end
  if #nodes > 1 then
    nodes[#nodes] = nil
  end
  select_node(nodes[#nodes])
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(PARSERS)

      -- Start highlighting + treesitter indentation when a buffer's filetype is
      -- set (only if its parser is installed — pcall guards the first-run race
      -- while a parser is still downloading).
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TSHighlight", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            local opts = { buffer = ev.buf, desc = "TS incremental selection" }
            vim.keymap.set("n", "<C-space>", init_selection, opts)
            vim.keymap.set("x", "<C-space>", grow_selection, opts)
            vim.keymap.set("x", "<BS>", shrink_selection,
              { buffer = ev.buf, desc = "TS shrink selection" })
          end
        end,
      })
    end,
  },
}
