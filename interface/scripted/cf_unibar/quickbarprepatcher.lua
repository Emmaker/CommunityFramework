-- Taken verbatim from https://github.com/Silverfeelin/Starbound-Quickbar-Mini/blob/master/sys/stardust/quickbar/conditions.lua
-- Following code is licensed under MIT
conditions = conditions or { }
local function nullfunc() end
function condition(id, ...) return (condition[id] or nullfunc)(...) end

----------------
-- conditions --
----------------

function conditions.any(...)
    for _, c in pairs{...} do if condition(table.unpack(c)) then return true end end
    return false
end
function conditions.all(...)
    for _, c in pairs{...} do if not condition(table.unpack(c)) then return false end end
    return true
end
conditions["not"] = function(...) return not condition(...) end

function conditions.admin() return player.isAdmin() end
function conditions.statPositive(stat) return status.statPositive(stat) end
function conditions.statNegative(stat) return not status.statPositive(stat) end
function conditions.species(species) return player.species() == species end
function conditions.ownShip() return player.worldId() == player.ownShipWorldId() end
function conditions.hasCompletedQuest(questId) return player.hasCompletedQuest(questId) end

function conditions.configExists(key) return root.assetJson(key) ~= nil end

-- Original code starts here

pPopulateLists = populateLists
function populateLists()
  pPopulateLists()

  for _, configItem in pairs(root.assetJson("/quickbar/icons.json").items) do
    if not configItem.condition or condition(table.unpack(configItem.condition)) then
      local item = widget.addListItem(self.list)

      widget.setImage(string.format("%s.%s.icon", self.list, item), configItem.icon)
      widget.setText(string.format("%s.%s.name", self.list, item), configItem.label)
      widget.setData(string.format("%s.%s", self.list, item), { "/interface/scripted/cf_unibar/functions/cf_quickbaractions.lua", "cf_action", configItem.action })
    end
  end
end