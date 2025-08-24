local Utils = require("config.utils")

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = false, -- This is handled by the `ai_accept` blink action instead
        },
      },
      panel = {
        enabled = true,
      },
    },
    init = function()
      Utils.cmp.actions.ai_accept = function()
        if require("copilot.suggestion").is_visible() then
          Utils.create_undo()
          require("copilot.suggestion").accept()
          return true
        end
      end
    end,
    keys = {
      { "<Leader>al", "<cmd>Copilot auth<cr>", desc = "Copilot: [a]i [l]ogin" },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "zbirenbaum/copilot.lua" },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        },
        opts = {
          file_types = { "copilot-chat" },
        },
      },
    },
    build = "make tiktoken",
    opts = {
      sticky = "#buffer",
      highlight_headers = false,
      separator = "---",
      answer_header = "##   Copilot ",
      error_header = "> [!ERROR] Error",
      mappings = {
        reset = {
          normal = "<C-r>",
          insert = "<C-r>",
        },
      },
    },
    keys = {
      { "<Leader>aa", "<cmd>CopilotChatToggle<CR>", desc = "Copilot: [a]i [a]sk", mode = { "n", "v" } },
      { "<Leader>ap", "<cmd>CopilotChatPrompts<CR>", desc = "Copilot: [a]i [p]rompt", mode = { "n", "v" } },
      { "<leader>ae", "<cmd>CopilotChatExplain<CR>", desc = "Copilot: [a]i [e]xplain", mode = { "v" } },
      { "<leader>ar", "<cmd>CopilotChatReview<CR>", desc = "Copilot: [a]i [r]eview", mode = { "n", "v" } },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Copilot: [a]i [q]uick chat",
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      local user = vim.env.SSH_USERNAME or vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      opts.question_header = "#   " .. user .. " "

      chat.setup(opts)
    end,
  },
  { "AndreM222/copilot-lualine" },
}
