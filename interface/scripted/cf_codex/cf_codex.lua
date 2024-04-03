require "/scripts/util.lua"

function init()
    self.tabsList = "scrollAreaTabs.bookTabList"
    self.list = "scrollArea.bookList"

    self.currentContents = false
    self.currentTab = false

    self.currentPage = 0
    self.maxPages = 0

    populateTabsList()
    widget.clearListItems(self.list)
    widget.setText("selectLabel", "Category")
    widget.setText("pageNum", "0 of 0")
    widget.setText("titleLabel", "")
    widget.setText("pageText", "")

    widget.setVisible("prevButton", false)
    widget.setVisible("prevButtonDisabled", true)
    widget.setVisible("nextButton", false)
    widget.setVisible("nextButtonDisabled", true)
end

function populateTabsList()
    widget.clearListItems(self.tabsList)
    tabs = config.getParameter("codexTabs")
  
    for _, tab in pairs(tabs) do
      local item = widget.addListItem(self.tabsList)
  
      widget.setImage(string.format("%s.%s.icon", self.tabsList, item), tab.deselectIcon)
      widget.setData(string.format("%s.%s", self.tabsList, item), { tab.name, tab.species, tab.selectIcon, tab.deselectIcon })
    end
end

function populateList()
    widget.clearListItems(self.list)
    self.categoryName = widget.getData(string.format("%s.%s", self.tabsList, widget.getListSelected(self.tabsList)))[1]
    self.categorySpecies = widget.getData(string.format("%s.%s", self.tabsList, widget.getListSelected(self.tabsList)))[2]

    if self.categoryName and self.categorySpecies then
        local promise = world.sendEntityMessage(player.id(), "cf_getcodices")
        while not promise do end
        local result = promise:result()
        if not result then return end

        widget.setText("selectLabel", "Choose " .. self.categoryName .. " Codex")

        if self.categorySpecies == "other" then
            for _, codex in pairs(result) do
                local dir = root.itemConfig(codex .. "-codex").directory
                local data = root.assetJson(dir .. codex .. ".codex")
                if not data.species then
                    local item = widget.addListItem(self.list)

                    widget.setImage(string.format("%s.%s.icon", self.list, item), util.absolutePath(dir, data.icon))
                    widget.setText(string.format("%s.%s.name", self.list, item), data.title)
                    widget.setData(string.format("%s.%s", self.list, item), { data.longContentPages or data.contentPages, data.title, codex })
                end
            end
        else
            for _, codex in pairs(result) do
                local dir = root.itemConfig(codex .. "-codex").directory
                local data = root.assetJson(dir .. codex .. ".codex")
                if data.species == self.categorySpecies then
                    local item = widget.addListItem(self.list)

                    widget.setImage(string.format("%s.%s.icon", self.list, item), util.absolutePath(dir, data.icon))
                    widget.setText(string.format("%s.%s.name", self.list, item), data.title)
                    widget.setData(string.format("%s.%s", self.list, item), { data.longContentPages or data.contentPages, data.title, codex })
                end
            end
        end
    end
end

function selectCategory()
    if self.currentTab then
        widget.setImage(string.format("%s.icon", self.currentTab), widget.getData(self.currentTab)[4])
      end
      
      local selectedItem = widget.getListSelected(self.tabsList)
      if not selectedItem then return end
    
      self.currentTab = string.format("%s.%s", self.tabsList, selectedItem)
      widget.setImage(string.format("%s.icon", self.currentTab), widget.getData(self.currentTab)[3])
      populateList()
end

function selectCodex()
    if widget.getListSelected(self.list) then
        self.currentContents = widget.getData(string.format("%s.%s", self.list, widget.getListSelected(self.list)))[1]
        self.currentTitle = widget.getData(string.format("%s.%s", self.list, widget.getListSelected(self.list)))[2]

        if not self.currentContents then return end

        self.currentPage = 1
        self.maxPages = #self.currentContents

        widget.setText("pageText", self.currentContents[self.currentPage])
        widget.setText("pageNum", self.currentPage .. " of " .. self.maxPages)
        widget.setText("titleLabel", self.currentTitle)

        widget.setVisible("prevButton", false)
        widget.setVisible("prevButtonDisabled", true)
        widget.setVisible("nextButton", self.currentPage ~= self.maxPages)
        widget.setVisible("nextButtonDisabled", self.currentPage == self.maxPages)
    end
end

function prevPage()
    if self.currentContents then
        self.currentPage = util.clamp(self.currentPage - 1, 1, self.maxPages)

        widget.setText("pageText", self.currentContents[self.currentPage])
        widget.setText("pageNum", self.currentPage .. " of " .. self.maxPages)

        widget.setVisible("prevButton", self.currentPage ~= 1)
        widget.setVisible("prevButtonDisabled", self.currentPage == 1)
        widget.setVisible("nextButton", self.currentPage ~= self.maxPages)
        widget.setVisible("nextButtonDisabled", self.currentPage == self.maxPages)
    end
end

function nextPage()
    if self.currentContents then
        self.currentPage = util.clamp(self.currentPage + 1, 1, self.maxPages)

        widget.setText("pageText", self.currentContents[self.currentPage])
        widget.setText("pageNum", self.currentPage .. " of " .. self.maxPages)

        widget.setVisible("prevButton", self.currentPage ~= 1)
        widget.setVisible("prevButtonDisabled", self.currentPage == 1)
        widget.setVisible("nextButton", self.currentPage ~= self.maxPages)
        widget.setVisible("nextButtonDisabled", self.currentPage == self.maxPages)
    end
end