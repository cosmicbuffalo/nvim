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
}
