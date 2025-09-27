return { -- Mason core
{
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = {{
        "<leader>cm",
        "<cmd>Mason<cr>",
        desc = "Mason"
    }},
    build = ":MasonUpdate",
    opts_extend = {"ensure_installed"},
    opts = {
        ui = {
            border = "rounded",
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        },
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        pip = {
            upgrade_pip = false,
            install_args = {}
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 4,
        github = {
            download_url_template = "https://github.com/%s/releases/download/%s/%s"
        },
        ensure_installed = { -- Formatters
        "stylua", -- Lua formatter
        "prettier", -- JS/TS/JSON/CSS/HTML formatter
        "black", -- Python formatter
        "isort", -- Python import sorter
        "rustfmt", -- Rust formatter
        "gofumpt", -- Go formatter
        "clang-format", -- C/C++ formatter
        "shfmt", -- Shell script formatter
        -- Linters
        "eslint_d", -- JS/TS linter
        "pylint", -- Python linter
        "shellcheck", -- Shell script linter
        "hadolint", -- Dockerfile linter
        -- Debug Adapters
        "node-debug2-adapter", "debugpy"}
    },
    config = function(_, opts)
        require("mason").setup(opts)
        local mr = require("mason-registry")

        mr:on("package:install:success", function()
            vim.defer_fn(function()
                -- trigger FileType event to possibly load this newly installed LSP server
                require("lazy.core.handler.event").trigger({
                    event = "FileType",
                    buf = vim.api.nvim_get_current_buf()
                })
            end, 100)
        end)

        mr.refresh(function()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end)
    end
}, -- Mason LSP config
{
    "mason-org/mason-lspconfig.nvim",
    dependencies = {"mason.nvim"},
    config = function()
        -- This will be handled by the main lspconfig setup
    end
}}
