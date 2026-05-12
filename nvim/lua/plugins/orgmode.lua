return {
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", lazy = true },
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/Documents/org/*" },
        org_default_notes_file = "~/Documents/org/refile.org",
        org_log_done = "time", -- Пишет дату при закрытии
        mappings = {
          org = {
            org_deadline = "d", -- Это у тебя уже работает
          },
        },
      })

      -- Принудительный бинд специально для файлов .org
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "org",
        callback = function()
          -- Назначаем 't' на смену статуса, игнорируя стандартную команду vim
          vim.keymap.set(
            "n",
            "t",
            [[<cmd>lua require('orgmode').action('org_mappings.todo_next_state')<CR>]],
            { buffer = true, silent = true }
          )
        end,
      })
    end,
  },
}
