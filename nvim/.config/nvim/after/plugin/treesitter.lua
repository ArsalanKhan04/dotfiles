-- nvim-treesitter `main` branch: no module system, no `require('...configs').setup`.
-- Parsers are compiled from source, so the `tree-sitter` CLI must be on PATH
-- (Arch: `pacman -S tree-sitter-cli`). Neovim ships c/lua/markdown/query/vim/
-- vimdoc parsers built in, so those highlight even without the CLI.

local ensure = {
  "latex", "matlab", "javascript", "python", "cpp", "rust",
  "c", "lua", "vim", "vimdoc", "query", "php",
  "markdown", "markdown_inline",
}

local ok, ts = pcall(require, "nvim-treesitter")
local have_cli = vim.fn.executable("tree-sitter") == 1

if ok and have_cli then
  ts.install(ensure) -- async + idempotent (skips already-installed parsers)
elseif ok and not have_cli then
  vim.schedule(function()
    vim.notify(
      "treesitter: `tree-sitter` CLI not found; extra parsers won't build. Install tree-sitter-cli.",
      vim.log.levels.WARN
    )
  end)
end

-- Filetypes that keep their own highlighting (vimtex owns tex).
local disabled_ft = { tex = true, latex = true, plaintex = true, text = true }

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("krakar_treesitter", { clear = true }),
  callback = function(ev)
    if disabled_ft[ev.match] then
      return
    end

    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

    if not pcall(vim.treesitter.language.add, lang) then
      -- No parser available: fetch it (if we can) and highlight next time.
      if ok and have_cli then
        pcall(function() ts.install({ lang }) end)
      end
      return
    end

    pcall(vim.treesitter.start, ev.buf, lang)
  end,
})
