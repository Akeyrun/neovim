-- KEY MAPPING
-- HACK: In command mode all mapping including nvim builtins
-- are displayed with :no

vim.g.have_nerd_font = true
vim.g.codeium_disable_bindings = 1;
vim.g.codeium_manual = true;

local map = vim.keymap.set
map("n", "<Leader>nh", "<Cmd>nohls<CR>", { desc = "Highligths Off" })
-- map("t", "jk", "<C-\\><C-n>", { noremap = true })
map("t", "<Leader>kj", "<C-\\><C-n>", { noremap = true })
map("t", "<Leader>jk", "<C-\\><C-n>", { noremap = true })
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })
map("i", "jk", "<ESC>l", { noremap = true })
map("i", "kj", "<ESC>l", { noremap = true })
-- <T-…>		meta-key when it's not alt	*<T-*
-- map("i", "<T-k>", "<ESC>", { noremap = true })
--
--UPPERCASE FIRST CHARACTER
map("n", "<Leader>gu", "m`b~``")
--KEEP THINGS CENTERED
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
-- map("n", ";", ";zzzv")
map("n", "*", "*zzzv")
-- map("v", "<", "<gv")
-- MOVE VISUAL SELECTION AROUND
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
-- OPEN TERMINAL
map("n", "<leader>ts", function()
  vim.cmd("belowright 12split")
  vim.cmd("set nonu | set nornu")
  vim.cmd("set winfixheight")
  vim.cmd("term")
  vim.cmd("startinsert")
end, { desc = "New Terminal Bellowright" })
map("n", "<leader>tv", function()
  vim.cmd("vs")
  vim.cmd("set nonu | set nornu")
  vim.cmd("term")
  vim.cmd("startinsert")
end, { desc = "New Terminal Right" })
-- WINDOW COMMAND
map("n", "<C-w>c", "<Cmd>close<CR>", { desc = "Close a window" })
-- Moving around windows 				*window-moving*
map("n", "<Left>", function() vim.cmd.wincmd("h") end, { desc = "Go to Left window" })
map("n", "<Up>", function() vim.cmd.wincmd("k") end, { desc = "Go to Top window" })
map("n", "<Right>", function() vim.cmd.wincmd("l") end, { desc = "Go to Right window" })
map("n", "<Down>", function() vim.cmd.wincmd("j") end, { desc = "Go to Bottom window" })
map("n", "<C-w>W", "<Cmd>wincmd W<CR>", { desc = "Switch windows reverse" })
map("n", "<C-w>t", "<Cmd>wincmd t<CR>", { desc = "Go to top-left window" })
map("n", "<C-w>b", "<Cmd>wincmd b<CR>", { desc = "Go to bottom-right window" })
map("n", "<C-w>p", "<Cmd>wincmd p<CR>", { desc = "Go to previous window" })
-- Moving windows around 				*window-moving*
map("n", "<C-w>P", "<Cmd>wincmd P<CR>", { desc = "Go to preview window" })
map("n", "<C-w>r", "<Cmd>wincmd r<CR>", { desc = "Rotate windows forward" })
map("n", "<C-w>R", "<Cmd>wincmd R<CR>", { desc = "Rotate windows backward" })
map("n", "<C-w>K", "<Cmd>wincmd K<CR>", { desc = "Move window to very top" })
map("n", "<C-w>J", "<Cmd>wincmd J<CR>", { desc = "Move window to very bottom" })
map("n", "<C-w>H", "<Cmd>wincmd H<CR>", { desc = "Move window to far left" })
map("n", "<C-w>L", "<Cmd>wincmd L<CR>", { desc = "Move window to far right" })
-- Window resizing					*window-resize*
-- HACK: Could also resize with:
-- Normal mode: z<line_quantity_number>
-- Command mode: resize + or - number
-- Command mode: vertical resize + or - number
map("n", "<M-Down>", "<Cmd>wincmd - <CR>", { desc = "Decrease window height" })
map("n", "<M-Up>", "<Cmd>wincmd + <CR>", { desc = "Increase window height" })
map("n", "<M-Left>", "<Cmd>wincmd < <CR>", { desc = "Decrease window width" })
map("n", "<M-Right>", "<Cmd>wincmd > <CR>", { desc = "Increase window width" })
map("n", "<C-w>f", "<Cmd>wincmd _ | wincmd |<CR>", { desc = "Maximize window" })

-- TAB COMMAND
-- map("n", "<Leader>T", ":tab", { desc = "Tab command leader" })
map("n", "<Leader>te", "<Cmd>tabe<CR>", { desc = "Tab command leader" })
-- map("n", "<Leader>ts", "<Cmd>tab split<CR>", { desc = "Open current buffer in new tab page" })
map("n", "<Leader>tx", "<Cmd>tabclose<CR>", { desc = "Close current tab page" })
map("n", "<Leader>to", "<Cmd>tabonly<CR>", { desc = "Close all other tab pages" })
-- FIX: These <Tab> bindings ends breaking the jump forward <C-I>
-- map("n", "<Tab>", function() vim.cmd.tabn() end, { desc = "Go to Next Tab" })
-- map("n", "<S-Tab>", function() vim.cmd.tabN() end, { desc = "Go to Previous Tab" })
-- map("n", "<Leader><Tab>", function() vim.cmd.tabnext("#") end, { desc = "Go to Last Accessed Tab" })

map("n", "<Tab>", function() vim.cmd.bn() end, { desc = "Next Buffer" })
map("n", "<S-Tab>", function() vim.cmd.bp() end, { desc = "Previous Buffer" })
map("n", "<Leader>x", ":bd ", { desc = "Delete Buffer" })

-- Toggle text wrap on command.
vim.api.nvim_create_user_command("ToggleWrap", function()
  if vim.wo.wrap then
    vim.wo.wrap = false
  else
    vim.wo.wrap = true
  end
end, {})
map({ "n", "v" }, "<Leader>z", "<Cmd>ToggleWrap<CR>", { desc = "Toggle text wrap", noremap = true, silent = true })

-- Toggle Tab expansion on command
vim.api.nvim_create_user_command("ToggleTabExpansion", function()
  if vim.bo.et then
    vim.cmd.set("noet")
  else
    vim.cmd.set("et")
  end
  print("expandtab " .. (vim.bo.et and "true" or "false"))
end, {})
map({ "n", "v" }, "<Leader>xt", "<Cmd>ToggleTabExpansion<CR>",
  { desc = "Toggle buffer expandtab", noremap = true, silent = true })

-- Expr mapping:
-- vim.keymap.set('i', '<Tab>', function()
--   return not vim.fn.pumvisible() == 0 and "<C-n>" or "<Tab>"
-- end, { expr = true })

-- DELETE BUFFER
