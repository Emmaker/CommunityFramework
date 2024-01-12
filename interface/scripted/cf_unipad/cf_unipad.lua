function init()
    self.fullList = "scrollArea.fullList"
    self.compactList = "scrollArea.compactList"
    self.text = "textScrollArea.text"

    widget.setText(self.text, "Select any item on the left to continue...")

    changeListMode()
    populateLists()
end

function populateLists()
    widget.clearListItems(self.fullList)
    widget.clearListItems(self.compactList)

    self.listMode = widget.getSelectedData("listModeTabs")
    if self.listMode == "full" then
        for _, configItem in pairs(config.getParameter("listConfig")) do
            if configItem.condition then
                require(configItem.condition[1])
                if _ENV[configItem.condition[2]]() then
                    local item = widget.addListItem(self.fullList)

                    widget.setImage(string.format("%s.%s.icon", self.fullList, item), configItem.icon)
                    widget.setText(string.format("%s.%s.name", self.fullList, item), configItem.name)
                    widget.setData(string.format("%s.%s", self.fullList, item), configItem.action)
                end
            else
                local item = widget.addListItem(self.fullList)

                widget.setImage(string.format("%s.%s.icon", self.fullList, item), configItem.icon)
                widget.setText(string.format("%s.%s.name", self.fullList, item), configItem.name)
                widget.setData(string.format("%s.%s", self.fullList, item), configItem.action)
            end
        end
    elseif self.listMode == "compact" then
        for _, configItem in pairs(config.getParameter("listConfig")) do
            if configItem.condition then
                require(configItem.condition[1])
                if _ENV[configItem.condition[2]]() then
                    local item = widget.addListItem(self.compactList)

                    widget.setImage(string.format("%s.%s.icon", self.compactList, item), configItem.icon)
                    widget.setData(string.format("%s.%s", self.compactList, item), configItem.action)
                end
            else
                local item = widget.addListItem(self.compactList)

                widget.setImage(string.format("%s.%s.icon", self.compactList, item), configItem.icon)
                widget.setData(string.format("%s.%s", self.compactList, item), configItem.action)
            end
        end
    end
end

function changeListMode()
    self.listMode = widget.getSelectedData("listModeTabs")
    if self.listMode == "full" then
        widget.setVisible("scrollArea.fullList", true)
        widget.setVisible("scrollArea.compactList", false)

        populateLists()
    elseif self.listMode == "compact" then
        widget.setVisible("scrollArea.fullList", false)
        widget.setVisible("scrollArea.compactList", true)

        populateLists()
    end
end

function selectItem()
    self.listMode = widget.getSelectedData("listModeTabs")
    if self.listMode == "full" then
        local selectedFunction = widget.getData(string.format("%s.%s", self.fullList, widget.getListSelected(self.fullList)))
        if not selectedFunction then return end
        require(selectedFunction[1])

        local funcReturn = _ENV[selectedFunction[2]](selectedFunction[3])
        if funcReturn and type(funcReturn) == "string" then
            widget.setText(self.text, funcReturn)
        end
    elseif self.listMode == "compact" then
        local selectedFunction = widget.getData(string.format("%s.%s", self.compactList, widget.getListSelected(self.compactList)))
        if not selectedFunction then return end
        require(selectedFunction[1])
        
        local funcReturn = _ENV[selectedFunction[2]](selectedFunction[3])
        if funcReturn and type(funcReturn) == "string" then
            widget.setText(self.text, funcReturn)
        end
    end
end