-- require("config.lazy")
require("config.lazyvim")

local plugins = {
  {
    "cousine/opencode-context.nvim",
    opts = {
      tmux_target = nil,
      auto_detect_pane = true,
    },
    keys = {
      { "<leader>oc", "<cmd>OpencodeSend<cr>", desc = "Send to opencode" },
      { "<leader>ot", "<cmd>OpencodeSwitchMode<cr>", desc = "Toggle opencode mode" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
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
  {
    "stevearc/overseer.nvim",
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

require("lazy").setup(plugins, require("lazy").config)
