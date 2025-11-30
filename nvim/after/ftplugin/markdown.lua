local function update_modified_timestamp()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local in_frontmatter = false
  for i, line in ipairs(lines) do
    if line:match("^---") then in_frontmatter = true end
    if in_frontmatter and line:match("^modified:") then
      lines[i] = "modified: " .. os.date("%Y-%m-%d %H:%M")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      break
    end
  end
end

-- 仅针对 Markdown 文件的延迟自动保存
vim.api.nvim_create_augroup("MarkdownAutoSave", { clear = true })

local save_timer = nil -- 保存定时器对象

-- 退出插入模式后触发
vim.api.nvim_create_autocmd({ "InsertLeave", "BufModifiedSet", "FocusLost" }, {
  group = "MarkdownAutoSave",
  pattern = "*.md",
  callback = function()
    -- 如果已有定时器则先取消
    if save_timer then
      save_timer:stop()
      save_timer:close()
    end

    -- 设置 1 秒延迟的定时器
    save_timer = vim.loop.new_timer()
    save_timer:start(3000, 0, vim.schedule_wrap(function()
      local current_mode = vim.api.nvim_get_mode().mode
      local is_normal_mode = current_mode == "n"
      -- 检查是否仍是 Markdown 文件且缓冲区有效
      if vim.bo.filetype == "markdown" and vim.api.nvim_buf_is_valid(0) and is_normal_mode and vim.bo.modified then
        -- 保存并显示提示
        vim.cmd("silent! update")
        vim.notify(" Auto Saved at " .. os.date("%H:%M:%S"), vim.log.levels.INFO, {
          timeout = 800,
        })
      end
      save_timer = nil
    end))
  end
})

-- 进入插入模式时取消未触发的保存（可选）
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

-- 在保存文件前触发替换
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = update_modified_timestamp,
})

-- enable spell check
vim.opt_local.spell = true
vim.opt_local.spelllang = { "en_us", "cjk" }
