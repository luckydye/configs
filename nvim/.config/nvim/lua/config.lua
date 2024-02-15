local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

require("lazy").setup({
  spec = {

    { "loctvl842/monokai-pro.nvim" },

    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "monokai-pro",
      },
    },

    { "echasnovski/mini.pairs", enabled = false },

    { import = "lazyvim.plugins.extras.coding.copilot" },

    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.rust" },

    {
      "telescope.nvim",
      dependencies = {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },

    {
      "folke/trouble.nvim",
      opts = { use_diagnostic_signs = true },
    },

    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
      },
    },

    { "folke/noice.nvim", enabled = false },

    {
      "stevearc/conform.nvim",
      opts = {
        formatters = { "biome" },
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "biome" },
          typescriptreact = { "biome" },
          typescript = { "biome" },
        },
      },
    },

    {
      "williamboman/mason.nvim",
      opts = {
        ensure_installed = {
          "stylua",
          "shellcheck",
          "biome",
          "shfmt",
        },
      },
    },
  },
  defaults = {
    lazy = true,
  },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
