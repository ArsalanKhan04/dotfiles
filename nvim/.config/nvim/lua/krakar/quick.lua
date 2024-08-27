-- Function to compile and run C++ code, outputting to the Quickfix Window
function CompileAndRunQuickfix()
  -- Save the current file
  vim.cmd('w')

  -- Compile the current file with g++
  local filename = vim.fn.expand('%:p')
  local compile_cmd = 'g++ -Wshadow -DKRAKAR -o a.out ' .. filename .. ' 2>&1 | tee /tmp/quickfix.log'

  -- Run the compile command and send output to quickfix
  vim.cmd('silent !' .. compile_cmd)
  vim.cmd('cfile /tmp/quickfix.log')

  -- Open the Quickfix window if there are any entries
  if vim.fn.getqflist({size=0}).size > 0 then
    vim.cmd('copen')
  else
    -- If compilation succeeds without errors, run the output executable
    vim.cmd('! ./a.out')
  end
end

-- Map the function to a keybinding
vim.api.nvim_set_keymap('n', '<F5>', ':lua CompileAndRunQuickfix()<CR>', { noremap = true, silent = true })

