require "/scripts/util.lua"

function init()
    message.setHandler("cf_learncodex", learnCodexHandler)
    message.setHandler("cf_getcodices", getCodices)
    message.setHandler("cf_setcodices", setCodices)

    self.knownCodices = player.getProperty("cf_knownCodices") or {}
    self.readCodices = player.getProperty("cf_readCodices") or {}

    local cfg = root.assetJson("/player.config")
    local defaultCodices = cfg.defaultCodexes[player.species()] or {}

    for _, codex in pairs(defaultCodices) do
        learnCodex(codex)
    end

    removeInvalidCodices()
end

function getCodices()
    return { self.knownCodices, self.readCodices }
end

function setCodices(_, _, readCodices)
    if type(readCodices) == "table" then
        self.readCodices = readCodices
    end
end

function learnCodexHandler(_, _, name)
    learnCodex(name)
end

function learnCodex(name)
    if not contains(self.knownCodices, name) then
        table.insert(self.knownCodices, name)
    end
end

function removeInvalidCodices()
    for c, codex in pairs(self.knownCodices) do
        if not root.itemConfig(codex .. "-codex") then
            table.remove(self.knownCodices, c)
        end
    end
end

function uninit()
    player.setProperty("cf_knownCodices", self.knownCodices)
    player.setProperty("cf_readCodices", self.readCodices)
end