---lazy.nvic> plugin manager configuration.
---Pins plugin versions via lockfile (pin=true). Disabled change detection
---to avoid reload prompts when editing config files.
return {
-- all plugins lazy-loaded by default, versions pinned via lazy-lock.json
defaults = { lazy = true, pin = true },

-- disable automatic update checks
checker = { enabled = false },

-- disable config change detection notifications
change_detection = {
  enabled = false, -- don't auto-reload on config changes
  notify = false,  -- don't show notification on config changes
},

-- lazy.nvim UI icons
ui = {
  icons = {
    ft = "",
    lazy = "󰂠 ",
    loaded = "",
    not_loaded = "",
  },
},

-- disable unused built-in plugins for faster startup
performance = {
  rtp = {
    disabled_plugins = {
      "2html_plugin",
      "tohtml",
      "getscript",
      "getscriptPlugin",
      "gzip",
      "logipat",
      "netrw",
      "netrwPlugin",
      "netrwSettings",
      "netrwFileHandlers",
      "matchit",
      "tar",
      "tarPlugin",
      "rrhelper",
      "spellfile_plugin",
      "vimball",
      "vimballPlugin",
      "zip",
      "zipPlugin",
      "tutor",
      "rplugin",
      "syntax",
      "synmenu",
      "optwin",
      "compiler",
      "bugreport",
      "ftplugin",
    },
  },
},
}
