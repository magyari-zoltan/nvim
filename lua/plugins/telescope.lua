local function setupPlugin()
  require("telescope").setup {
    create_layout = function(picker)
      local function create_window(enter, width, height, row, col, title)
        local bufnr = vim.api.nvim_create_buf(false, true)
        local winid = vim.api.nvim_open_win(bufnr, enter, {
          style = "minimal",
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          border = "single",
          title = title,
        })

        vim.wo[winid].winhighlight = "Normal:Normal"

        return Layout.Window {
          bufnr = bufnr,
          winid = winid,
        }
      end

      local function destory_window(window)
        if window then
          if vim.api.nvim_win_is_valid(window.winid) then
            vim.api.nvim_win_close(window.winid, true)
          end
          if vim.api.nvim_buf_is_valid(window.bufnr) then
            vim.api.nvim_buf_delete(window.bufnr, { force = true })
          end
        end
      end

      local layout = Layout {
        picker = picker,
        mount = function(self)
          self.results = create_window(false, 40, 20, 0, 0, "Results")
          self.preview = create_window(false, 40, 23, 0, 42, "Preview")
          self.prompt = create_window(true, 40, 1, 22, 0, "Prompt")
        end,
        unmount = function(self)
          destory_window(self.results)
          destory_window(self.preview)
          destory_window(self.prompt)
        end,
        update = function(self) end,
      }

      return layout
    end,
  }

  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fr', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
  vim.keymap.set('n', '<leader>fn', createCommand('Telescope notify'), {})
end

local function errorHandler(error)
  vim.notify('Telescope plugin could not be loaded!')
  vim.notify(error)
end

tryCatch(setupPlugin, errorHandler)
