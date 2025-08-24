return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = true,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browserfunc = "CopyToClipboard"
      vim.g.mkdp_port = "9049" -- Need to forward this port in .cpair.conf
      -- Set up a clipboard watching script to open copied URLs in the browser automatically
      -- See example script here: https://gist.github.com/cosmicbuffalo/60a70e15ace8961b9bb11e9206363ec8
      function _G.CopyToClipboard(url)
        vim.fn.setreg("+", url)
        vim.notify(
          "Markdown Preview URL copied to clipboard: " .. url,
          vim.log.levels.INFO,
          { title = "Markdown Preview" }
        )
      end
      vim.cmd([[
				function! CopyToClipboard(url)
				  call luaeval('_G.CopyToClipboard(_A)', a:url)
				endfunction
			]])
    end,
    ft = { "markdown" },
    keys = {
      { "<leader>mp", ":MarkdownPreview<CR>", desc = "Start Markdown Preview" },
      { "<leader>ms", ":MarkdownPreviewStop<CR>", desc = "Stop Markdown Preview" },
      { "<leader>mt", ":MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
    },
  },
}
