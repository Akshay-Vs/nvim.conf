-- <Space> as leader key
vim.g.mapleader = " "

-- Local helper for keymaps
local map = vim.keymap.set

-- Require plugins used in keymaps
local Snacks_ok, Snacks = pcall(require, "snacks")
if not Snacks_ok then
	Snacks = nil
end
-- ================================
-- Normal Mode Mappings
-- ================================

-- Lspsaga rename
map("n", "<F2>", "<cmd>Lspsaga rename<CR>", {
	desc = "Saga Rename",
})

-- format code
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { noremap = true, silent = true })

-- Go to definition
map("n", "<leader>oc", vim.lsp.buf.definition, {
	desc = "Open Component (Go to Definition)",
})

-- Go to next error only
map("n", "<leader>]", function()
	vim.diagnostic.goto_next({
		severity = vim.diagnostic.severity.ERROR,
	})
end, {
	desc = "Next Error",
})

-- Go to previous error
map("n", "<leader>[", function()
	vim.diagnostic.goto_prev({
		severity = vim.diagnostic.severity.ERROR,
	})
end, {
	desc = "Previous Error",
})

-- Move lines (Normal)
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", {
	desc = "Move Down",
})
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", {
	desc = "Move Up",
})

-- Toggle inlay_hint
map("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- ================================
-- Insert Mode Mappings
-- ================================
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", {
	desc = "Move Down",
})
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", {
	desc = "Move Up",
})

-- ================================
-- Visual Mode Mappings
-- ================================
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", {
	desc = "Move Down",
})
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", {
	desc = "Move Up",
})

-- ================================
-- Terminal Mode Mappings
-- ================================
map("t", "<C-/>", "<cmd>close<cr>", {
	desc = "Hide Terminal",
})
map("t", "<c-_>", "<cmd>close<cr>", {
	desc = "which_key_ignore",
})

-- ================================
-- Format code
-- ================================
-- Format current buffer
map("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format code with LSP" })
