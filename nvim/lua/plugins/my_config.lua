return {
  -- 1. GitHub Light Theme
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          darken = {
            sidebars = { "qf", "terminal", "neo-tree" },
          },
        },
      })
      vim.cmd("colorscheme github_light")
    end,
  },

  -- 2. Org-mode
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/Documents/org/*" },
        org_default_notes_file = "~/Documents/org/refile.org",
      })
    end,
  },

  -- 3. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "org",
          "python",
          "cpp",
          "c_sharp",
          "lua",
        })
      end
    end,
  },

  -- 4. Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = { width = 30 },
      filesystem = {
        filtered_items = { visible = true },
      },
    },
  },

  -- 5. Настройка стартового экрана (Dashboard)
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header", padding = 1 }, -- Твоя надпись тут
          { section = "keys", gap = 1, padding = 1 }, -- Только буквы и текст
        },
        preset = {
          -- Можешь написать тут "zavim", "neovim" или что угодно
          header = [[zavim]],
          keys = {
            { key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { key = "r", desc = "Recent", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { key = "n", desc = "New File", action = ":ene | startinsert" },
            {
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { key = "l", desc = "Lazy", action = ":Lazy" },
            { key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true, -- поиск внизу
        command_palette = false, -- отключает большое окно по центру
        long_message_to_split = true,
      },
    },
  },
}
