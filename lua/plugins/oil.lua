return {
  {
    "cosmicbuffalo/oil-git-status.nvim",
    event = "VimEnter",
    opts = {
      symbols = {
        index = {
          ["!"] = "󱈸",
          ["?"] = "",
          ["A"] = "✚",
          -- ["C"] = "C", -- not sure what this one means
          ["D"] = "✖",
          ["M"] = "󰋠",
          ["R"] = "󰁕",
          -- ["T"] = "T", -- not sure what this one means
          ["U"] = "",
          [" "] = " ",
        },
        working_tree = {
          ["!"] = "󱈸",
          ["?"] = "",
          ["A"] = "✚",
          -- ["C"] = "C", -- not sure what this one means
          ["D"] = "✖",
          ["M"] = "󰄱",
          ["R"] = "󰁕",
          -- ["T"] = "T", -- not sure what this one means
          ["U"] = "",
          [" "] = " ",
        },
        -- icons from neo-tree
        -- Change type
        -- added = "✚",
        -- modified = "",
        -- deleted = "✖",
        -- renamed = "󰁕",
        -- -- Status type
        -- untracked = "",
        -- ignored = "",
        -- unstaged = "󰄱",
        -- staged = "",
        -- conflict = "",
      },
    },
    dependencies = {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      tag = "v2.10.0",
      event = "VimEnter",
      config = function()
        require("oil").setup({
          -- columns = { "icon" },
          keymaps = {
            -- navigating within oil
            ["-"] = { "actions.parent", desc = "Open parent directory" },
            ["<BS>"] = { "actions.parent", desc = "Open parent directory" },
            ["_"] = { "actions.open_cwd", desc = "Open CWD" },
            -- ["q"] = { "actions.close", desc = "Close" },

            -- closing oil
            ["<leader>o"] = { "actions.close", desc = "Close" },
            ["<C-c>"] = { "actions.close", desc = "Close" },
            ["<esc><esc>"] = { "actions.close", desc = "Close" },

            -- opening files with oil
            ["<cr>"] = { "actions.select", opts = { close = true }, desc = "Open" },
            ["<leader>-"] = {
              "actions.select",
              opts = { horizontal = true },
              desc = "Open in horizontal split",
            },
            ["<leader>|"] = {
              "actions.select",
              opts = { vertical = true },
              desc = "Open in vertical split",
            },

            -- oily things
            ["<leader>p"] = { "actions.preview", desc = "Open/Close Preview" },
            ["<leader>r"] = { "actions.refresh", desc = "refresh current directory" },
            ["<leader>y"] = { "actions.yank_entry", desc = "Yank path" },
          },
          delete_to_trash = true,
          use_default_keymaps = false,
          view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
              return name == ".."
            end,
          },
          win_options = {
            signcolumn = "yes:2",
          },
        })
      end,
      keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      },
    },
    config = true,
  },
}
