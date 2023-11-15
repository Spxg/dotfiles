return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        color_overrides = {
          mocha = {
            rosewater = "#ffc9c9",
            flamingo = "#ff9f9a",
            pink = "#ffa9c9",
            mauve = "#df95cf",
            lavender = "#a990c9",
            red = "#ff6960",
            maroon = "#f98080",
            peach = "#f9905f",
            yellow = "#f9bd69",
            green = "#b0d080",
            teal = "#a0dfa0",
            sky = "#a0d0c0",
            sapphire = "#95b9d0",
            blue = "#89a0e0",
            text = "#e0d0b0",
            subtext1 = "#d5c4a1",
            subtext0 = "#bdae93",
            overlay2 = "#928374",
            overlay1 = "#7c6f64",
            overlay0 = "#665c54",
            surface2 = "#504844",
            surface1 = "#3a3634",
            surface0 = "#252525",
            base = "#151515",
            mantle = "#0e0e0e",
            crust = "#080808",
          },
        },
      })
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup({
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            "diff",
            { "diagnostics", source = { "nvim" } },
            { "filename", file_status = false, path = 1 },
          },
          lualine_c = {},
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({ "skim" })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      -- terminal
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        close_on_exit = true,
        hide_numbers = false,
        direction = "tab",
      })
    end,
  },
  "tpope/vim-unimpaired",
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
      },
    },
    event = "VeryLazy",
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
  },
  {
    "rhysd/git-messenger.vim",
    config = function()
      -- the cursor goes into a popup window when running GitMessenger
      vim.g.git_messenger_always_into_popup = 1
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      delay = 100,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "rust", "c", "lua", "vim", "vimdoc", "bash", "python" },
        sync_install = false,
        highlight = { enable = false },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup()
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["q"] = "actions.close",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
