---Autocommands for editor behavior, UI tweaks, and convenience features.
local function augroup(name)
  return vim.api.nvim_create_augroup("star_" .. name, { clear = true })
end

-- =============================================================================
-- Highlight yanked text briefly
-- =============================================================================
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- =============================================================================
-- Return to last edit position when opening a file
-- =============================================================================
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].neovim_last_loc then
      return
    end
    vim.b[buf].neovim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- =============================================================================
-- Terminal buffer: no line numbers, no sign column
-- =============================================================================
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- =============================================================================
-- Close special buffers with q / <Esc> (help, checkhealth, etc.)
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "gitsigns-blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        if #vim.api.nvim_list_wins() > 1 then
          vim.cmd("close")
        else
          vim.cmd("bdelete!")
        end
      end, { buffer = event.buf, silent = true, desc = "Quit buffer" })

      vim.keymap.set("n", "<ESC>", function()
        if #vim.api.nvim_list_wins() > 1 then
          vim.cmd("close")
        else
          vim.cmd("bdelete!")
        end
      end, { buffer = event.buf, silent = true, desc = "Quit buffer" })
    end)
  end,
})

-- =============================================================================
-- Auto-enable diagnostics for lua files
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.diagnostic.enable(true)
  end,
})

-- =============================================================================
-- Auto-create parent directories when saving a file
-- =============================================================================
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- =============================================================================
-- Equalize split sizes when terminal is resized
-- =============================================================================
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- =============================================================================
-- Quit diff mode with q when no unsaved changes
-- =============================================================================
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    if require("configs.utils").is_diff_mode() then
      vim.keymap.set("n", "q", function()
        if not vim.bo.modified then
          vim.cmd("qa")
        else
          vim.notify("Buffer has unsaved changes. Use :qa! to quit without saving.",
            vim.log.levels.WARN)
        end
      end, { buffer = true, desc = "Quit if no changes" })
    end
  end,
})

-- =============================================================================
-- Clear search register on exit
-- =============================================================================
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = function()
    vim.fn.setreg("/", "") -- reset search history register
  end,
})


-- =============================================================================
-- Dynamic foldcolumn (show only when folds exist)
-- =============================================================================
vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorHold", "InsertLeave" }, {
  callback = function()
    require("configs.utils").update_foldcolumn()
  end,
})

-- =============================================================================
-- Enable snacks indent guides for specific filetypes
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp", "lua", "python" },
  callback = function()
    local status, snacks_indent = pcall(require, "snacks.indent")
    if status then
      snacks_indent.enable()
    end
    -- TODO: if snacks.indent no ok, output notify
  end,
})

-- =============================================================================
-- Focus-aware window appearance:
--   - Focused windows: normal background
--   - Unfocused windows: slightly dimmer background
--   - Cursorline: only visible in focused window
--   - Excluded filetypes/buftypes: no background change
-- =============================================================================

vim.api.nvim_set_hl(0, "FocusedWindow", { link = "Normal" })
vim.api.nvim_set_hl(0, "UnfocusedWindow", { bg = "#2c2c30" })

local ignore_filetypes = {
  "NvimTree",
  "tagbar",
  "undotree",
  "aerial",
  "trouble",
  "noice",
  "TelescopePrompt",
  "TelescopeResults",
  "gitsigns-blame",
}

local ignore_buftypes = {
  "nofile",
  "prompt",
  "popup",
}

local focusWindow = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

-- enable cursorline in focused window
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  group = focusWindow,
  callback = function()
    if require("configs.utils").is_diff_mode() then return end
    local ft = vim.bo.filetype
    if not vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        and ft ~= "" and not vim.tbl_contains(ignore_filetypes, ft) then
      vim.wo.cursorline = true
    end
  end,
  desc = "Enable cursorline in focused window",
})

-- disable cursorline in unfocused window
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  group = focusWindow,
  callback = function()
    if require("configs.utils").is_diff_mode() then return end
    local ft = vim.bo.filetype
    if not vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        and ft ~= "" and not vim.tbl_contains(ignore_filetypes, ft) then
      vim.wo.cursorline = false
    end
  end,
  desc = "Disable cursorline in unfocused window",
})

-- =============================================================================
-- C/C++: highlight lines exceeding 128 columns
-- =============================================================================
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= "cpp" and ft ~= "c" then
      return
    end
    if vim.w.overlength_match then
      return
    end
    vim.w.overlength_match = vim.fn.matchadd("Error", [[\%129v.\+]])
  end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
  callback = function()
    if vim.w.overlength_match then
      vim.fn.matchdelete(vim.w.overlength_match)
      vim.w.overlength_match = nil
    end
  end,
})

-- =============================================================================
-- Daily Note: Create/open YYYY-MM-DD.md with frontmatter
-- =============================================================================
local function create_daily_note()
  local cwd = vim.fn.getcwd()
  local filename = os.date("%Y-%m-%d") .. ".md"
  local full_path = cwd .. "/" .. filename

  if vim.fn.filereadable(full_path) == 1 then
    vim.cmd.edit(full_path)
    return
  end

  local id = os.date("%Y%m%d%H%M%S")
  local created = os.date("%Y-%m-%d %H:%M")
  local updated = created

  local frontmatter = {
    "---",
    "id: " .. id,
    "created: " .. created,
    "updated: " .. updated,
    "tags:",
    "- ",
    "---",
    "",
  }

  local file = io.open(full_path, "w")
  if file then
    file:write(table.concat(frontmatter, "\n"))
    file:close()
  end

  vim.cmd.edit(full_path)
end

vim.api.nvim_create_user_command("DailyNote", create_daily_note, {
  desc = "Create or open daily note (YYYY-MM-DD.md)",
})

-- =============================================================================
-- Lua: 2-space indentation (tabstop, softtabstop, shiftwidth, expandtab)
-- =============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})

-- =============================================================================
-- Diff mode: line numbers and custom statuscolumn
-- Enabled on VimEnter for all windows, applied per-window on BufWinEnter/WinEnter.
-- The statuscolumn function renders colored diff markers (add / change / delete).
-- =============================================================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.opt.diff:get() then
      local fmt = '%{%v:lua.require("configs.utils").statuscolumn()%}'
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        vim.wo[win].number = true
        vim.wo[win].relativenumber = false
        vim.wo[win].statuscolumn = fmt
      end
    end
  end,
})

-- set per-window statuscolumn based on diff state
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    if vim.wo.diff then
      vim.wo.number = true
      vim.wo.relativenumber = false
      vim.wo.statuscolumn = '%{%v:lua.require("configs.utils").statuscolumn()%}'
    else
      vim.wo.statuscolumn = ""
    end
  end,
})

-- dim inactive windows
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("dim"),
  callback = function()
    if require("configs.utils").is_diff_mode() then return end
    require("configs.dim").setup()
  end,
})
