--------------------------------------------------
-- Private methods
--------------------------------------------------
local function on_attach(bufnr)
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local api = require('nvim-tree.api')

  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'U', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'u', api.node.navigate.parent, opts('Parent Directory'))
  vim.keymap.set('n', 'P', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'e', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))

  vim.keymap.set('n', '<Enter>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'o', api.node.open.drop, opts('Open'))
  vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 't', api.node.open.tab_drop, opts('Open: New Tab'))
  vim.keymap.set('n', 'i', api.node.show_info_popup, opts('Info'))
  vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))

  vim.keymap.set('n', 'M', api.tree.toggle_no_bookmark_filter, opts('Toggle Filter: No Bookmark'))
  vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
  vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Filter: Dotfiles'))
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Filter: Git Ignore'))
  vim.keymap.set('n', 'F', api.live_filter.clear, opts('Live Filter: Clear'))
  vim.keymap.set('n', 'f', api.live_filter.start, opts('Live Filter: Start'))

  vim.keymap.set('n', '<m-j>', api.node.navigate.sibling.last, opts('Last Sibling'))
  vim.keymap.set('n', '<m-k>', api.node.navigate.sibling.first, opts('First Sibling'))
  vim.keymap.set('n', 'J', api.node.navigate.sibling.next, opts('Last Sibling'))
  vim.keymap.set('n', 'K', api.node.navigate.sibling.prev, opts('First Sibling'))
  vim.keymap.set('n', 'gk', api.node.navigate.git.prev, opts('Prev Git'))
  vim.keymap.set('n', 'gj', api.node.navigate.git.next, opts('Next Git'))

  vim.keymap.set('n', 'a', api.fs.create, opts('Create File Or Directory'))
  vim.keymap.set('n', 'bm', api.marks.bulk.move, opts('Move Bookmarked'))

  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
  vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
  vim.keymap.set('n', 'bt', api.marks.bulk.trash, opts('Trash Bookmarked'))

  vim.keymap.set('n', 'rn', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'r', api.fs.rename_basename, opts('Rename: Basename'))
  vim.keymap.set('n', 'rf', api.fs.rename_full, opts('Rename: Full Path'))

  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))

  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'yb', api.fs.copy.basename, opts('Copy Basename'))
  vim.keymap.set('n', 'ya', api.fs.copy.absolute_path, opts('Copy Absolute Path'))

  vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
  ---
end

local function setupPlugin()
  require('nvim-tree').setup {
    on_attach = on_attach,
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 60,
    },
    renderer = {
      group_empty = true,
      icons = {
        glyphs = {
          symlink = "",
          folder = {
            arrow_closed = "▶", -- symbol when folder is closed
            arrow_open = "▼", -- symbol when folder is open
            symlink = ""
          },
          git = {
            untracked = "",
            unstaged = "󰷉",
            staged = "",
            unmerged = "",
            renamed = "",
            deleted = ""
          }
        }
      }
    },
    filters = {
      dotfiles = true,
    },
  }

  vim.api.nvim_set_keymap('n', '<m-e>', ':NvimTreeFindFileToggle<Enter>', { noremap = true })
end

--------------------------------------------------
-- Error handling
--------------------------------------------------
local function errorHandler(error)
  vim.notify('nvim-tree plugin could not be loaded!', WARN)
  vim.notify(error, ERROR)
end

--------------------------------------------------
-- Entrypoint
--------------------------------------------------
tryCatch(setupPlugin, errorHandler)
--------------------------------------------------
