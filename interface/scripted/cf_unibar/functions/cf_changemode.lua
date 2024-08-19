-- Actions
function changeListMode()
    if self.listMode == "full" then
        self.listMode = "compact"
    else
        self.listMode = "full"
    end

    populateLists()
end