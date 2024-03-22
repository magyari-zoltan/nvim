local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- use defaults
  -- api.config.mappings.default_on_attach(bufnr)

  -- remove a default
  -- vim.keymap.del('n', 'g?', { buffer = bufnr })

  -- override a default
  vim.keymap.set('n', '<c-e>', api.tree.reload, opts('Refresh'))

  -- add your mappings
  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
  ---
end

require'nvim-tree'.setup {
  on_attach = my_on_attach,
}

vim.api.nvim_set_keymap('n', '<m-1>', ':NvimTreeFindFileToggle<Enter>', {noremap = true})
