return {
  {
    "luukvbaal/statuscol.nvim",
    -- enabled = false,
    -- event = "BufReadPost",
    lazy = false,
    config = function()
      local builtin = require("statuscol.builtin")
      -- require("statuscol").setup()
      require("statuscol").setup({
        relculright = true,
        segments = {

          -- {
          --   sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
          --   click = "v:lua.ScSa",
          -- },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          -- {
          --   sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
          --   click = "v:lua.ScSa",
          -- },
          { text = { " " } },
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { " " } },
          { text = { "%s" }, click = "v:lua.ScSa" },
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    -- enabled = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    lazy = false,
    -- event = "BufReadPost",
    opts = {
      open_fold_hl_timeout = 400,
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          -- winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}

        local totalLines = vim.api.nvim_buf_line_count(0)
        local foldedLines = endLnum - lnum
        local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
        suffix = (" "):rep(rAlignAppndx) .. suffix
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      opts["fold_virt_text_handler"] = handler
      local ufo = require("ufo")
      ufo.setup(opts)

      vim.keymap.set("n", "zr", require("ufo").openAllFolds, { desc = "Open all Folds" })
      vim.keymap.set("n", "zm", require("ufo").closeAllFolds, { desc = "Close all Folds" })

      function fold_at_indent_level()
        local bufnr = vim.api.nvim_get_current_buf()
        local current_line = vim.fn.line(".")
        local current_indent = vim.fn.indent(current_line)
        local fold_ranges = ufo.getFolds(bufnr, "treesitter")
        local fold_closed = vim.fn.foldclosed(current_line) ~= -1

        for _, range in pairs(fold_ranges) do
          if range.startLine then
            local start_line = range.startLine + 1
            local start_indent = vim.fn.indent(start_line)

            if start_indent == current_indent then
              if fold_closed then
                vim.api.nvim_command(start_line .. "foldopen")
              else
                vim.api.nvim_command(start_line .. "foldclose")
              end
            end
          else
            print("Invalid range detected: ", vim.inspect(range))
          end
        end
      end

      vim.keymap.set("n", "<leader>Z", fold_at_indent_level, { desc = "Toggle folds at current indentation" })
    end,
  },
  {
    "cosmicbuffalo/fold-preview.nvim",
    branch = "fix-eventignore",
    dependencies = {
      "cosmicbuffalo/keymap-amend.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      require("fold-preview").setup({
        default_keybindings = false,
      })
      local map = require("fold-preview").mapping
      local keymap = vim.keymap
      keymap.amend = require("keymap-amend")

      keymap.amend("n", "<right>", map.show_close_preview_open_fold, { desc = "Preview/open fold" })
      keymap.amend("n", "<left>", map.close_preview, { desc = "Close fold preview" })
      keymap.amend("n", "za", map.close_preview, { desc = "Toggle fold under cursor" })
      keymap.amend("n", "zo", map.close_preview, { desc = "Open fold under cursor" })
      keymap.amend("n", "zO", map.close_preview, { desc = "Open all folds under cursor" })
      keymap.amend("n", "zR", map.close_preview, { desc = "Open all folds" })
      keymap.amend("n", "zc", map.close_preview_without_defer, { desc = "Close fold under cursor" })
      keymap.amend("n", "zC", map.close_preview_without_defer, { desc = "Close all folds under cursor" })
      keymap.amend("n", "zM", map.close_preview_without_defer, { desc = "Close all folds" })
    end,
  },
}
