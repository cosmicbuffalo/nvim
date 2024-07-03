return {
  -- highlight jump points on f/F/t/T
  "jinh0/eyeliner.nvim",
  config = function()
    require('eyeliner').setup({
      highlight_on_key = true,
      -- dim = true,
    })

    vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, underline = true })
  end
}
