return {
  -- targeted jumping
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "neiotsrahdcmglpufbjywxzq",
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "gh", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "gH", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  -- jump through edit history across buffers
  {
    "bloznelis/before.nvim",
    lazy = false,
    opts = {
      history_size = 30,
      telescope_for_preview = true,
    },
    keys = {
      -- Jump to previous entry in the edit history
      {
        "<M-o>",
        function()
          require("before").jump_to_last_edit()
        end,
        desc = "Go to previous edit",
      },

      -- Jump to next entry in the edit history
      {
        "<M-i>",
        function()
          require("before").jump_to_next_edit()
        end,
        desc = "Go to next edit",
      },

      -- Show last 30 edits in telescope
      {
        "<leader>se",
        function()
          require("before").show_edits()
        end,
        desc = "Open edit list",
      },
    },
  },
  -- quick navigation betweeen files
  {
    "ThePrimeagen/harpoon",
    enabled = false,
    lazy = false,
    config = function(_, opts)
      require("harpoon").setup(opts)
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      local km = vim.keymap
      km.set("n", "<leader>'", mark.add_file, { desc = "Add file to harpoon" })
      km.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Quick Menu" })
      km.set("n", "<M-l>", function()
        ui.nav_file(1)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })

      km.set("n", "<M-u>", function()
        ui.nav_file(2)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })

      km.set("n", "<M-y>", function()
        ui.nav_file(3)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })

      km.set("n", "<M-'>", function()
        ui.nav_file(4)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })
    end,
  },
  -- enhanced word movement
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "<M-w>",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-w",
      },
      {
        "<M-b>",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-b",
      },
      {
        "<M-e>",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-e",
      },
      {
        "g<M-e>",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-ge",
      },
    },
  },
  {
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		keys = {
			{ "<Leader>nt", "<cmd>Neotree toggle<CR>", desc = "Neotree toggle" },
			{ "<Leader>nf", "<cmd>Neotree reveal<CR>", desc = "Neotree focus file" },
		},
		opts = {
			sources = { "filesystem", "buffers", "git_status", "document_symbols" },
			open_files_do_not_replace_types = { "terminal", "qf", "Outline" },
			filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_hidden = false,
					hide_dotfiles = false,
				},
			},
			window = {
				mappings = {
					["<space>"] = "none",
					["Y"] = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					["S"] = "split_with_window_picker",
					["s"] = "vsplit_with_window_picker",
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},
	}
}
