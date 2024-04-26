return {
  -- highlight jump points on f/F/t/T
  "jinh0/eyeliner.nvim",
  config = function()
    require('eyeliner').setup({
      highlight_on_key = true
    })
  end
}
