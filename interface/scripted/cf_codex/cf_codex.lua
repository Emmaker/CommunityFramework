require "/scripts/util.lua"

function init()
    self.tabsList = "scrollAreaTabs.bookTabList"
    self.list = "scrollArea.bookList"

    self.currentCodices = {}
    self.currentContents = {}

    self.currentTab = false

    self.currentPage = 0
    self.maxPages = 0

    populateTabsList()
    widget.clearListItems(self.list)
    widget.setText("selectLabel", "Category")
    widget.setText("pageNum", "0 of 0")
    widget.setText("titleLabel", "")
    widget.setText("pageText", "")
end

function populateTabsList()
    widget.clearListItems(self.tabsList)
    tabs = config.getParameter("codexTabs")
  
    for _, tab in pairs(tabs) do
      local item = widget.addListItem(self.tabsList)
  
      widget.setImage(string.format("%s.%s.icon", self.tabsList, item), tab.deselectIcon)
      widget.setData(string.format("%s.%s", self.tabsList, item), { tab.name, tab.selectIcon, tab.deselectIcon })
    end
end

function populateList()
    widget.clearListItems(self.list)
    self.categoryName = widget.getData(string.format("%s.%s", self.tabsList, widget.getListSelected(self.tabsList)))[1]

    if self.categoryName then
        self.knownCodices = player.getProperty("cf.knownCodices") or {}
        widget.setText("selectLabel", "Choose " .. self.categoryName:gsub("^%l", string.upper) .. " Codex")

        if self.categoryName == "other" then
            for _, codex in pairs(self.knownCodices) do
                local dir = root.itemConfig(codex .. "-codex").directory
                local data = root.assetJson(dir .. codex .. ".codex")
                if not data.species then
                    local item = widget.addListItem(self.list)

                    widget.setImage(string.format("%s.%s.icon", self.list, item), dir .. data.icon)
                    widget.setText(string.format("%s.%s.name", self.list, item), data.title)
                    widget.setData(string.format("%s.%s", self.list, item), data.longContentPages or data.contentPages)
                end
            end
        else
            for _, codex in pairs(self.knownCodices) do
                local dir = root.itemConfig(codex .. "-codex").directory
                local data = root.assetJson(dir .. codex .. ".codex")
                if data.species == self.categoryName then
                    local item = widget.addListItem(self.list)

                    widget.setImage(string.format("%s.%s.icon", self.list, item), dir .. data.icon)
                    widget.setText(string.format("%s.%s.name", self.list, item), data.title)
                    widget.setData(string.format("%s.%s", self.list, item), data.longContentPages or data.contentPages)
                end
            end
        end
    end
end

function selectCategory()
    if self.currentTab then
        widget.setImage(string.format("%s.icon", self.currentTab), widget.getData(self.currentTab)[3])
      end
      
      local selectedItem = widget.getListSelected(self.tabsList)
      if not selectedItem then return end
    
      self.currentTab = string.format("%s.%s", self.tabsList, selectedItem)
      widget.setImage(string.format("%s.icon", self.currentTab), widget.getData(self.currentTab)[2])
      populateList()
end

function selectCodex()
    self.currentContents = widget.getData(string.format("%s.%s", self.list, widget.getListSelected(self.list)))

    if not self.currentContents then return end

    self.currentPage = 1
    self.maxPages = #self.currentContents

    widget.setText("pageText", self.currentContents[self.currentPage])
    widget.setText("pageNum", self.currentPage .. " of " .. self.maxPages)
end

function prevPage()
    if self.currentContents then
        self.currentPage = util.clamp(self.currentPage - 1, 1, self.maxPages)

        widget.setText("pageText", self.currentContents[self.currentPage])
        widget.setText("pageNum", self.currentPage .. " of " .. self.maxPages)
    end
end

function nextPage()
    if self.currentContents then
        self.currentPage = util.clamp(self.currentPage + 1, 1, self.maxPages)

        widget.setText("pageText", self.currentContents[self.currentPage])
        widget.setText("pageNum", self.currentPage .. " of " .. self.maxPages)
    end
end