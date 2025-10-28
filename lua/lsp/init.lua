-- lua/lsp/init.lua
-- Modern Neovim LSP Configuration
local M = {}

-- LSP Settings
M.setup = function()
    -- Diagnostic configuration
    vim.diagnostic.config({
        virtual_text = {
            spacing = 2,
            prefix = "●"
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = ""
        }
    })

    -- LSP handlers configuration
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded"
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded"
    })

    -- Custom signs
    local signs = {{
        name = "DiagnosticSignError",
        text = ""
    }, {
        name = "DiagnosticSignWarn",
        text = ""
    }, {
        name = "DiagnosticSignHint",
        text = "󰌵"
    }, {
        name = "DiagnosticSignInfo",
        text = ""
    }}

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            texthl = sign.name,
            text = sign.text,
            numhl = ""
        })
    end
end

-- LSP Keymaps
M.on_attach = function(client, bufnr)
    local opts = {
        buffer = bufnr,
        silent = true
    }
    
    -- Workspace
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    -- Highlight references
    if client.server_capabilities.documentHighlightProvider then
        local group = vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false
        })
        vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references
        })
    end
end