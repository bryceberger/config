-- @type Wezterm
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  { family = 'Maple Mono NF', harfbuzz_features = {} }
})

config.color_scheme = 'Catppuccin Mocha'
local colors = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']

---@param tab_info TabInformation
---@return string
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

local PCT_GLYPHS = {
  wezterm.nerdfonts.md_circle_slice_1,
  wezterm.nerdfonts.md_circle_slice_2,
  wezterm.nerdfonts.md_circle_slice_3,
  wezterm.nerdfonts.md_circle_slice_4,
  wezterm.nerdfonts.md_circle_slice_5,
  wezterm.nerdfonts.md_circle_slice_6,
  wezterm.nerdfonts.md_circle_slice_7,
  wezterm.nerdfonts.md_circle_slice_8,
}
local function pct_glyph(pct)
  local slot = math.floor(pct / 100 * #PCT_GLYPHS)
  -- local slot = math.floor(pct / (100 / #PCT_GLYPHS))
  -- local slot = math.floor(pct / 12)
  return PCT_GLYPHS[math.min(slot + 1, #PCT_GLYPHS)]
end

wezterm.on('format-tab-title', function(tab)
  local progress = tab.active_pane.progress or 'None'
  local title = tab_title(tab)
  local elements = {
    { Background = { Color = colors.background } },
    { Text = ' ' },
    { Background = 'Default' },
  }

  if progress ~= 'None' then
    ---@type number|nil
    ---@diagnostic disable-next-line: undefined-field
    local percent = progress.Percentage
    ---@type number|nil
    ---@diagnostic disable-next-line: undefined-field
    local error = progress.Error
    local p = percent or error

    if p ~= nil then
      local color = error ~= nil and 'Red' or 'Green'
      table.insert(elements, { Foreground = { AnsiColor = color } })
      table.insert(elements, { Text = pct_glyph(p) .. ' ' })
      table.insert(elements, { Foreground = { Color = colors.foreground } })
    end
  end

  table.insert(elements, { Text = title .. ' ' })

  return elements
end)

---@param url Url|nil
---@return string|nil
local function get_cwd(url)
  if url == nil then
    return nil
  end

  if url.scheme == "file" then
    return url.file_path
  elseif url.scheme == "kitty-shell-cwd" then
    return url.path
  end
end

---@param repo_dir string
---@param ... string
local function run_jj(repo_dir, ...)
  local repo = '-R' .. repo_dir
  return wezterm.run_child_process {
    'env', 'JJ_CONFIG=/dev/null',
    'jj', repo, '--ignore-working-copy', "--color=always", ...
  }
end

wezterm.on('update-status', function(window, pane)
  local elements = {}

  local url = pane:get_current_working_dir()
  ---@diagnostic disable-next-line: cast-type-mismatch
  ---@cast url Url|nil
  local cwd = get_cwd(url)
  if cwd ~= nil then
    local function insert(success, stdout)
      if not success then return end
      table.insert(elements, { Text = stdout .. ' ' })
    end

    insert(run_jj(cwd, 'log', '--no-graph', '-r@', '-T', [[
      separate(" ",
        if(empty, label("empty", "(empty)")),
        if(description,
          description.first_line(),
          label(if(empty, "empty"), description_placeholder),
        ),
      )
    ]]))

    -- insert(run_jj(cwd, 'op', 'log', '--no-graph', '-n1', '-T', 'id.short()'))
  end

  window:set_right_status(wezterm.format(elements))
end)

config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 20
config.colors = {
  tab_bar = {
    background = colors.background,
    active_tab = {
      bg_color = '#313244',
      fg_color = colors.foreground,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = colors.background,
      fg_color = colors.foreground,
    },
    new_tab = {
      bg_color = colors.background,
      fg_color = colors.background,
    }
  }
}

config.keys = {
  { mods = 'CTRL', key = 't', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
}

return config
