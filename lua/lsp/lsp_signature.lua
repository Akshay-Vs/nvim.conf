return {
  -- Enhanced signature help with lsp_signature
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     bind = true, -- This is mandatory, otherwise border config won't work
  --     handler_opts = {
  --       border = "rounded"
  --     },
  --     -- Floating window configuration
  --     floating_window = true,
  --     floating_window_above_cur_line = true,
  --     floating_window_off_x = 1,
  --     floating_window_off_y = 0,
      
  --     -- Hint configuration
  --     hint_enable = true,
  --     hint_prefix = "🐼 ",
  --     hint_scheme = "String",
  --     hint_inline = function() return false end,
      
  --     -- Additional features
  --     hi_parameter = "LspSignatureActiveParameter",
  --     always_trigger = false,
  --     auto_close_after = nil,
  --     extra_trigger_chars = {},
      
  --     -- Toggle key (optional)
  --     toggle_key = "<C-k>",
  --     select_signature_key = "<M-n>",
      
  --     -- Transparency
  --     transparency = nil,
      
  --     -- Timer settings
  --     timer_interval = 200,
  --     toggle_key_flip_floatwin_setting = false,
      
  --     -- Documentation
  --     doc_lines = 10,
  --     max_height = 12,
  --     max_width = 80,
  --     wrap = true,
      
  --     -- Padding
  --     padding = ' ',
      
  --     -- Shadow
  --     shadow_blend = 36,
  --     shadow_guibg = 'Black',
      
  --     -- Noice integration (if you use noice.nvim)
  --     noice = false,
  --   },
  --   config = function(_, opts)
  --     require('lsp_signature').setup(opts)
  --   end
  -- },

  -- Buit-in LSP config enhancement for signature help
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Enhance existing LSP config with better signature help triggers
      local original_on_attach = opts.on_attach
      opts.on_attach = function(client, bufnr)
        if original_on_attach then
          original_on_attach(client, bufnr)
        end

        -- Enable signature help automatically
        if client.server_capabilities.signatureHelpProvider then
          -- Trigger signature help on specific characters
          vim.api.nvim_create_autocmd("CursorHoldI", {
            buffer = bufnr,
            callback = function()
              local params = vim.lsp.util.make_position_params()
              local line = vim.api.nvim_get_current_line()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              
              -- Check if we're inside function arguments
              local before_cursor = line:sub(1, col)
              if before_cursor:match("[%(%,]%s*$") then
                vim.lsp.buf.signature_help()
              end
            end,
          })
        end
      end
      
      return opts
    end,
  },
}