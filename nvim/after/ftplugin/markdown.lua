local function replace_placeholders()
  -- 仅处理 Markdown 文件
  if vim.bo.filetype ~= "markdown" then return end

  -- 读取当前文件内容
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local modified = false

  -- 定义占位符和对应的替换值
  local placeholders = {
    ["${{modified_time}}"] = os.date("%Y-%m-%d %H:%M"),
  }

  -- 遍历每一行，替换所有占位符
  for i, line in ipairs(lines) do
    for placeholder, value in pairs(placeholders) do
      if line:find(placeholder, 1, true) then  -- 精确匹配占位符
        lines[i] = line:gsub(placeholder, value)
        modified = true
      end
    end
  end

  -- 如果有修改，则写回文件
  if modified then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
end

-- 在保存文件前触发替换
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = replace_placeholders,
})
