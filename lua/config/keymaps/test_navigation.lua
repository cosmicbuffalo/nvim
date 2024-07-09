-- Test file navigation
function GoToUnitTestFile()
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

function GoToIntegrationTestFile()
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

function CopyRspecContextCommand()
  local current_file = vim.fn.expand("%")
  local context_line = vim.fn.search([[^\s*context]], "bnc")

  if context_line == 0 then
    vim.notify("No context found above the current line.")
    CopyRspecDescribeCommand()
    return
  end

  local context_command = "rspec " .. current_file .. ":" .. context_line
  vim.fn.setreg("+", context_command)
  vim.notify("RSpec command copied to clipboard: " .. context_command)
end

function CopyRspecDescribeCommand()
  local current_file = vim.fn.expand("%")
  local describe_line = vim.fn.search([[^\s*describe]], "bnc")

  if describe_line == 0 then
    vim.notify("No describe found above the current line.")
    CopyRspecFileCommand()
    return
  end

  local describe_command = "rspec " .. current_file .. ":" .. describe_line .. " --fail-fast"
  vim.fn.setreg("+", describe_command)
  vim.notify("RSpec command copied to clipboard: " .. describe_command)
end

function CopyRspecFileCommand()
  local current_file = vim.fn.expand("%")
  if not string.match(current_file, "_spec.rb$") then
    vim.notify("Not a spec file.", "warn")
    return
  end
  local rspec_command = "rspec " .. current_file
  vim.fn.setreg("+", rspec_command)
  vim.notify("RSpec command copied to clipboard: " .. rspec_command)
end

function CopyRspecExampleCommand()
  local current_file = vim.fn.expand("%")
  local current_line = vim.fn.line(".")
  local example_command = "rspec " .. current_file .. ":" .. current_line
  vim.fn.setreg("+", example_command)
  vim.notify("RSpec command copied to clipboard: " .. example_command)
end

function SetSourceFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tu", [[<Cmd> lua GoToUnitTestFile()<CR>]], { desc = "Go to Unit Test File" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>ti", [[<Cmd> lua GoToIntegrationTestFile()<CR>]], { desc = "Go to Integration Test File" })
end

function SetUnitTestFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tb", [[<Cmd> lua GoToSourceFile()<CR>]], { desc = "Go to Source File" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>ti", [[<Cmd> lua GoToIntegrationTestFile()<CR>]], { desc = "Go to Integration Test File" })
end

function SetIntegrationTestFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tb", [[<Cmd> lua GoToSourceFile()<CR>]], { desc = "Go to Source File" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tu", [[<Cmd> lua GoToUnitTestFile()<CR>]], { desc = "Go to Unit Test File" })
end

function SetRspecFileKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tyc", [[<Cmd> lua CopyRspecContextCommand()<CR>]], { desc = "Copy Rspec context command" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tyd", [[<Cmd> lua CopyRspecDescribeCommand()<CR>]], { desc = "Copy Rspec describe command" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tyf", [[<Cmd> lua CopyRspecFileCommand()<CR>]], { desc = "Copy Rspec file command" })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>tye", [[<Cmd> lua CopyRspecExampleCommand()<CR>]], { desc = "Copy Rspec example command" })
end

vim.cmd([[
  augroup TestNavigationKeymaps
    autocmd!
    autocmd BufRead,BufNewFile */lib/**/*.rb :lua SetSourceFileKeymaps()
    autocmd BufRead,BufNewFile */app/**/*.rb :lua SetSourceFileKeymaps()
    autocmd BufRead,BufNewFile */spec/unit/**/*.rb :lua SetUnitTestFileKeymaps()
    autocmd BufRead,BufNewFile */spec/integration/**/*.rb :lua SetIntegrationTestFileKeymaps()
    autocmd BufRead,BufNewFile */spec/**/*_spec.rb :lua SetRspecFileKeymaps()
  augroup END
]])
