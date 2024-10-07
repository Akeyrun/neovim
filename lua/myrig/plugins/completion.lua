return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",   -- source for text in the buffer
    "hrsh7th/cmp-path",     -- source for file system path
    "onsails/lspkind.nvim", -- vs-code like pictograms

    "L3MON4D3/luasnip",
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    -- luasnip.config.setup({})

    -- set up nvim-cmp
    cmp.setup({
      snippet = {
        -- required - you must specify a snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body) -- for `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      completion = {
        completeopt = "menu,menuone,popup,noselect",
      },

      -- HACK: Please read `:help ins-completion`, it is really good!

      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        -- Scroll the documentation window [b]ack / [f]orward
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ["<C-Space>"] = cmp.mapping.complete({}),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
        ["<C-s>"] = cmp.mapping(function()
          if luasnip.choice_active() then
            luasnip.change_choice(1)
            -- require("luasnip.next_choice")()
          end
        end, { "i", "s", desc = "Change snippet choice", silent = true }) -- FIX: Not sure keymap options fit there,

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        -- HACK:  https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      }),

      -- source for autocompletion
      sources = cmp.config.sources({
        {
          name = "lazydev",
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "nvim_px_to_rem" },
        { name = "luasnip" }, -- for luasnip users.
        { name = "buffer" },  -- text whithin a current buffer
        { name = "path" },    -- file system paths
      }),
      -- configure lspkind for vscode like pictograms in completion menu
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = require("lspkind").cmp_format({
          mode = "symbol", -- show only symbol annotations
          maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = "...",    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labeldetails = true, -- show labeldetails in menu. disabled by default

          -- the function below will be called before any actual modifications from lspkind
          -- so that you can provide more controls on popup customization. (see [#30](https://github.com/onsails/lspkind-nvim/pull/30))
          --[[ before = function(entry, vim_item)
            return vim_item
          end, ]]
          before = require("tailwind-tools.cmp").lspkind_format,
        }),
      },
    })
  end,
}
