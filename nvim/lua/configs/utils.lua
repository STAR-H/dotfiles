---Utility functions for diff mode detection, diagnostics toggle,
---buffer closing, and dynamic foldcolumn.
local M = {}

---Check if running in diff mode (nvim -d)
function M.is_diff_mode()
  return vim.opt.diff:get()
end

---Toggle diagnostics on/off globally with notification
function M.toggle_diagnostics()
  if not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(true)
    vim.notify("Diagnostic Enabled!", vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    vim.notify("Diagnostic Disabled!", vim.log.levels.WARN)
  end
end

---Close current window if splits exist, otherwise close buffer
function M.close_buffer()
  local win_count = vim.fn.winnr("$")
  if win_count > 1 then
    vim.cmd("close")
  else
    vim.cmd("bd")
  end
end

---Dynamically show foldcolumn only when folds exist in the buffer
function M.update_foldcolumn()
  if not vim.wo.foldenable then
    vim.wo.foldcolumn = "0"
    return
  end

  local has_fold = false
  local line_count = vim.api.nvim_buf_line_count(0)
  for lnum = 1, line_count do
    if vim.fn.foldlevel(lnum) > 0 then
      has_fold = true
      break
    end
  end

  vim.wo.foldcolumn = has_fold and "1" or "0"
end

function M.statuscolumn()
  local lnum = vim.v.lnum
  if not vim.wo.diff then
    return "%=%l %C"
  end
  local hl_id = vim.fn.diff_hlID(lnum, 0)
  if hl_id > 0 then
    local name = vim.fn.synIDattr(vim.fn.synIDtrans(hl_id), "name")
    local map = {
      DiffAdd = "DiffAddNr",
      DiffChange = "DiffChangeNr",
      DiffDelete = "DiffDeleteNr",
      DiffModified = "DiffModifiedNr",
    }
    local hl = map[name] or "LineNr"
    return "%=%#" .. hl .. "#" .. string.format("%3d", lnum) .. " %*%C"
  end
  return "%=%#LineNr#" .. string.format("%3d", lnum) .. " %*%C"
end

function M.foldtext()
  local line = vim.fn.getline(vim.v.foldstart)
  local indent = line:match("^%s*") or ""
  local text = line:gsub("^%s*", "")
  local line_count = vim.v.foldend - vim.v.foldstart + 1

  return string.format("%s%d lines: %s", indent, line_count, text)
end

---Open current buffer in Obsidian desktop app via CLI.
---Requires $OBSIDIAN_VAULT env var pointing to a valid vault directory.
function M.obsidian_open()
  local platform = require("configs.platform")
  if not platform.is_macos then
    return
  end

  local vault_raw = vim.env.OBSIDIAN_VAULT
  if not vault_raw or vault_raw == "" then
    vim.notify("$OBSIDIAN_VAULT is not set", vim.log.levels.WARN)
    return
  end
  local vault = vim.fn.expand(vault_raw)

  if vim.fn.isdirectory(vault .. "/.obsidian") ~= 1 then
    vim.notify("Invalid obsidian vault (no .obsidian/): " .. vault, vim.log.levels.WARN)
    return
  end

  local bufpath = vim.fn.expand("%:p")
  if not bufpath or bufpath == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local vault_norm = vim.fs.normalize(vault)
  if #bufpath <= #vault_norm + 1 or string.sub(bufpath, 1, #vault_norm) ~= vault_norm then
    vim.notify("Current file is not under vault: " .. vault, vim.log.levels.WARN)
    return
  end
  local rel_path = string.sub(bufpath, #vault_norm + 2)

  if vim.fn.executable("obsidian") ~= 1 then
    vim.notify("obsidian CLI is not available", vim.log.levels.WARN)
    return
  end

  vim.fn.jobstart({ "obsidian", "open", "vault=" .. vault, "path=" .. rel_path }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local msg = vim.trim(table.concat(data, "\n"))
        if msg ~= "" then
          vim.notify(msg, vim.log.levels.INFO)
        end
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("obsidian open failed with exit code: " .. exit_code, vim.log.levels.ERROR)
      end
    end,
  })
end

---Create or open daily note under $OBSIDIAN_DAILY path.
---Creates YYYY-MM-DD.md with frontmatter if it does not exist.
function M.obsidian_daily()
  local platform = require("configs.platform")
  if not platform.is_macos then
    return
  end

  local daily_raw = vim.env.OBSIDIAN_DAILY
  if not daily_raw or daily_raw == "" then
    vim.notify("$OBSIDIAN_DAILY is not set", vim.log.levels.WARN)
    return
  end
  local daily_dir = vim.fn.expand(daily_raw)

  local filename = os.date("%Y-%m-%d") .. ".md"
  local full_path = daily_dir .. "/" .. filename

  if vim.fn.filereadable(full_path) == 1 then
    vim.cmd.edit(full_path)
    return
  end

  if vim.fn.isdirectory(daily_dir) ~= 1 then
    vim.notify("Daily directory does not exist: " .. daily_dir, vim.log.levels.WARN)
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
    " - daily-notes",
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

return M
