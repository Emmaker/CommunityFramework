function cf_action(cf_actions)
  action(table.unpack(cf_actions))
  pane.dismiss()
end

-- Taken almost verbatim from https://github.com/Silverfeelin/Starbound-Quickbar-Mini/blob/master/sys/stardust/quickbar/quickbar.lua
-- Following code is licensed under MIT
actions = actions or { }
local function nullfunc() end
function action(id, ...) return (actions[id] or nullfunc)(...) end

function actions.pane(cfg)
    if type(cfg) ~= "table" then cfg = { config = cfg } end
    player.interact(cfg.type or "ScriptPane", cfg.config)
end

function actions.exec(script, ...)
    if type(script) ~= "string" then return nil end
    params = {...} -- pass any given parameters to the script
    _SBLOADED[script] = nil require(script) -- force execute every time
    params = nil -- clear afterwards for cleanliness
end