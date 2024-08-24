function update()
    if not fireableItem.coolingDown() and fireableItem.firing() then
        for _, playerId in pairs(world.playerQuery(fireableItem.ownerAimPosition(), 256)) do
            if world.entityHandItem(playerId, "primary") == item.name() or world.entityHandItem(playerId, "alt") == item.name() then
                local dir = root.itemConfig(item.name()).directory

                local length = string.len(item.name()) - 6
                local codex = string.sub(item.name(), 1, length)

                local file = dir .. codex .. ".codex"

                world.sendEntityMessage(playerId, "cf_learncodex", file)
            end
        end
    end
end