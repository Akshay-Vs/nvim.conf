--vim_options.lua
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.markdown_recommended_style = 0

vim.diagnostic.config({
	virtual_text = true,
})

vim.opt.foldmethod = "marker"

-- Disable LazyVim's automatic plugin ordering
vim.g.lazyvim_check_order = false

vim.opt.foldenable = false

-- Lua configuration for Neovim
vim.api.nvim_set_hl(0, "CmpGhostText", {
	fg = "#585b70",
	bg = "NONE",
	italic = true,
})

-- Enable format on save for all LSP-enabled buffers
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})