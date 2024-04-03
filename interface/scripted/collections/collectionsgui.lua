require "/scripts/util.lua"

function init()
    self.fullList = "scrollArea.fullList"
    self.compactList = "scrollArea.compactList"

    self.listMode = "full"
    self.listConfig = config.getParameter("listConfig")

    populateLists()
end

function populateLists()
    widget.clearListItems(self.fullList)
    widget.clearListItems(self.compactList)

    if self.listMode == "full" then
        for _, configItem in pairs(self.listConfig) do
            if configItem.condition then
                require(configItem.condition[1])
                if _ENV[configItem.condition[2]]() then
                    local item = widget.addListItem(self.fullList)

                    widget.setImage(string.format("%s.%s.icon", self.fullList, item), util.absolutePath("/interface/scripted/collections/", configItem.icon))
                    widget.setText(string.format("%s.%s.name", self.fullList, item), configItem.name)
                    widget.setData(string.format("%s.%s", self.fullList, item), configItem.action)
                end
            else
                local item = widget.addListItem(self.fullList)

                widget.setImage(string.format("%s.%s.icon", self.fullList, item), util.absolutePath("/interface/scripted/collections/", configItem.icon))
                widget.setText(string.format("%s.%s.name", self.fullList, item), configItem.name)
                widget.setData(string.format("%s.%s", self.fullList, item), configItem.action)
            end
        end
    elseif self.listMode == "compact" then
        for _, configItem in pairs(self.listConfig) do
            if configItem.condition then
                require(configItem.condition[1])
                if _ENV[configItem.condition[2]]() then
                    local item = widget.addListItem(self.compactList)

                    widget.setImage(string.format("%s.%s.icon", self.compactList, item), util.absolutePath("/interface/scripted/collections/", configItem.icon))
                    widget.setData(string.format("%s.%s", self.compactList, item), configItem.action)
                end
            else
                local item = widget.addListItem(self.compactList)

                widget.setImage(string.format("%s.%s.icon", self.compactList, item), util.absolutePath("/interface/scripted/collections/", configItem.icon))
                widget.setData(string.format("%s.%s", self.compactList, item), configItem.action)
            end
        end
    end
end

function selectItem()
    local selectedFunction = nil

    if self.listMode == "full" then
        selectedFunction = widget.getData(string.format("%s.%s", self.fullList, widget.getListSelected(self.fullList)))
    elseif self.listMode == "compact" then
        selectedFunction = widget.getData(string.format("%s.%s", self.compactList, widget.getListSelected(self.compactList)))
    end

    if selectedFunction then 
        require(selectedFunction[1])
        _ENV[selectedFunction[2]](selectedFunction[3])
    end
end