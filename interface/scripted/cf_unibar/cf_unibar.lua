require "/scripts/util.lua"

function init()
    self.fullList = "scrollArea.fullList"
    self.compactList = "scrollArea.compactList"

    self.listMode = config.getParameter("defaultListMode")
    self.listConfig = config.getParameter("listConfig")

    table.sort(self.listConfig, function(a, b)
        return (a.weight or 0) > (b.weight or 0)
    end)

    populateLists()
end

function populateLists()
    widget.clearListItems(self.fullList)
    widget.clearListItems(self.compactList)

    self.list = self.listMode == "full" and self.fullList or self.compactList

    for _, configItem in pairs(self.listConfig) do
        if configItem.condition then
            require(configItem.condition[1])
            if not _ENV[configItem.condition[2]]() then
                goto postadd
            end
        end

        local item = widget.addListItem(self.list)

        widget.setImage(string.format("%s.%s.icon", self.list, item), configItem.icon)
        widget.setText(string.format("%s.%s.name", self.list, item), configItem.name)
        widget.setData(string.format("%s.%s", self.list, item), configItem.action)

        ::postadd::
    end
end

function selectItem()
    self.list = self.listMode == "full" and self.fullList or self.compactList
    local selected = widget.getData(string.format("%s.%s", self.list, widget.getListSelected(self.list)))

    if selected then
        require(selected[1])
        _ENV[selected[2]](selected[3] or nil)
    end
end