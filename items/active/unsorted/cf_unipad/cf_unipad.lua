function activate(fireMode, shiftHeld)
    if shiftHeld then
        if fireMode == "primary" then
            activeItem.interact("scriptPane", "interface/scripted/cf_codex/cf_codex.config")
        elseif fireMode == "alt" then
            activeItem.interact("scriptPane", "interface/scripted/cf_collections/cf_collections.config")
        end
    else
        activeItem.interact("scriptPane", "/interface/scripted/collections/collectionsgui.config")
    end
end