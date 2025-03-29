-- load nvchad autocmds
pcall(require, "nvchad.autocmds")

local function augroup(name)
  return vim.api.nvim_create_augroup("star_" .. name, { clear = true })
end
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Open the file to automatically locate to the last edited position
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

-- Set the terminal buffer when terminal open
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "nvcheatsheet",
    "nvdash"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        if #vim.api.nvim_list_wins() > 1 then
          vim.cmd("close")
        else
          vim.cmd("bdelete!") -- 仅删除缓冲区，不关闭窗口
        end
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
      vim.keymap.set("n", "<ESC>", function()
        if #vim.api.nvim_list_wins() > 1 then
          vim.cmd("close")
        else
          vim.cmd("bdelete!") -- 仅删除缓冲区，不关闭窗口
        end
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- auto enable diagnostics in lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.diagnostic.enable(true) -- enable diagnostics in current buffer
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
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

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- quit diff mode when unmodified
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
  callback = function()
    if require("configs.utils").is_diff_mode() then
      vim.keymap.set("n", "q", function()
        if not vim.bo.modified then
          vim.cmd("qa") -- 退出所有窗口
        else
          vim.notify("Buffer has unsaved changes. Use `:qa!` to quit without saving.", vim.log.levels.WARN)
        end
      end, { buffer = true, desc = "Quit if no changes" })
    end
  end,
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  callback = function()
    vim.fn.setreg("/", "") -- reset search history register
  end
})

-- change auto indent for c/cpp file 4 space, default is 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
      vim.opt.shiftwidth = 4
      vim.bo.commentstring = "// %s"
  end,
})

-- dynamic add foldcolumn
vim.api.nvim_create_autocmd({"BufWinEnter", "CursorHold", "InsertLeave"}, {
  callback = function()
    require("configs.utils").update_foldcolumn()
  end
})

-- only enable indent by below filetype
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp", "lua", "python" },
  callback = function()
    local status, snacks_indent = pcall(require, "snacks.indent")
    if status then
      snacks_indent.enable()
    end
  end,
})

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
