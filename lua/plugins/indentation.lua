return {
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    -- event = "LazyFile",
    version = "v3.5.4",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        -- char = "▏",
        -- tab_char = "▏",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    -- config = function()
    --   local highlight = { "DarkIndent" }
    --   local hooks = require("ibl.hooks")
    --   hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    --     vim.api.nvim_set_hl(0, "DarkIndent", { fg = "#282828" })
    --   end)
    --   require("ibl").setup({
    --     indent = { highlight = highlight },
    --     scope = { enabled = false }
    --   })
    -- end,
  },
  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    -- event = "LazyFile",
    opts = {
      -- symbol = "▏",
      -- symbol = '╎',
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- easy column alignment
  {
    { "echasnovski/mini.align", version = "*", config = true },
  },
}
