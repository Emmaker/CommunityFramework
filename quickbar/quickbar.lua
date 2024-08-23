require "/scripts/util.lua"
require "/quickbar/conditions.lua"
require "/quickbar/actions.lua"

local colorSub = {
  [ "^essential;" ] = "^#ffb133;",
  [ "^admin;" ] = "^#bf7fff;",
}

function init()
  self.fullList = "scrollArea.fullList"
  self.compactList = "scrollArea.compactList"

  self.mode = self.mode or "full"
  self.icons = { }

  local items = root.assetJson("/quickbar/icons.json").items
  for _, item in pairs(items) do
    item.sort = string.lower(string.gsub(item.label, "(%b^;)", ""))
    item.label = string.gsub(item.label, "(%b^;)", colorSub)
    item.weight = item.weight or 0
    table.insert(self.icons, item)
  end

  table.sort(self.icons, function(a, b)
    return a.weight < b.weight or (a.weight == b.weight and a.sort < b.sort)
  end)

  populateLists()
end

function populateLists()
  widget.clearListItems(self.fullList)
  widget.clearListItems(self.compactList)

  widget.setVisible(self.fullList, self.mode == "full")
  widget.setVisible(self.compactList, self.mode == "compact")

  local list = self.mode == "full" and self.fullList or self.compactList

  for _, icon in pairs(self.icons) do
    if not icon.condition or condition(table.unpack(icon.condition)) then
      local item = list .. "." .. widget.addListItem(list)

      widget.setImage(item .. ".icon", icon.icon)
      widget.setText(item .. ".label", icon.label)
      widget.setData(item, { condition = icon.condition, action = icon.action, dismiss = icon.dismissQuickbar })
    end
  end
end

function selectIcon()
  local list = self.mode == "full" and self.fullList or self.compactList
  if not widget.getListSelected(list) then return end
  local selected = widget.getData(list .. "." .. widget.getListSelected(list))

  if not selected.condition or condition(table.unpack(selected.condition)) then
    action(table.unpack(selected.action))
    if selected.dismiss == nil or selected.dismiss then pane.dismiss() end
  end
end