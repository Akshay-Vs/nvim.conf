return {{
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    event = "InsertEnter",
    dependencies = {{
        "rafamadriz/friendly-snippets",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    }},
    opts = {
        -- This tells LuaSnip to remember to keep around the last snippet
        history = true,

        -- This one is cool cause if you have dynamic snippets, it updates as you type!
        updateevents = "TextChanged,TextChangedI",

        -- Autosnippets
        enable_autosnippets = true,

        -- Delete check
        delete_check_events = "TextChanged"
    },

    config = function(_, opts)
        local luasnip = require("luasnip")
        local types = require("luasnip.util.types")

        -- Configure LuaSnip
        luasnip.config.set_config(vim.tbl_extend("force", opts, {
            -- Crazy highlights!!
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = {{"choiceNode", "Comment"}}
                    }
                }
            }
        }))

        -- Load snippets from VSCode-style extensions (handled by dependency config)

        -- Load custom snippets
        require("luasnip.loaders.from_lua").load({
            paths = "~/.config/nvim/lua/snippets/"
        })

        -- Custom snippet creation helpers
        local s = luasnip.snippet
        local sn = luasnip.snippet_node
        local t = luasnip.text_node
        local i = luasnip.insert_node
        local f = luasnip.function_node
        local c = luasnip.choice_node
        local d = luasnip.dynamic_node
        local fmt = require("luasnip.extras.fmt").fmt

        -- Custom snippets for different languages
        luasnip.add_snippets("lua",
            {s("req", fmt("local {} = require(\"{}\")", {i(1, "module"), i(2, "module")})), s("func", fmt([[
          local function {}({})
            {}
          end
        ]], {i(1, "name"), i(2), i(3, "-- body")})), s("if", fmt([[
          if {} then
            {}
          end
        ]], {i(1, "condition"), i(2)})), s("for", fmt([[
          for {} in {} do
            {}
          end
        ]], {i(1, "k, v"), i(2, "pairs(table)"), i(3)})), s("fori", fmt([[
          for {} = {}, {} do
            {}
          end
        ]], {i(1, "i"), i(2, "1"), i(3, "10"), i(4)}))})

        luasnip.add_snippets("javascript", {s("cl", fmt("console.log({})", {i(1)})), s("fn", fmt([[
          function {}({}) {{
            {}
          }}
        ]], {i(1, "name"), i(2), i(3)})), s("af", fmt([[
          const {} = ({}) => {{
            {}
          }}
        ]], {i(1, "name"), i(2), i(3)})),

                                            s("imp", fmt("import {} from '{}'", {c(1, {sn(nil, fmt("{{ {} }}", {i(1)})),
                                                                                       i(nil, "module")}),
                                                                                 i(2, "module")})),

                                            s("exp", fmt("export {} from '{}'", {c(1, {sn(nil, fmt("{{ {} }}", {i(1)})),
                                                                                       i(nil, "default")}),
                                                                                 i(2, "module")})), s("try", fmt([[
          try {{
            {}
          }} catch ({}) {{
            {}
          }}
        ]], {i(1), i(2, "error"), i(3, "console.error(error)")}))})

        luasnip.add_snippets("typescript", {s("int", fmt([[
          interface {} {{
            {}
          }}
        ]], {i(1, "Name"), i(2)})), s("type", fmt("type {} = {}", {i(1, "Name"), i(2)})), s("enum", fmt([[
          enum {} {{
            {}
          }}
        ]], {i(1, "Name"), i(2)})), s("class", fmt([[
          class {} {{
            constructor({}) {{
              {}
            }}

            {}
          }}
        ]], {i(1, "Name"), i(2), i(3), i(4)}))})

        luasnip.add_snippets("python", {s("def", fmt([[
          def {}({}):
              {}
        ]], {i(1, "function_name"), i(2), i(3, "pass")})), s("class", fmt([[
          class {}:
              def __init__(self{}):
                  {}
        ]], {i(1, "ClassName"), i(2), i(3, "pass")})), s("if", fmt([[
          if {}:
              {}
        ]], {i(1, "condition"), i(2)})), s("for", fmt([[
          for {} in {}:
              {}
        ]], {i(1, "item"), i(2, "iterable"), i(3)})), s("with", fmt([[
          with {} as {}:
              {}
        ]], {i(1, "open('file.txt')"), i(2, "f"), i(3)})), s("try", fmt([[
          try:
              {}
          except {} as {}:
              {}
        ]], {i(1), i(2, "Exception"), i(3, "e"), i(4, "pass")}))})

        luasnip.add_snippets("go", {s("fn", fmt([[
          func {}({}) {} {{
            {}
          }}
        ]], {i(1, "name"), i(2), i(3, "error"), i(4)})), s("if", fmt([[
          if {} {{
            {}
          }}
        ]], {i(1, "condition"), i(2)})), s("struct", fmt([[
          type {} struct {{
            {}
          }}
        ]], {i(1, "Name"), i(2)})), s("method", fmt([[
          func ({} {}) {}({}) {} {{
            {}
          }}
        ]], {i(1, "receiver"), i(2, "Type"), i(3, "method"), i(4), i(5, "error"), i(6)})), s("interface", fmt([[
          type {} interface {{
            {}
          }}
        ]], {i(1, "Name"), i(2)}))})

        luasnip.add_snippets("rust", {s("fn", fmt([[
          fn {}({}) {} {{
              {}
          }}
        ]], {i(1, "name"), i(2), c(3, {t(""), sn(nil, fmt("-> {} ", {i(1, "ReturnType")}))}), i(4)})),

                                      s("struct", fmt([[
          struct {} {{
              {}
          }}
        ]], {i(1, "Name"), i(2)})), s("impl", fmt([[
          impl {} {{
              {}
          }}
        ]], {i(1, "Type"), i(2)})), s("match", fmt([[
          match {} {{
              {} => {{}},
              _ => {{}},
          }}
        ]], {i(1, "value"), i(2, "pattern")})), s("enum", fmt([[
          enum {} {{
              {},
          }}
        ]], {i(1, "Name"), i(2)}))})

        luasnip.add_snippets("html", {s("html5", fmt([[
          <!DOCTYPE html>
          <html lang="en">
          <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>{}</title>
          </head>
          <body>
              {}
          </body>
          </html>
        ]], {i(1, "Document"), i(2)})), s("div", fmt('<div{}>\n    {}\n</div>', {c(1, {t(""),
                                                                                       sn(nil,
            fmt(' class="{}"', {i(1)})), sn(nil, fmt(' id="{}"', {i(1)}))}), i(2)})),

                                      s("link", fmt('<link rel="stylesheet" href="{}">', {i(1, "style.css")})),
                                      s("script", fmt('<script src="{}"></script>', {i(1, "script.js")}))})

        luasnip.add_snippets("css", {s("flex", fmt([[
          display: flex;
          justify-content: {};
          align-items: {};
        ]], {c(1, {t("center"), t("flex-start"), t("flex-end"), t("space-between"), t("space-around")}),
             c(2, {t("center"), t("flex-start"), t("flex-end"), t("stretch")})})), s("grid", fmt([[
          display: grid;
          grid-template-columns: {};
          gap: {};
        ]], {i(1, "repeat(auto-fit, minmax(200px, 1fr))"), i(2, "1rem")})), s("media", fmt([[
          @media (max-width: {}) {{
              {}
          }}
        ]], {i(1, "768px"), i(2)}))})

        -- Auto snippets (expand automatically without tab)
        luasnip.add_snippets("all", {s({
            trig = "date",
            name = "Date",
            dscr = "Date in the form of YYYY-MM-DD"
        }, {f(function()
            return os.date("%Y-%m-%d")
        end)}), s({
            trig = "time",
            name = "Time",
            dscr = "Current time"
        }, {f(function()
            return os.date("%H:%M:%S")
        end)}), s({
            trig = "datetime",
            name = "DateTime",
            dscr = "Date and time"
        }, {f(function()
            return os.date("%Y-%m-%d %H:%M:%S")
        end)})}, {
            key = "all"
        })

        -- Choice node examples
        luasnip.add_snippets("javascript", {s("log", fmt("console.{}({})", {c(1, {t("log"), t("warn"), t("error"),
                                                                                  t("info"), t("debug")}), i(2)}))})

        -- Function node example for automatic filename
        luasnip.add_snippets("all", {s("filename", {f(function()
            return vim.fn.expand("%:t:r")
        end)}), s("filepath", {f(function()
            return vim.fn.expand("%:p")
        end)})})

        -- Dynamic node example
        luasnip.add_snippets("lua", {s("tbl", {t("local "), i(1, "tbl"), t(" = {"), d(2, function(args)
            local nodes = {}
            local tbl_name = args[1][1] or "tbl"
            table.insert(nodes, t({"", "  -- " .. tbl_name .. " contents"}))
            table.insert(nodes, t({"", "  "}))
            table.insert(nodes, i(1))
            return sn(nil, nodes)
        end, {1}), t({"", "}"})})})
    end,

    keys = {{
        "<C-l>",
        function()
            local luasnip = require("luasnip")
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            end
        end,
        mode = {"i", "s"},
        silent = true,
        desc = "Expand or jump snippet forward"
    }, {
        "<C-h>",
        function()
            local luasnip = require("luasnip")
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end,
        mode = {"i", "s"},
        silent = true,
        desc = "Jump snippet backward"
    }, {
        "<C-k>",
        function()
            local luasnip = require("luasnip")
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            end
        end,
        mode = {"i", "s"},
        silent = true,
        desc = "Cycle through choice nodes"
    }}
}}
