return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    -- vim.g.codeium_enabled = false;
    vim.api.nvim_call_function("codeium#GetStatusString", {})

    -- DEFAULT KEY MAPPING
    -- Clear current suggestion     codeium#Clear()               <C-]>
    -- Next suggestion              codeium#CycleCompletions(1)   <M-]>
    -- Previous suggestion          codeium#CycleCompletions(-1)  <M-[>
    -- Insert suggestion            codeium#Accept()              <Tab>
    -- Manually trigger suggestion  codeium#Complete()            <M-Bslash>
    -- Accept word from suggestion  codeium#AcceptNextWord()      <C-k> WARN: used in Digraph
    -- Accept line from suggestion  codeium#AcceptNextLine()      <C-l> WARN: used in nvim-cmp

    vim.keymap.set('i', '<C-X>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<M-]>', function() return vim.fn['codeium#CycleOrComplete']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<M-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<C-G>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })

    vim.keymap.set('i', '<M-,>', function() return vim.fn['codeium#AcceptNextWord']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<M-;>', function() return vim.fn['codeium#AcceptNextLine']() end, { expr = true, silent = true })
  end,
}
