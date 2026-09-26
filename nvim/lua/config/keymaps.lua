-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Единый leader (пробел) с vim: та же раскладка, что и в ~/.vimrc
vim.keymap.set("n", "<leader>h", "<cmd>edit ~/.config/HOTKEYS.md<cr>", { desc = "Шпаргалка по хоткеям (HOTKEYS.md)" })
vim.keymap.set("n", "<leader>hh", "<cmd>lua require('which-key').show({ global = false })<cr>", { desc = "Which-key: подсказки" })
