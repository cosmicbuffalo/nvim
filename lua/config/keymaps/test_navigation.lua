-- Test file navigation
function go_to_unit_test_file()
  local current_file = vim.fn.expand("%:p")
  local unit_test_file = nil

  if string.match(current_file, "lib/.*%.rb") then
    unit_test_file = string.gsub(current_file, "lib/(.*)%.rb", "spec/unit/%1_spec.rb")
  elseif string.match(current_file, "app/.*%.rb") then
    unit_test_file = string.gsub(current_file, "app/(.*)%.rb", "spec/unit/%1_spec.rb")
  elseif string.match(current_file, "spec/integration/.*_spec%.rb") then
    unit_test_file = string.gsub(current_file, "spec/integration/(.*)_spec%.rb", "spec/unit/%1_spec.rb")
  end
  if io.open(unit_test_file, "r") == nil then
    vim.notify("No unit test file found, opening new buffer at path")
  end
  vim.cmd("e" .. unit_test_file)
end

function go_to_integration_test_file()
  local current_file = vim.fn.expand("%:p")
  local integration_test_file = nil
  if string.match(current_file, "lib/.*%.rb") then
    integration_test_file = string.gsub(current_file, "lib/(.*)%.rb", "spec/integration/%1_spec.rb")
  elseif string.match(current_file, "app/.*%.rb") then
    integration_test_file = string.gsub(current_file, "app/(.*)%.rb", "spec/integration/%1_spec.rb")
  elseif string.match(current_file, "spec/unit/.*_spec%.rb") then
    integration_test_file = string.gsub(current_file, "spec/unit/(.*)_spec%.rb", "spec/integration/%1_spec.rb")
  end
  if io.open(integration_test_file, "r") == nil then
    vim.notify("No integration test file found, opening new buffer at path")
  end
  vim.cmd("e" .. integration_test_file)
end

function go_to_source_file()
  local current_file = vim.fn.expand("%:p")
  local lib_file = nil
  if string.match(current_file, "spec/unit/.*_spec%.rb") then
    lib_file = string.gsub(current_file, "spec/unit/(.*)_spec%.rb", "lib/%1.rb")
  elseif string.match(current_file, "spec/integration/.*_spec%.rb") then
    lib_file = string.gsub(current_file, "spec/integration/(.*)_spec%.rb", "lib/%1.rb")
  else
    vim.notify("Not a unit or integration test file", "error")
    return
  end
  vim.cmd("e" .. lib_file)
end

function copy_rspec_context_command()
  local current_file = vim.fn.expand("%")
  local context_line = vim.fn.search([[^\s*context]], "bnc")

  if context_line == 0 then
    vim.notify("No context found above the current line.")
    copy_rspec_describe_command()
    return
  end

  local context_command = "rspec " .. current_file .. ":" .. context_line
  vim.fn.setreg("+", context_command)
  vim.notify("RSpec command copied to clipboard: " .. context_command)
end

function copy_rspec_describe_command()
  local current_file = vim.fn.expand("%")
  local describe_line = vim.fn.search([[^\s*describe]], "bnc")

  if describe_line == 0 then
    vim.notify("No describe found above the current line.")
    copy_rspec_file_command()
    return
  end

  local describe_command = "rspec " .. current_file .. ":" .. describe_line .. " --fail-fast"
  vim.fn.setreg("+", describe_command)
  vim.notify("RSpec command copied to clipboard: " .. describe_command)
end

function copy_rspec_file_command()
  local current_file = vim.fn.expand("%")
  if not string.match(current_file, "_spec.rb$") then
    vim.notify("Not a spec file.", "warn")
    return
  end
  local rspec_command = "rspec " .. current_file
  vim.fn.setreg("+", rspec_command)
  vim.notify("RSpec command copied to clipboard: " .. rspec_command)
end

function copy_rspec_example_command()
  local current_file = vim.fn.expand("%")
  local current_line = vim.fn.line(".")
  local example_command = "rspec " .. current_file .. ":" .. current_line
  vim.fn.setreg("+", example_command)
  vim.notify("RSpec command copied to clipboard: " .. example_command)
end

function set_source_file_keymaps()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tu",
    [[<Cmd> lua go_to_unit_test_file()<CR>]],
    { desc = "Go to Unit Test File" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>ti",
    [[<Cmd> lua go_to_integration_test_file()<CR>]],
    { desc = "Go to Integration Test File" }
  )
end

function set_unit_test_file_keymaps()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tb",
    [[<Cmd> lua go_to_source_file()<CR>]],
    { desc = "Go to Source File" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>ti",
    [[<Cmd> lua go_to_integration_test_file()<CR>]],
    { desc = "Go to Integration Test File" }
  )
end

function set_integration_test_file_keymaps()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tb",
    [[<Cmd> lua go_to_source_file()<CR>]],
    { desc = "Go to Source File" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tu",
    [[<Cmd> lua go_to_unit_test_file()<CR>]],
    { desc = "Go to Unit Test File" }
  )
end

function set_rspec_file_keymaps()
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tyc",
    [[<Cmd> lua copy_rspec_context_command()<CR>]],
    { desc = "Copy Rspec context command" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tyd",
    [[<Cmd> lua copy_rspec_describe_command()<CR>]],
    { desc = "Copy Rspec describe command" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tyf",
    [[<Cmd> lua copy_rspec_file_command()<CR>]],
    { desc = "Copy Rspec file command" }
  )
  vim.api.nvim_buf_set_keymap(
    0,
    "n",
    "<leader>tye",
    [[<Cmd> lua copy_rspec_example_command()<CR>]],
    { desc = "Copy Rspec example command" }
  )
end

vim.cmd([[
  augroup TestNavigationKeymaps
    autocmd!
    autocmd BufRead,BufNewFile */lib/**/*.rb :lua set_source_file_keymaps()
    autocmd BufRead,BufNewFile */app/**/*.rb :lua set_source_file_keymaps()
    autocmd BufRead,BufNewFile */spec/unit/**/*.rb :lua set_unit_test_file_keymaps()
    autocmd BufRead,BufNewFile */spec/integration/**/*.rb :lua set_integration_test_file_keymaps()
    autocmd BufRead,BufNewFile */spec/**/*_spec.rb :lua set_rspec_file_keymaps()
  augroup END
]])
