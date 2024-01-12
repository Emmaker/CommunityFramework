-- Conditions
function isOnShip()
    return (world.type() == "unknown")
end

function isAdmin()
    return player.isAdmin()
end

-- Actions
function openSail()
    player.interact("OpenAiInterface")
    pane.dismiss()
end

function openInterface(interface)
    player.interact("ScriptPane", interface)
    pane.dismiss()
end