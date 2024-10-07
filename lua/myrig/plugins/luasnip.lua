return {
  "L3MON4D3/luasnip",
  -- follow latest release.
  version = "v2.*", -- replace <currentmajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  dependencies = {
    "saadparwaiz1/cmp_luasnip", -- for autocompletion
    {
      "rafamadriz/friendly-snippets",
      -- config = function()
      --   -- loads vs-code style snippets from installed plugins (e.g. friendly-snippets)
      --   require("luasnip.loaders.from_vscode").lazy_load()
      -- end,
    }, -- useful snippets
  },

  config = function()
    local luasnip = require("luasnip")
    luasnip.filetype_extend("typescript", { "javascript", })
    require("luasnip.loaders.from_vscode").lazy_load()

    luasnip.config.set_config {
      history             = false,
      updateevents        = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    }

    local s   = luasnip.s
    local sn  = luasnip.snippet_node
    local isn = luasnip.indent_snippet_node
    local t   = luasnip.text_node
    local i   = luasnip.insert_node
    local f   = luasnip.function_node
    local d   = luasnip.dynamic_node
    local c   = luasnip.choice_node
    local r   = luasnip.restore_node

    local function fn(
        args,     -- text from i(2) in this example i.e. { { "456" } }
        parent,   -- parent snippet or parent node
        user_args -- user_args from opts.user_args
    )
      return '[' .. args[1][1] .. user_args .. ']'
    end

    luasnip.add_snippets("lua", {
      -- s(
      --   {
      --     trig = "trigger",
      --     name = "snippet name",
      --     desc = { "This is a description of the snippet", "To make it span multiple lines", "Separate it by \"-\" or use a table.", "" },
      --     wordTrig = true,
      --   },
      --   {
      --     -- t("Hello Snippet!")
      --     -- t({ "Hello Snippet!", "A second line!!" })
      --     t({ "After jumping forward once, cursor is here ->" }), i(2),
      --     t({ "", "After expanding, the cursor is here ->" }), i(1),
      --     -- NOTE: if you choose (0) as last jump_index, replacing its text will op it out of insertNode
      --     -- As a result it will be jumpable but no longer expandable ( still manually editable ).
      --     t({ "", "After jumping once more, the snippet is exited there ->" }), i(3),
      --   }
      -- )

      -- s("trig", {
      --   i(1), t '<-i(1) ',
      --   f(fn,                                   -- callback (args, parent, user_args) -> string
      --     { 2 },                                -- node indice(s) whose text is passed to fn, i.e. i(2)
      --     { user_args = { "user_args_value" } } -- opts
      --   ),
      --   t ' i(2)->', i(2), t '<-i(2) i(0)->', i(0)
      -- })

      -- s({ trig = "b(%d)", regTrig = true },
      --   f(function(args, snip)
      --     return
      --         "Captured Text: " .. snip.captures[1] .. "."
      --   end, {})
      -- )

      -- s("trig",
      --   -- c(1, {
      --   --   t("Ugh boring, a text node"),
      --   --   i(nil, "At least I can edit something now..."),
      --   --   f(function(args) return "Still only counts as text!!" end, {})
      --   -- })
      --
      --   c(1, {
      --     t "some 1st text",              -- textNodes are just stopped at.
      --     i(nil, "some 2nd text"),        -- likewise.
      --     -- sn(nil, { t "some broken text" })  -- this will not work!
      --     sn(nil, { i(1), t "some final choice text" }) -- this will.
      --   })
      -- )

      s("trig", sn(1, {
        t("basically just text "),
        i(1, "And an insertNode.")
      })),

      s("isn", {
        isn(1, { t({ "This is indented as deep as the trigger",
          "and this is at the beginning of the next line" }) }, "")
      }),

      s("isn2", {
        isn(1, t({ "--This is", "A multiline", "comment" }), "$PARENT_INDENT//")
      }),

      s("dyna_01", {
        t "text: ", i(1), t { "", "copy: " },
        d(2, function(args)
            -- the returned snippetNode doesn't need a position; it's inserted
            -- "inside" the dynamicNode.
            return sn(nil, {
              -- jump-indices are local to each snippetNode, so restart at 1.
              i(1, args[1])
            })
          end,
          { 1 })
      })
    })

    local function count(_, _, old_state)
      old_state = old_state or {
        updates = 0
      }

      old_state.updates = old_state.updates + 1

      local snip = sn(nil, {
        t(tostring(old_state.updates))
      })

      snip.old_state = old_state
      return snip
    end

    luasnip.add_snippets("all",
      s("trigo", { -- BUG: This  trigger never trigger
        i(1, "change to update"),
        d(2, count, { 1 })
      })
    )

    luasnip.add_snippets("all", {
      s("paren_change", {
        c(1, {
          sn(nil, { t("("), r(1, "user_text"), t(")") }),
          sn(nil, { t("["), r(1, "user_text"), t("]") }),
          sn(nil, { t("{"), r(1, "user_text"), t("}") }),
        }),
      }, {
        stored = {
          -- key passed to restoreNodes.
          ["user_text"] = i(1, "default_text")
        }
      })
    })
    

    luasnip.add_snippets("all", {
      s({
          trig = "tag",
          name = "markupTag",
          desc = {
            "Markup languages tag on XML model:",
            "<tag></tag>",
            " " },
        },
        {
          t("<"),
          i(1, "tagName"),
          t(" >"),
          i(0),
          f(function(args, parent, user_args)
            return "</" .. args[1][1] .. ">"
          end, { 1 }, { user_args = {} }),
        }),

      s({
          trig = "tagsi",
          name = "markupSelfInclosedTag",
          desc = {
            "Markup languages self inclosed tag on HTML model:",
            "<tag />",
            " " },
        },
        {
          t("<"),
          i(1, "tagName"),
          i(2),
          t(" />"),
          i(0),
        }),
    })

    luasnip.add_snippets("javascript", {
      s({
          trig = "pair",
          name = "keyValuePair",
          desc = {
            "Javascript/Typescript key-value pair.",
            " " },
        },
        {
          i(1, "pairKey"),
          t(": "),
          i(2),
          t(","),
          i(0),
        }),
    })

    luasnip.add_snippets("lua", {
      s(
        "@pa",
        {
          t("---@param "),
          i(1, "param"),
          t(" "),
          i(2, "type")
        },
        {
          [2] = {
            LuasnipInsertNodeEnter = function(node, _event_args) -- TODO: No message. Why ???
              print("Enter parameter name")
            end

            -- LuasnipInsertNodeEnter = vim.api.nvim_create_autocmd("User", {   -- TODO: Message. Why ???
            --   pattern = "LuasnipInsertNodeEnter",
            --   callback = function()
            --     local node = require("luasnip").session.event_node
            --     print(table.concat(node:get_text(), "\n"))
            --   end
            -- })
          }
        }
      ),

      -- TODO: Use choice node to pick between local function and global function
      s("f", {
        t("function "),
        i(1, "name"),
        t("("),
        i(2, "params"),
        t(")"),
        t({ "", "" }),
        t("end"),
      }),
    })

    luasnip.add_snippets("go", {
      s("ee", {
        t("if err != nil {"),
        t({ "", "" }),
        i(1, "    "),
        t({ "", "" }),
        t("}")
      }),

      s("f", {
        t("func "),
        i(1, "name"),
        t("("),
        i(2, "args"),
        t(")"),
        i(3, "return"),
        t("{"),
        t({ "", "" }),
        t "}"
      }),
    })
  end, -- of config callback
}
