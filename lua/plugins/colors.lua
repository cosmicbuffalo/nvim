local enable_extra_themes = false
return {
  -- Color schemes
  {
    -- current primary theme. has decent colors but kinda too blue. I like the highlight groups and the built in dimming of inactive though
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      light_style = "day",
      dim_inactive = true,
      -- hide_inactive_statusline=true,
      lualine_bold = true,
    },
    init = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- highlight jump points on f/F/t/T
  {
		"jinh0/eyeliner.nvim",
		keys= {
			"f", "F", "t", "T",
			{ "<leader>uf", "<cmd>ToggleFTHighlighting<cr>", desc = "Toggle f/t highlight" }
		},
		opts = {
			enabled_by_default = true,
			highlight_on_key = true,
			primary_highlight_color = "white",
			secondary_highlight_color = "red",
			disabled_buftypes = { "nofile" },
			disabled_filetypes = { "NerdTree", "NvimTree", "NeoTree", "neo-tree" },
		},
		config = function(_, opts)
			local eyeliner = require("eyeliner")
			eyeliner.setup(opts)

			if not opts.enabled_by_default then
				eyeliner.disable() -- disabled by default
			end

			vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = opts.primary_highlight_color, bold = true, underline = true })
			vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = opts.secondary_highlight_color, underline = true })

      local eyeliner_enabled = require("eyeliner.main")["enabled?"]
      vim.api.nvim_create_user_command("ToggleFTHighlighting", function()
        if eyeliner_enabled() then
          eyeliner.disable()
          vim.notify("Disabled f/t higlighting (eyeliner.nvim)")
        else
          eyeliner.enable()
          vim.notify("Enabled f/t highlighting (eyeliner.nvim)")
        end
      end, { desc = "Toggle f/t highlighting" })

		end,
	},
}
