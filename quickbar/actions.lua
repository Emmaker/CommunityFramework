function actions.changeMode()
  self.mode = self.mode == "compact" and "full" or "compact"
  populateLists()
end

function actions.sail()
  player.interact("openAiInterface")
end

function actions.pane(cfg)
  if type(cfg) ~= "table" then cfg = { config = cfg } end
  player.interact(cfg.type or "ScriptPane", cfg.config)
end

function actions.ui(cfg, data) -- metaGUI
  if not pcall(function() root.assetJson("/metagui/registry.json") end) then return end
  player.interact("ScriptPane", { gui = { }, scripts = { "/metagui.lua" }, config = cfg, data = data })
end

function actions.teleport(cfg)
  if type(cfg) ~= "string" then return end
  player.interact("OpenTeleportDialog", cfg)
end

function actions.exec(script, ...)
  if type(script) ~= "string" then return end
  params = { ... }
  _SBLOADED[script] = nil require(script)
  params = nil
end

-- Legacy function, don't know what the fuck it does
function actions._legacy(s)
  local m, e = (function() local it = string.gmatch(s, "[^:]+") return it(), it() end)()
  local mf = string.format("/quickbar/%s.lua", m)
  module = { }
  _SBLOADED[mf] = nil require(mf)
  module[e]() module = nil
end
