return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        open_mapping = [[<c-_>]],
        winbar = {
          enabled = true,
          name_formatter = function(term)
            return term.name
          end

        }
      })
    end,
  }
}