-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
