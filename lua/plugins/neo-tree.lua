return {

  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = {
      commands = {
        open_in_finder = function(state)

          local node = state.tree:get_node()
          if node then
            if node.type == "message" then
              return
            end

            local path = node:get_id()
            if node.type == "directory" then
              vim.cmd('silent !open ' .. vim.fn.shellescape(path))
            elseif node.type == "file" then
              vim.cmd('silent !open -R ' .. vim.fn.shellescape(path))
            end

          end
        end
      },
      buffers = {
        commands = {
          buffer_delete = function(state)
            local node = state.tree:get_node()
            if node then
              if node.type == "message" then
                return
              end

              local bufnr = node.extra.bufnr
              local bd = require("mini.bufremove").delete
              if vim.fn.getbufvar(bufnr, "&modified") == 1 then
                local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname(bufnr)), "&Yes\n&No\n&Cancel")
                if choice == 1 then -- Yes
                  vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("write")
                  end)
                  bd(bufnr)
                elseif choice == 2 then -- No
                  bd(bufnr, true)
                end
              else
                bd(bufnr)
              end
              local manager = require("neo-tree.sources.manager")
              local refresh = require("neo-tree.utils").wrap(manager.refresh, "buffers")
              refresh()
            end
          end,
        }
      },
      window = {
        mappings = {
          ["O"] = "open_in_finder",
        }
      }
    }
  }
}
