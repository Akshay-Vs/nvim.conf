return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
	config = function()
		-- Configure icon for .proto files
		require("nvim-web-devicons").set_icon({
			proto = {
				icon = "",
		  color = "#FBBC05",
		  cterm_color = "113",
		  name = "Proto",
	  },
  })

  require("neo-tree").setup({
	  close_if_last_window = true,
	  popup_border_style = "rounded",
	  enable_git_status = true,
	  enable_diagnostics = true,
	  window = {
		  position = "right",
		  width = 30,
	  },
	  filesystem = {
		  follow_current_file = true,
		  filtered_items = {
			  hide_dotfiles = false,
			  hide_gitignored = false,
			  hide_by_name = {
				  "package-lock.json",
				  "yarn.lock",
				  "pnpm-lock.yaml",
				  ".venv",
				  "__pycache__",
				  ".pytest_cache",
				  ".git",
			  },
		  },
	  },
  })
  vim.keymap.set("n", "<C-b>", ":Neotree toggle right<CR>", {})
  vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
  vim.keymap.set("n", "<leader>b", "<cmd>Neotree focus<cr>", {
	  desc = "Focus Neo-tree",
  })  end,
}
