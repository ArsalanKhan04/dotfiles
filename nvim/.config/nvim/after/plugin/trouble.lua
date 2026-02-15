-- Trouble v3 Configuration
-- Keymaps are defined in plugins.lua for lazy loading
-- This file is kept for any additional trouble-specific settings

local trouble = require("trouble")

trouble.setup({
  position = "bottom",
  height = 10,
  icons = true,
  mode = "diagnostics",
  auto_open = false,
  auto_close = true,
  auto_preview = true,
  auto_fold = false,
  use_diagnostic_signs = true,
})
