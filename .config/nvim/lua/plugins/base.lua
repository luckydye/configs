return {
  {
    "Mofiqul/vscode.nvim",
    name = "vscode",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({})
      require("vscode").load()
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = "LazyFile",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(
          ".null-ls-root",
          ".neoconf.json",
          "Makefile",
          ".git"
        ),
        sources = {
          nls.builtins.formatting.biome,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
        },
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    config = function()
      require("neo-tree").setup()
    end,
  },

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

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
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
}
