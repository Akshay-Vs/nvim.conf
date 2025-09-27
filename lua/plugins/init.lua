local plugins = {}

-- Recursive function to load all Lua files under a path
local function load_plugins(path)
    for _, file in ipairs(vim.fn.glob(path .. "/*.lua", true, true)) do
        -- Convert file path to Lua require path
        local name = file:match(".*/lua/(.*).lua$")
        name = name:gsub("/", ".")
        local ok, spec = pcall(require, name)
        if ok and spec then
            if type(spec) == "table" then
                if spec[1] or spec.url then
                    table.insert(plugins, spec)
                else
                    -- if the file returns a list of plugins
                    vim.list_extend(plugins, spec)
                end
            end
        end
    end

    -- Recurse into subdirectories
    for _, dir in ipairs(vim.fn.glob(path .. "/*", 1, 1)) do
        if vim.fn.isdirectory(dir) == 1 then
            load_plugins(dir)
        end
    end
end

-- Load all plugins under 'lua/plugins', excluding init.lua itself
load_plugins(vim.fn.stdpath("config") .. "/lua/plugins")

-- Add your "core" plugins that were in init.lua
vim.list_extend(plugins, {{
    "folke/lazy.nvim",
    version = "*"
}, {
    "LazyVim/LazyVim",
    priority = 10000,
    lazy = false,
    opts = {
        colorscheme = "catppuccin"
    },
    cond = true,
    version = "*"
}, {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {},
    config = function(_, opts)
        local notify = vim.notify
        require("snacks").setup(opts)
        if LazyVim.has("noice.nvim") then
            vim.notify = notify
        end
    end
}})

return plugins
