require "/scripts/util.lua"

function init()
    message.setHandler("cf_learncodex", learnCodexHandler)
    removeInvalidCodices()

    local cfg = root.assetJson("/player.config")
    local defaultCodices = cfg.defaultCodexes[player.species()] or {}

    for _, codex in pairs(defaultCodices) do
        learnCodex(codex)
    end
end

function learnCodexHandler(_, _, name)
    learnCodex(name)
end

function learnCodex(name)
    local knownCodices = player.getProperty("cf.knownCodices") or {}

    if not contains(knownCodices, name) then
        table.insert(knownCodices, name)
        player.setProperty("cf.knownCodices", knownCodices)
        return true
    end

    return false
end

function removeInvalidCodices()
    local knownCodices = player.getProperty("cf.knownCodices") or {}

    for c, codex in pairs(knownCodices) do
        if not root.itemConfig(codex .. "-codex") then
            table.remove(knownCodices, c)
        end
    end

    player.setProperty("cf.knownCodices", knownCodices)
end