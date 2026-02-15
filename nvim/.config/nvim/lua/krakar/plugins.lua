-- All plugins for lazy.nvim
return {
  -- ============================================================================
  -- COLORSCHEME
  -- ============================================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          harpoon = true,
          mason = true,
          telescope = { enabled = true },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ============================================================================
  -- TELESCOPE (Fuzzy Finder)
  -- ============================================================================
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
      { "<C-p>", function() require("telescope.builtin").git_files() end, desc = "Git Files" },
      { "<leader>ps", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end, desc = "Grep String" },
      { "<leader>vh", function() require("telescope.builtin").help_tags() end, desc = "Help Tags" },
    },
  },

  -- ============================================================================
  -- TREESITTER (Syntax Highlighting)
  -- ============================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Install parsers (new nvim-treesitter API)
      local parsers = {
        "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "python",
        "c", "cpp", "rust",
        "latex", "matlab", "php",
        "markdown", "markdown_inline",
      }

      -- Auto-install missing parsers when entering buffer
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ft = vim.bo.filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if vim.tbl_contains(parsers, lang) then
            pcall(function()
              if not pcall(vim.treesitter.language.inspect, lang) then
                vim.cmd("TSInstall " .. lang)
              end
            end)
          end
        end,
      })

      -- Disable treesitter highlight for latex (use vimtex instead)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "latex" },
        callback = function()
          vim.treesitter.stop()
        end,
      })
    end,
  },

  -- ============================================================================
  -- HARPOON v2 (File Navigation)
  -- ============================================================================
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end,
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon Add File" },
      { "<C-e>", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Menu" },
      { "<leader>hp", function() require("harpoon"):list():prev() end, desc = "Harpoon Prev" },
      { "<leader>hn", function() require("harpoon"):list():next() end, desc = "Harpoon Next" },
      { "<leader>hq", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
      { "<leader>hw", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
      { "<leader>he", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
      { "<leader>hr", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },
    },
  },

  -- ============================================================================
  -- UNDOTREE
  -- ============================================================================
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree" },
    },
  },

  -- ============================================================================
  -- GIT
  -- ============================================================================
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gs", vim.cmd.Git, desc = "Git Status" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- ============================================================================
  -- LSP & COMPLETION
  -- ============================================================================
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- LSP config is in after/plugin/lsp.lua
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "pyright",
          "ts_ls",
          "clangd",
          "texlab",
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    lazy = true,
  },

  -- ============================================================================
  -- TROUBLE (Diagnostics)
  -- ============================================================================
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>tX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions (Trouble)" },
      { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    config = function()
      require("trouble").setup({})
    end,
  },

  -- ============================================================================
  -- LUALINE (Statusline)
  -- ============================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- Lualine config is in after/plugin/lualine.lua
    end,
  },

  -- ============================================================================
  -- COPILOT
  -- ============================================================================
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      -- Disable default Tab mapping (we'll use a different key)
      vim.g.copilot_no_tab_map = true

      -- Accept suggestion with Ctrl-J
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
      })

      -- Navigate suggestions
      vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { silent = true })
      vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { silent = true })

      -- Dismiss suggestion
      vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-dismiss)", { silent = true })

      -- Disable for certain filetypes
      vim.g.copilot_filetypes = {
        ["*"] = true,
        ["markdown"] = true,
        ["text"] = false,
        ["gitcommit"] = false,
        ["gitrebase"] = false,
      }
    end,
  },

  -- ============================================================================
  -- TMUX NAVIGATOR
  -- ============================================================================
  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Tmux Left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Tmux Down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Tmux Up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Tmux Right" },
    },
  },

  -- ============================================================================
  -- MARKDOWN PREVIEW
  -- ============================================================================
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    keys = {
      { "<leader>mv", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
  },

  -- ============================================================================
  -- VIMTEX (LaTeX)
  -- ============================================================================
  {
    "lervag/vimtex",
    ft = { "tex", "latex" },
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
    end,
  },

  -- ============================================================================
  -- ICONS (dependency for multiple plugins)
  -- ============================================================================
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
