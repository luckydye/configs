-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
else
  require("config")
end

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

-- Alt+Up/Down to move lines
vim.api.nvim_set_keymap("n", "<A-Up>", ":m--<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-Down>", ":m+<CR>", { noremap = true, silent = true })

-- Ctrl+(Shift)+Tab -- Move between buffers
vim.api.nvim_set_keymap("n", "<C-Tab>", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-Tab>", ":bprevious<CR>", { noremap = true, silent = true })

-- Ctrl+w -- Close buffer
vim.api.nvim_set_keymap("n", "<C-w>", ":bd<CR>", { noremap = true, silent = true })

-- Ctrl+a -- Select all
vim.api.nvim_set_keymap("n", "<C-a>", ":ggVG<CR>", { noremap = true, silent = true })

-- Ctrl+q -- Open Code Actions
vim.api.nvim_set_keymap(
  "n",
  "<C-q>",
  ":lua vim.lsp.buf.code_action()<CR>",
  { noremap = true, silent = true }
)

-- Ctrl+p -- Open file search
vim.api.nvim_set_keymap(
  "n",
  "<C-p>",
  ":Telescope find_files<CR>",
  { noremap = true, silent = true }
)

-- Ctrl+t -- Open Neotree
vim.api.nvim_set_keymap("n", "<C-t>", ":Neotree toggle<CR>", { noremap = true, silent = true })

function Git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end
