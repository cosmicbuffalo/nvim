return {
  {
    -- preview lines in buffer as you type :lineno
    'nacro90/numb.nvim',
    config = function ()
      require('numb').setup()
    end
  }
}
