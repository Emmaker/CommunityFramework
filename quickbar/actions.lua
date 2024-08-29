actions = actions or { }
function action(id, ...) return actions[id] and actions[id](...) end

function actions.changeMode()
  self.mode = self.mode == "compact" and "full" or "compact"
  populateLists()
end

function actions.sail()
  player.interact("OpenAiInterface")
end

function actions.pane(cfg)
  if type(cfg) ~= "table" then cfg = { config = cfg } end
  player.interact(cfg.type or "ScriptPane", cfg.config)
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