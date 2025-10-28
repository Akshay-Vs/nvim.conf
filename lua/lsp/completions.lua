return { -- Main completion engine
{
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = { -- LSP completion source
    "hrsh7th/cmp-nvim-lsp", -- Additional completion sources,
       "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", -- Snippet completion
    "saadparwaiz1/cmp_luasnip", -- Optional: Icons
    "onsails/lspkind.nvim", -- Optional: Git completion
    "petertriho/cmp-git"},
    opts = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- Helper function for tab completion
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        return {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                    side_padding = 0
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None"
                })
            },

            mapping = cmp.mapping.preset.insert({
                -- Scroll documentation
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),

                -- Trigger completion
                ["<C-Space>"] = cmp.mapping.complete(),

                -- Close completion
                ["<C-e>"] = cmp.mapping.abort(),

                -- Confirm completion
                ["<CR>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() and cmp.get_active_entry() then
                            cmp.confirm({
                                behavior = cmp.ConfirmBehavior.Replace,
                                select = false
                            })
                        else
                            fallback()
                        end
                    end,
                    s = cmp.mapping.confirm({
                        select = true
                    }),
                    c = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    })
                }),

                -- Tab completion with snippet support
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, {"i", "s"}),

                -- Shift-Tab for previous item
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, {"i", "s"}),

                -- Navigate through completion items
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item()
            }),

            sources = cmp.config.sources({{
                name = "supermaven",
                priority = 1250
            }, {
                name = "nvim_lsp",
                priority = 1000
            }, {
                name = "luasnip",
                priority = 750
            }, {
                name = "buffer",
                priority = 500
            }, {
                name = "path",
                priority = 250
            }}),

            formatting = {
                fields = {"kind", "abbr", "menu"},
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    show_labelDetails = true,
                    symbol_map = {
                        Text = "󰉿",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = ""
                    },
                    before = function(entry, vim_item)
                        -- Source indicator
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                            git = "[Git]"
                        })[entry.source.name]
                        return vim_item
                    end
                })
            },

            experimental = {
                ghost_text = {
                    hl_group = "CmpGhostText"
                }
            },

            -- Performance settings
            performance = {
                debounce = 60,
                throttle = 30,
                fetching_timeout = 500,
                confirm_resolve_timeout = 80,
                async_budget = 1,
                max_view_entries = 200
            }
        }
    end,

    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup(opts)

        -- Git commit completion
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({{
                name = "git"
            }}, {{
                name = "buffer"
            }})
        })

        -- Command line completion for search
        cmp.setup.cmdline({"/", "?"}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{
                name = "buffer"
            }}
        })

        -- -- Command line completion for commands
        -- cmp.setup.cmdline(":", {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = cmp.config.sources({{
        --         name = "path"
        --     }}, {{
        --         name = "cmdline",
        --         option = {
        --             ignore_cmds = {"Man", "!"}
        --         }
        --     }})
        -- })

        -- Auto-pairs integration
        local cmp_autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
        if cmp_autopairs_ok then
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end
}, -- Git completion source
{
    "petertriho/cmp-git",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {}
}, -- Auto pairs
{
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
}}
