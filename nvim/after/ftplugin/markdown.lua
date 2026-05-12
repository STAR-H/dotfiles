-- auto-update "updated" field in YAML frontmatter on save
local function update_modified_timestamp()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local in_frontmatter = false
  for i, line in ipairs(lines) do
    if line:match("^---") then in_frontmatter = true end
    if in_frontmatter and line:match("^updated:") then
      lines[i] = "updated: " .. os.date("%Y-%m-%d %H:%M")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      break
    end
  end
end

-- delayed auto-save for markdown files (15s after leaving insert mode)
vim.api.nvim_create_augroup("MarkdownAutoSave", { clear = true })

local save_timer = nil -- debounce timer handle

-- trigger auto-save after leaving insert mode, modifying buffer, or losing focus
vim.api.nvim_create_autocmd({ "InsertLeave", "BufModifiedSet", "FocusLost" }, {
  group = "MarkdownAutoSave",
  pattern = "*.md",
  callback = function()
    -- cancel any pending save timer before starting a new one
    if save_timer then
      save_timer:stop()
      save_timer:close()
    end

    -- start a 15 seconds deferred save timer
    save_timer = vim.uv.new_timer()
    save_timer:start(15000, 0, vim.schedule_wrap(function()
      local current_mode = vim.api.nvim_get_mode().mode
      local is_normal_mode = current_mode == "n"
      -- guard: only save if still a valid markdown buffer in normal mode
      if vim.bo.filetype == "markdown" and vim.api.nvim_buf_is_valid(0) and is_normal_mode and vim.bo.modified then
        -- do save and show brief notification
        vim.cmd("silent! update")
        vim.notify(" Auto Saved at " .. os.date("%H:%M:%S"), vim.log.levels.INFO, {
          timeout = 800,
        })
      end
      save_timer = nil
    end))
  end
})

-- cancel pending save when entering insert mode (avoid saving mid-edit)
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "MarkdownAutoSave",
  pattern = "*.md",
  callback = function()
    if save_timer then
      save_timer:stop()
      save_timer:close()
      save_timer = nil
    end
  end
})

-- update frontmatter "updated" timestamp before each write
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = update_modified_timestamp,
})

-- toggle "- [ ]" / "- [x]" checkbox on the current line
local function toggle_checkbox()
  local bufnr = 0
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

  if not line then
    return
  end

  -- match unchecked: "- [ ]", "* [ ]", or "+ [ ]" list items
  local new_line, count = line:gsub("^([%s]*[-*+]%s+)%[ %]", "%1[x]")
  if count == 0 then
    new_line, count = line:gsub("^([%s]*[-*+]%s+)%[x%]", "%1[ ]")
  end

  if count > 0 then
    vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { new_line })
  end
end

vim.keymap.set("n", "<cr>", toggle_checkbox, { desc = "Toggle markdown checkbox" })


-- spell check: disabled by default, en_us + cjk when enabled
vim.opt_local.spell = false
vim.opt_local.spelllang = { "en_us", "cjk" }

-- 2-space indentation for markdown
vim.opt_local.tabstop     = 2
vim.opt_local.shiftwidth  = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab   = true
