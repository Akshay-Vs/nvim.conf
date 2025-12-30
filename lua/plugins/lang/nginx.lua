-- For use with nvim-lspconfig
require("lspconfig").nginx_language_server.setup({
	cmd = { "nginx-language-server" },
	filetypes = { "nginx" },
	root_markers = { "nginx.conf", ".git" },
})
