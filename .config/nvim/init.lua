-- bootstrap lazy.nvim, LazyVim and your plugins


if vim.g.vscode then
  -- VSCode extension
else
  require("config.lazy")
end

vim.api.nvim_set_keymap("n", "<A-Up>", ":m--<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-Down>", ":m+<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-w>", ":bd<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-p>', ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ":Neotree toggle<CR>", { noremap = true, silent = true })
