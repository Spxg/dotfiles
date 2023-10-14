return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({})
        end,
        -- Next, you can provide targeted overrides for specific servers.
        ["rust_analyzer"] = function()
          vim.g.rustfmt_fail_silently = 0
          vim.g.rustfmt_autosave = 1
          require("rust-tools").setup({
            server = {
              settings = {
                ["rust-analyzer"] = {
                  lens = {
                    enable = false,
                  },
                  -- Add clippy lints for Rust.
                  checkOnSave = {
                    command = "clippy",
                  },
                  rustc = {
                    source = "discover",
                  },
                },
              },
            },
          })
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                completion = {
                  callSnippet = "Replace",
                },
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
      }
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "clangd",
        },
        automatic_installation = true,
        handlers = handlers,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
          }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  {
    "folke/neodev.nvim",
    opts = {},
    config = function()
      require("neodev").setup()
    end,
  },
  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          -- nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = { "stylua", "shfmt", "clang-format" },
        automatic_installation = true,
      })
    end,
  },
  "rust-lang/rust.vim",
  "simrat39/rust-tools.nvim",
}
