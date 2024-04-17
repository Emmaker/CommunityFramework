require "/scripts/util.lua"
cf_gasnet = {}

function init()
    if not storage.tanks then
        for i = 1, config.getParameter("tankCount", 1), 1 do
            storage.tanks[i] = config.getParameter("defaultTanks", {})[i] or {
                gas = nil,
                size = config.getParameter("tankSize", 0),
                amount = 0
            }
        end
    end

    message.setHandler("cf_gasnet", cf_gasnet.handler)
end

function cf_gasnet.getTanks()
    return #storage.tanks
end

function cf_gasnet.getTankGas(tank)
    return storage.tanks[tank].gas
end

function cf_gasnet.setTankGas(tank, gas)
    storage.tanks[tank].gas = gas
end

function cf_gasnet.getTankSize(tank)
    return storage.tanks[tank].size
end

function cf_gasnet.setTankSize(tank, size)
    storage.tanks[tank].size = size
end

function cf_gasnet.getTankAmount(tank)
    return storage.tanks[tank].amount
end

function cf_gasnet.setTankAmount(tank, amount)
    pAmount = storage.tanks[tank].amount
    storage.tanks[tank].amount = util.clamp(amount, 0, storage.tanks[tank].size)

    return storage.tanks[tank].amount - pAmount
end

-- 'tank' can be a number or a string. If it is a string, it will try to find a tank with that gas
function cf_gasnet.createGas(amount, tank)
    if type(tank) == "string" then
        for i, t in ipairs(storage.tanks) do
            if t.gas == tank or t.gas == nil then
                cf_gasnet.setTankGas(i, tank)
                return cf_gasnet.setTankAmount(i, storage.tanks[i].amount + amount)
            end
        end

        return 0
    else
        return cf_gasnet.setTankAmount(tank, storage.tanks[tank].amount + amount)
    end
end

-- 'tank' can be a number of a string. If it is a string, it will try to find a tank with that gas
function cf_gasnet.consumeGas(amount, tank)
    if type(tank) == "string" then
        for i, t in ipairs(storage.tanks) do
            if t.gas == tank and t.amount >= amount then
                cf_gasnet.setTankAmount(i, storage.tanks[i].amount - amount)
                if cf_gasnet.getTankAmount(i) < 1 then
                    cf_gasnet.setTankGas(i, nil)
                end
                return cf_gasnet.getTankAmount(i)
            end
        end
        
        return cf_gasnet.getTankAmount(tank) - amount
    else
        if storage.tanks[tank].amount >= amount then
            cf_gasnet.setTankAmount(tank, storage.tanks[tank].amount - amount)
            if cf_gasnet.getTankAmount(i) < 1 then
                cf_gasnet.setTankGas(tank, nil)
            end
            return cf_gasnet.getTankAmount(tank)
        else
            return cf_gasnet.getTankAmount(tank) - amount
        end
    end
end

function cf_gasnet.pushGas(nodeID, amount, tank)
    if type(tank) == "string" then
        for i, t in ipairs(storage.tanks) do
            if t.gas == tank then
                tank = i
                break
            end
        end
    end

    local outputTable = object.getOutputNodeIds(nodeID)
    if #outputTable > 0 or storage.tanks[tank].amount < amount then
      return 0
    end

    amount = amount / #outputTable
    local successes = 0

    for i = 0, #outputTable - 1, 1 do
        local message = {
            amount = amount,
            gas = storage.tanks[tank].gas
        }

        cf_gasnet.consumeGas(amount, tank)
        promise = world.sendEntityMessage(outputTable[i], "cf_gasnet", message)

        while not promise do end
        if promise:result() and type(promise:result()) == "table" then
            message = promise:result()
            if message.amount > 0 then
                cf_gasnet.createGas(message.amount, tank)
            end
            
            object.setOutputNodeLevel(nodeID, true)
            successes = successes + 1
        else
            cf_gasnet.createGas(amount, tank)
            object.setOutputNodeLevel(nodeID, false)
        end
    end

    return successes
end

function cf_gasnet.handler(_, _, message)
    change = power.createGas(message.amount, message.gas)
    message.amount = change
    return message
end