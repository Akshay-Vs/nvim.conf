return {{
    "akshay-vs/monorepo.nvim",
    dependencies = {"nvim-telescope/telescope.nvim", "nvim-neo-tree/neo-tree.nvim"},
    config = function()
        require("monorepo").setup({
            root_dir = vim.fn.getcwd(), -- Root directory to search
            exclude_dirs = {"node_modules", ".git", "dist", "build", "__pycache__", ".next", "coverage", ".nx", ".next",
                            ".dist"},
            project_types = {
                nodejs = {
                    emoji = "",
                    config_file = "package.json",
                    name_pattern = '"name"%s*:%s*"([^"]+)"'
                },
                python = {
                    emoji = "",
                    config_file = "pyproject.toml",
                    name_pattern = 'name%s*=%s*"([^"]+)"'
                },
                rust = {
                    emoji = "",
                    config_file = "Cargo.toml",
                    name_pattern = 'name%s*=%s*"([^"]+)"'
                },
                go = {
                    emoji = "󰟓",
                    config_file = "go.mod",
                    name_pattern = 'module%s+([^%s\n]+)'
                }
            }
        })
    end
}}
