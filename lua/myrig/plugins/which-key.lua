local plugin = {      -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'

  config = function() -- This is the function that runs, AFTER loading
    -- require('which-key').setup()
    local wk = require("which-key")
    wk.setup({
      triggers = {
        { "<Leader>", mode = { "n", "v" } },
        -- { "<auto>", mode = "nixsotc" },
        -- { "<auto>", mode = "nixsoc" },
      },
      preset = "modern",
      -- ---@param ctx { mode: string, operator: string }
      -- defer = function(ctx)
      --   print(ctx)
      --   if vim.list_contains({ "d", "y", "c" }, ctx.operator) then
      --     return true
      --   end
      --   return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
      -- end,
      show_keys = true,
    })
    wk.add({
      -- [1]: (string) lhs (required)
      -- [2]: (string|fun()) rhs (optional): when present, it will create the mapping
      -- desc: (string|fun():string) description (required for non-groups)
      -- group: (string|fun():string) group name (optional)
      -- mode: (string|string[]) mode (optional, defaults to "n")
      -- cond: (boolean|fun():boolean) condition to enable the mapping (optional)
      -- hidden: (boolean) hide the mapping (optional)
      -- icon: (string|wk.Icon|fun():(wk.Icon|string)) icon spec (optional)
      -- proxy: (string) proxy to another mapping (optional)
      -- expand: (fun():wk.Spec) nested mappings (optional)
      -- any other option valid for vim.keymap.set. These are only used for creating mappings.

      -- { "<leader>f", group = "Fuzzy [f]inder" }, -- group
      -- { '<C-w>', group = "[W]indows" },
      -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
      -- { "<leader>fb", function() print"hello") end,   desc = "Foobar" },
      -- { "<leader>fn", desc = "New File", hidden = true },
      -- { "<leader>f1", hidden = true },                      -- hide this keymap
      -- { "<leader>w", proxy = "<c-w>",         group = "windows" }, -- proxy to window mappings
      {
        "<leader>b",
        group = "[B]uffers",
        expand = function()
          return require("which-key/extras").expand.buf()
        end
      },
      {
        -- Nested mappings are allowed and can be added in any order
        -- Most attributes can be inherited or overridden on any level
        -- There's no limit to the depth of nesting
        -- mode = { "n", "v" },                          -- NORMAL and VISUAL mode
        -- { "<leader>q", "<cmd>q<cr>", desc = "Quit window" }, -- no need to specify mode since it's inherited
        -- { "<leader>w", "<cmd>w<cr>", desc = "Write Buffer" },
      }
    })

    -- Document existing key chains
    -- require('which-key').add {
    --   { '<leader>c', group = '[C]ode' },
    --   { '<leader>d', group = '[D]ocument' },
    --   { '<leader>r', group = '[R]ename' },
    --   { '<leader>s', group = '[S]earch' },
    --   { '<leader>w', group = '[W]orkspace' },
    --   { '<leader>t', group = '[T]oggle' },
    --   { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    -- }
  end,

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

return plugin
