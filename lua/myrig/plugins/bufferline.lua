return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true
    vim.opt.mousemoveevent = true;

    require("bufferline").setup({
      options = {
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' }
        },
        middle_mouse_command = "sbuffer %d",
        right_mouse_command = "vertical sbuffer %d",
        numbers = function(opts)
          return string.format('%s·%s', opts.ordinal, opts.id)
        end,

      },
    })

    vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
    vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
    vim.keymap.set("n", "<Leader>bh", "<Cmd>BufferLineMovePrev<CR>",
      { desc = "Move Buffer Backward", silent = true, noremap = true, })
    vim.keymap.set("n", "<Leader>bl", "<Cmd>BufferLineMoveNext<CR>",
      { desc = "Move Buffer Forward", silent = true, noremap = true, })
    vim.keymap.set("n", "<Leader>bb", "<Cmd>BufferLinePick<CR>",
      { desc = "Previous Buffer", silent = true, noremap = true, })
    vim.keymap.set("n", "<Leader>bc", "<Cmd>BufferLinePickClose<CR>",
      { desc = "Previous Buffer", silent = true, noremap = true, })
  end,
}
