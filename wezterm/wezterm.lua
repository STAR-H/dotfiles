local wezterm = require('wezterm')
local act = wezterm.action
local config = {}

-- platform
local platform = {is_mac = false, is_win = false, is_linux = false}
local wezterm = require 'wezterm'

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then -- Windows
  platform.is_win = true
elseif wezterm.target_triple == 'aarch64-apple-darwin' then -- macOS (Apple Silicon)
  platform.is_mac = true
elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then -- Linux
  platform.is_linux = true
end


if platform.is_win then
  config.default_prog = { 'wsl.exe', '-d', 'Ubuntu-20.04' }
  -- TODO: not test yet
  config.launch_menu = {
      { label = 'PowerShell Desktop', args = { 'powershell' } },
      { label = 'Command Prompt', args = { 'cmd' } },
   }
end

-- scheme
config.color_scheme = 'Dracula'

-- appearance
config.hide_tab_bar_if_only_one_tab = true
config.enable_scroll_bar = false
if platform.is_win then
  bg_image = "C:\\Users\\hanll9\\Pictures\\bk_fengling.png"
end
  config.background = {
    {
      source = { File = bg_image },
      horizontal_align = 'Center',
    },
    {
      source = { Color = "#1e1f29" },
      height = '100%',
      width = '100%',
      opacity = 0.9,
    },
  }
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "TITLE|RESIZE"

-- font
-- TODO: the end of font is not working
config.font_size = 9
config.line_height = 1.1
config.font = wezterm.font { family = 'Hack Nerd Font' }

-- clipboard

-- misc
config.audible_bell = "Disabled"
config.window_close_confirmation = 'NeverPrompt'
config.scrollback_lines = 20000

-- key mapping
config.disable_default_key_bindings = false

config.keys = {
  { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
  -- copy/paste
  { key = 'c',          mods = 'ALT',  action = act.CopyTo('Clipboard') },
  { key = 'v',          mods = 'ALT',  action = act.PasteFrom('Clipboard') },
}
-- Mousing bindings
config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
}



return config
