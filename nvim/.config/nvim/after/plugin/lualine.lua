-- Lualine Configuration with Catppuccin Mocha
require("lualine").setup({
  options = {
    theme = "catppuccin",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    globalstatus = true,
    disabled_filetypes = {
      statusline = { "dashboard", "lazy", "alpha" },
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = {
      { "branch", icon = "" },
      {
        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
      },
    },
    lualine_c = {
      {
        "filename",
        path = 1, -- Relative path
        symbols = {
          modified = " ●",
          readonly = " ",
          unnamed = "[No Name]",
        },
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " },
      },
      {
        -- Show LSP server name
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          if next(clients) == nil then
            return ""
          end
          local names = {}
          for _, client in ipairs(clients) do
            table.insert(names, client.name)
          end
          return " " .. table.concat(names, ", ")
        end,
      },
    },
    lualine_y = {
      { "filetype", icon_only = true },
      { "encoding" },
    },
    lualine_z = {
      { "progress" },
      { "location" },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { "fugitive", "lazy", "trouble" },
})
