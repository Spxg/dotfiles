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
    end,
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup()
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
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
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
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["q"] = "actions.close",
      },
      skip_confirm_for_simple_edits = true,
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "rust", "c", "lua", "bash", "toml", "yaml", "json" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {}, -- this is equalent to setup({}) function
  },
  { "kevinhwang91/nvim-bqf" },
  { "mhinz/vim-grepper" },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          custom_filter = function(buf_number)
            if vim.bo[buf_number].filetype ~= "qf" then
              return true
            end
            return false
          end,
        },
      })
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "v1.0.0",
    opts = {
      -- options
    },
  },
}
