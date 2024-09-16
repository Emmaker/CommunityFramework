function update()
    if self.doOnce then
        if fireableItem.coolingDown() or not fireableItem.firing() then 
            self.doOnce = false 
        end
    elseif not fireableItem.coolingDown() and fireableItem.firing() then
        for _, playerId in pairs(world.playerQuery(fireableItem.ownerAimPosition(), 256)) do
            if world.entityHandItem(playerId, "primary") == item.name() or world.entityHandItem(playerId, "alt") == item.name() then
                local file = root.itemConfig(item.name()).directory -- directory
                    .. string.sub(item.name(), 1, string.len(item.name()) - 6) -- name
                    .. ".codex"

                world.sendEntityMessage(playerId, "cf_learncodex", file)

                self.doOnce = true
            end
        end
    end
end