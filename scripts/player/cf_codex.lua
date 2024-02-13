require "/scripts/util.lua"

function init()
    message.setHandler("cf_learncodex", learnCodex)

    local cfg = root.assetJson("/player.config")
    local defaultCodices = cfg.defaultCodexes[player.species()] or {}

    for _, codex in pairs(defaultCodices) do
        learnCodex(codex .. "-codex")
    end
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