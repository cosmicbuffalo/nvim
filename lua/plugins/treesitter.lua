return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy" },
    dependencies = {
      "RRethy/nvim-treesitter-endwise",
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
      },
      indent = {
        enable = true,
        disable = { "ruby" }, -- ruby indenting doesn't seem to be working yet
      },
      endwise = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          keymaps = {
            ["ac"] = { query = "@class.outer", desc = "Select around class" },
            ["ic"] = { query = "@class.inner", desc = "Select inside class" },
            ["af"] = { query = "@function.outer", desc = "Select around function" },
            ["if"] = { query = "@function.inner", desc = "Select inside function" },
            ["al"] = { query = "@loop.outer", desc = "Select around loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inside loop" },
            ["ab"] = { query = "@block.outer", desc = "Select around block" },
            ["ib"] = { query = "@block.inner", desc = "Select inside block" },
          },
          selection_modes = {
            ["@class.outer"] = "V",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      ensure_installed = {
        "bash",
        "cmake",
        "diff",
        "dockerfile",
        "embedded_template",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "http",
        "javascript",
        "jq",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "properties",
        "python",
        "ruby",
        "rust",
        "sql",
        "ssh_config",
        "terraform",
        "toml",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    enabled = true,
    opts = {
      mode = "cursor",
      max_lines = 6,
      multiline_threshold = 3,
      trim_scope = "inner",
    },
    keys = {
      {
        "<leader>ut",
        function()
          local tsc = require("treesitter-context")
          tsc.toggle()
          if tsc.enabled() then
            vim.notify("Enabled Treesitter Context", vim.log.levels.INFO)
          else
            vim.notify("Disabled Treesitter Context", vim.log.levels.WARN)
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
  -- This plugin is amazing
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    opts = { use_default_keymaps = false },
    keys = {
      { "<leader>tt", "<Cmd>TSJToggle<CR>", desc = "Toggle Node Under Cursor" },
      { "<leader>ts", "<Cmd>TSJSplit<CR>", desc = "Split Node Under Cursor" },
      { "<leader>tj", "<Cmd>TSJJoin<CR>", desc = "Join Node Under Cursor" },
    },
  },
  {
    "aaronik/treewalker.nvim",
    opts = {
      highlight = true,
      highlight_duration = 200,
      highlight_group = "Visual",
      jumplist = true,
    },
    keys = {
      { "<A-}>", "<cmd>Treewalker Down<cr>", desc = "Treewalker Down", mode = { "n", "v" } },
      { "<A-{>", "<cmd>Treewalker Up<cr>", desc = "Treewalker Up", mode = { "n", "v" } },
      { "]]", "<cmd>Treewalker Right<cr>", desc = "Treewalker Right", mode = { "n", "v" } },
      { "[[", "<cmd>Treewalker Left<cr>", desc = "Treewalker Left", mode = { "n", "v" } },
    },
  },
  {
    "echasnovski/mini.ai",
    lazy = false,
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require("which-key").add(ret, { notify = false })
    end,
  },
}
