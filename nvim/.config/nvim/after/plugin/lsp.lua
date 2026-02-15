-- LSP Configuration (Neovim 0.11+ native vim.lsp.config API)

-- ============================================================================
-- Diagnostic Configuration
-- ============================================================================
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
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- ============================================================================
-- LSP Keymaps (via LspAttach autocmd)
-- ============================================================================
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  end,
})

-- ============================================================================
-- LSP Capabilities (with nvim-cmp integration)
-- ============================================================================
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ============================================================================
-- Language Server Configurations (Neovim 0.11+ API)
-- ============================================================================

-- Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Rust
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  filetypes = { "rust" },
  root_markers = { "Cargo.toml" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
      },
    },
  },
})

-- Python
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

-- TypeScript/JavaScript
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

-- C/C++
vim.lsp.config("clangd", {
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".git",
  },
})

-- LaTeX
vim.lsp.config("texlab", {
  capabilities = capabilities,
})

-- ============================================================================
-- Enable all configured language servers
-- ============================================================================
vim.lsp.enable({
  "lua_ls",
  "rust_analyzer",
  "pyright",
  "ts_ls",
  "clangd",
  "texlab",
})
