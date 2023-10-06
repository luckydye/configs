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
    "nvim-neo-tree/neo-tree.nvim",
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
        "shfmt",
      },
    },
  },
}
