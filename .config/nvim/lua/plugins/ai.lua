-- AI Integration Plugins

return {
  -- opencode context.nvim - Send to opencode in tmux
  {
    "cousine/opencode-context.nvim",
    lazy = false,
    opts = {
      tmux_target = nil,
      auto_detect_pane = true,
    },
    keys = {
      { "<leader>oc", "<cmd>OpencodeSend<cr>", desc = "Send to opencode" },
      { "<leader>ot", "<cmd>OpencodeSwitchMode<cr>", desc = "Toggle opencode mode" },
    },
  },

  -- Terminal toggle
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end,
  },

  -- Task runner
  {
    "stevearc/overseer.nvim",
    lazy = true,
    config = function()
      require("overseer").setup({
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
        },
      })
    end,
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task list" },
    },
  },
}
