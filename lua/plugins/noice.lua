return {
  "folke/noice.nvim",
  opts = {
    messages = {
      -- enabled = false,
      -- view_warn = "popup"
      -- view_error = "popup",
    },
    presets = {
      bottom_search = false,
      long_message_to_split = true,
    },
    routes = {
      -- -- show popup view for certain messages instead of default notification view
      {
        view = "notify",
        filter = {
          event = "msg_show",
          ["not"] = { kind = { "confirm", "confirm_sub", "search_count" } },
          -- kind = { "confirm", "echo", "echomsg", "echoerr", "lua_error", "wmsg" }
          -- find = "y/n"
        },
        opts = { replace = false, merge = true, title = "Messages" },
      },
      -- show recording messages in notification
      -- {
      --   view = "notify",
      --   filter = { event = "msg_showmode" }
      -- }
    },
  },
}
