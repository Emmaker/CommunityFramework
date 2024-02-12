function activate(fireMode, shiftHeld)
    if shiftHeld then
        if fireMode == "primary" then
            -- New Codex
        elseif fireMode == "alt" then
            activeItem.interact("scriptPane", "interface/scripted/cf_collections/cf_collections.config")
        end
    else
        activeItem.interact("scriptPane", "/interface/scripted/collections/collectionsgui.config")
    end
end