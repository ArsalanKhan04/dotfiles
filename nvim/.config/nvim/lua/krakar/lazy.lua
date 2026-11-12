-- Bootstrap lazy.nvim (replaces packer)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- <leader> is set in remap.lua, which is required before this file.

require("lazy").setup({
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Treesitter (main branch: new API, works with Neovim 0.11+)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },

  -- Navigation / editing
  { "theprimeagen/harpoon" }, -- v1 API (harpoon.mark / harpoon.ui)
  { "mbbill/undotree" },
  { "tpope/vim-fugitive" },

  -- LSP + completion (no lsp-zero; native vim.lsp.config on 0.11+)
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- LaTeX
  { "lervag/vimtex" },

  -- Diagnostics list (pinned to v2 to match existing keymaps/API)
  {
    "folke/trouble.nvim",
    version = "v2.*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Misc
  { "github/copilot.vim" },
  { "christoomey/vim-tmux-navigator" },
  { "feline-nvim/feline.nvim" },
  { "lewis6991/gitsigns.nvim" },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  },
}, {
  -- Load everything at startup (like packer did) so after/plugin/*.lua
  -- configs always run against loaded plugins.
  defaults = { lazy = false },
  change_detection = { notify = false },
})
