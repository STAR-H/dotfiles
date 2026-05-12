---Platform detection module.
---Provides centralized OS checks for plugin enabled conditions.
---Replaces scattered `vim.loop.os_uname()` calls with `vim.uv`.
---@class Platform
---@field is_macos   boolean
---@field is_linux   boolean
---@field is_windows boolean
local M       = {}

local sysname = vim.uv.os_uname().sysname

M.is_macos    = sysname == "Darwin"
M.is_linux    = sysname == "Linux"
M.is_windows  = sysname == "Windows_NT"
M.is_unix     = M.is_macos or M.is_linux

return M
