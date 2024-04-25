return {
  -- quick navigation betweeen files
  {
    "ThePrimeagen/harpoon",
    enabled = true,
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
}
