-- Native LSP setup (Neovim 0.11+), replaces lsp-zero.
-- mason installs servers; mason-lspconfig v2 auto-runs vim.lsp.enable() for
-- every installed server. Per-server tweaks go through vim.lsp.config().

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Defaults applied to every server.
vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Per-server overrides (merged over nvim-lspconfig's shipped defaults).
vim.lsp.config("rust_analyzer", {
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },
    },
  },
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--compile-commands-dir=~/Files/opensource/libreoffice/",
    "--all-scopes-completion",
  },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "rust_analyzer", "pyright", "texlab", "clangd", "lua_ls" },
  automatic_enable = true,
})

-- Completion
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
    { name = "buffer" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    -- <Tab>/<S-Tab> intentionally left unmapped (preset.insert does not map them)
  }),
})

-- Buffer-local keymaps when a server attaches (was lsp.on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.HINT] = "H",
      [vim.diagnostic.severity.INFO] = "I",
    },
  },
})
