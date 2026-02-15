-- Color utility function for transparent background
-- Catppuccin is already set up in plugins.lua
-- Call ColorMyPencils() if you want transparent background

function ColorMyPencils(color)
  color = color or "catppuccin"
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- Uncomment the line below if you want transparent background
-- ColorMyPencils()
