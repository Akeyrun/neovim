-- INFO: Enter the command :options to open an interactive window to setup vim options for the duration of a session.
-- WARNING: Root for vim.opt API, because vim.o API lacks some critical options

-- 2 MOVING AROUND, SEARCHING AND PATTERNS

-- Ignore case when using a search pattern. Improve command line completion to indiscriminately search for vim builtins commands (lowercase) and plugins commands (uppercase)
vim.opt.ignorecase = true

-- 4 DISPLAYING TEXT

vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 5

vim.opt.list = true
vim.opt.listchars = { tab = '▷ ', trail = '·', nbsp = '␣' }

-- 5 SYNTAX, HIGHLIGHTING AND SPELLING

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
-- Use GUI colors for the terminal
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- BUG:01 Intent to fix broken linewise comments in C
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function ()
--     if vim.opt.background == "dark" then
--       vim.api.nvim_set_hl(0, "Cursor", {
--         guifg = "NONE", guibg = "#FFFFFF", ctermfg = "NONE", ctermbg = 15
--       })
--     else
--       vim.api.nvim_set_hl(0, "Cursor", {
--         guifg = "NONE", guibg = "#000000", ctermfg = "NONE", ctermbg = 0
--       })
--     end
--   end
-- })

-- 6 MULTIPLE WINDOWS

vim.opt.splitbelow = true
vim.opt.splitright = true

-- 10 MESSAGES AND INFO

vim.opt.showmode = false

-- 11 SELECTING TEXT

-- Synchronizes the system clipboard with Neovim's clipboard
-- vim.opt.clipboard = "unnamedplus"

-- 13 TABS AND INDENTING

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- 24 VARIOUS

vim.opt.virtualedit = "block" -- Cursor can be positioned where there is no actual character.
-- shows the effects of |:substitute| and user commands with the |:command-preview| flag as you type.
vim.opt.inccommand = "split"
vim.opt.signcolumn = "yes" -- whether to show signcolumn.
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- LSP window border on hover
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  -- Add a border to the hover window
  border = "rounded",
})
