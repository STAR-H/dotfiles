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

-- 在保存文件前触发替换
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.md",
  callback = update_modified_timestamp,
})
