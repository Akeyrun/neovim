local lspconfig = {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  },
  config = function()
    local lspconfig = require("lspconfig")
    -- NOTE: This tsserver example of LSP setup keeps calling system LSPs
    -- In case you want to use same LSP as other installed editors.
    -- lspconfig.tsserver.setup({})
    -- lspconfig.clangd.setup({})

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = 1 })
    end, { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = -1 })
    end, { desc = "Next diagnostic" })
    -- vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist)
    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local map = function(mode, lh, rh, desc)
          vim.keymap.set(mode, lh, rh, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- HACK: Use <C-t> to jump back to the preceding Tag.
        map("n", "gd", vim.lsp.buf.definition, "[G]o to [D]definition")
        map("n", "gD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
        map("n", "K", vim.lsp.buf.hover, "[S]how hover [I]nformations")
        map("n", "gi", vim.lsp.buf.implementation, "[G]o to [I]mplementation")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "[S]how signature help")
        map("n", "<Leader>rn", vim.lsp.buf.rename, "[R]ename in current buffer")
        map({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("n", "gr", function()
          require("telescope.builtin").lsp_references({
            show_line = false,
          })
        end, "[G]o to [R]eferences")
        map(
          "n",
          "<Leader>td",
          require("telescope.builtin").lsp_type_definitions,
          "[G]o to type definitions"
        )
        map("n", "<Leader>ds", require("telescope.builtin").lsp_document_symbols, "Document symbols")
        map("n", "<Leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]how [W]orkspace symbols")
        map("n", "<Leader>ic", require("telescope.builtin").lsp_incoming_calls, "Incoming [C]alls")
        map("n", "<Leader>oc", require("telescope.builtin").lsp_outgoing_calls, "Outgoing [C]alls")

        map("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace floder")
        map("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace floder")
        map("n", "<Leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folder")

        map("n", "<Leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, "Format Buffer")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("n", "<leader>ih", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oggle Inlay [H]ints")
        end
      end, -- of LspAttach callback
    })     -- end of nvim_create_autocmd

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration either in the following tables,
    --  or in mason-lspconfig handlers callback keys
    local servers = {
      -- INFO: For each servers keys, available sub-keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

      -- lua_ls = {
      --   -- cmd = {...},
      --   -- filetypes = { ...},
      --   -- capabilities = {},
      --   -- settings = {},
      -- },

      clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs

      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      -- But for many setups, the LSP (`tsserver`) will work just fine
      -- tsserver = {},

      tailwindcss = {},
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --  You can press `g?` for help in this menu.
    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format Lua code
      "lua_ls",
      "tsserver",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            -- cmd = {...},
            -- filetypes = { ...},
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace",
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
              },
            },
          })
        end,
        ["tsserver"] = function()
          lspconfig.ts_ls.setup({
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = 'all',
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                }
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = 'all',
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                }
              }
            }
          })
        end,
        ["tailwindcss"] = function()
          lspconfig.tailwindcss.setup({
            settings = {
              tailwindCSS = {
                classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
                includeLanguages = {
                  eelixir = "html-eex",
                  eruby = "erb",
                  htmlangular = "html",
                  templ = "html"
                },
                lint = {
                  cssConflict = "warning"
                },
              }
            }
          })
        end,
        ["bashls"] = function()
          lspconfig.bashls.setup({
            filetypes = { "shellscript", "sh", "inc", "bash", "command", "zsh" }
          })
        end
      },
    })
  end,
}

return lspconfig
