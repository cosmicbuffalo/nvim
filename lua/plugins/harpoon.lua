return {
  {
    "ThePrimeagen/harpoon",
    enabled = true,
    lazy = false,
    config = function(_, opts)
      require("harpoon").setup(opts)
      -- harpoon
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      local km = vim.keymap
      km.set("n", "<leader>'", mark.add_file, { desc = "Add file to harpoon" })
      km.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon Quick Menu" })

      -- Can't seem to get these keybindings to work for some reason
      -- km.set("n", "<M-n>", function()
      --   ui.nav_file(1)
      -- end, { silent = true, noremap = true, desc = "which_key_ignore" })
      --
      -- km.set("n", "<M-e>", function()
      --   ui.nav_file(2)
      -- end, { silent = true, noremap = true, desc = "which_key_ignore" })
      --
      -- km.set("n", "<M-i>", function()
      --   ui.nav_file(3)
      -- end, { silent = true, noremap = true, desc = "which_key_ignore" })
      --
      -- km.set("n", "<M-o>", function()
      --   ui.nav_file(4)
      -- end, { silent = true, noremap = true, desc = "which_key_ignore" })

      -- having to live with these for the time being
      km.set("n", "<leader>1", function()
        ui.nav_file(1)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })

      km.set("n", "<leader>2", function()
        ui.nav_file(2)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })

      km.set("n", "<leader>3", function()
        ui.nav_file(3)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })

      km.set("n", "<leader>4", function()
        ui.nav_file(4)
      end, { silent = true, noremap = true, desc = "which_key_ignore" })
    end,
  },
}
