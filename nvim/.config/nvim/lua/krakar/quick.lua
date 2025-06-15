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
    -- Redirect stderr (cerr) to debug.txt
    local run_cmd = '! ./a.out 2> debug.txt'
    vim.cmd(run_cmd)
  end
end

function SPL(load_temp)
  -- Open task1.cpp in the left pane
  vim.cmd('vsplit task1.cpp')

  -- Move to the right pane
  vim.cmd('wincmd l')

  -- Split the right pane into 3 rows and open input.txt, output.txt, and debug.txt
  vim.cmd('split input.txt')
  vim.cmd('w')
  vim.cmd('wincmd j')

  vim.cmd('split output.txt')
  vim.cmd('w')
  vim.cmd('wincmd j')

  vim.cmd('e debug.txt')
  vim.cmd('w')
  vim.cmd('wincmd j')

  -- Move back to the topmost pane (input.txt)
  vim.cmd('wincmd k')
  vim.cmd('wincmd k')

  -- Move to the left pane
  vim.cmd('wincmd h')

  -- Reading the temp files now
  if load_temp then
    vim.cmd('r ~/tp/temp.cpp')
    vim.cmd('w task1.cpp')
    vim.cmd('w task2.cpp')
    vim.cmd('w task3.cpp')
    vim.cmd('w task4.cpp')
    vim.cmd('w task5.cpp')
    vim.cmd('w task6.cpp')
    vim.cmd('w task7.cpp')
  end
end


-- Map the function to a keybinding
vim.api.nvim_set_keymap('n', '<F5>', ':lua CompileAndRunQuickfix()<CR>', { noremap = true, silent = true })

