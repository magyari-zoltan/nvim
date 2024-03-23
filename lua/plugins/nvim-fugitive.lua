local function on_attach(buffer)
  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = buffer
    vim.keymap.set(mode, l, r, opts)
  end

  function gitCommitWindow() 
    --vim.split(':Gvsplit')
  end
  map('n', '<M-2>', gitCommitWindow, {expr = true, noremap = true})


end

require('nvim-fugitive').setup {
  on_attach = on_attach
}
