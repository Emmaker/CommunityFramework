function update()
    if not fireableItem.coolingDown() and fireableItem.firing() then
        for _, playerId in pairs(world.playerQuery(fireableItem.ownerAimPosition(), 256)) do
            if world.entityHandItem(playerId, "primary") == item.name() or world.entityHandItem(playerId, "alt") == item.name() then
                sb.logInfo("Unlocking %s for %s", item.name(), playerId)
            end
        end
    end
end