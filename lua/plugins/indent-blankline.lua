return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
    config = function()
      local highlight = { "DarkIndent" }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "DarkIndent", { fg = "#282828" })
      end)
      require("ibl").setup({
        indent = { highlight = highlight },
        scope = { enabled = false }
      })
    end,
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      -- symbol = "▏"
    }
    -- enabled = false,
  }
}
