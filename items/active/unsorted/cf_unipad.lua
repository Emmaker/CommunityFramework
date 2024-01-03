function activate(fireMode, shiftHeld)
    if fireMode == "primary" then
        if shiftHeld then
            -- Codex
        else
            if world.type() == "unknown" then
                activeItem.interact("scriptPane", "/interface/ai/cf_ai.config")
            else
                -- Unipad
            end
        end
    elseif fireMode == "alt" then
        if shiftHeld then
            activeItem.interact("scriptPane", "/interface/scripted/collections/collectionsgui.config")
        else
            -- Unipad
        end
    end
end