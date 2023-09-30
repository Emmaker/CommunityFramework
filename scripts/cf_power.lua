require "/scripts/util.lua"
cf_power = {}

function init()
  storage.maxPower = config.getParameter("maxPower", 0)
  storage.power = config.getParameter("startPower", 0)
  
  message.setHandler("cf_power", cf_power.handler)
end

function cf_power.setPower(num)
  storage.power = util.clamp(num, 0, storage.maxPower)
end

function cf_power.createPower(num)
  pPower = (storage.power or 0)

  storage.power = util.clamp((storage.power or 0) + num, 0, storage.maxPower)
  return (storage.power or 0) - pPower
end

function cf_power.consumePower(num)
  if (storage.power or 0) < num then
    return false
  end

  storage.power = (storage.power or 0) - num
  return true
end

function cf_power.pushPower(nodeID, num)
  outputTable = object.getOutputNodeIds(nodeID)

  if not outputTable[1] or (storage.power or 0) < num then
    return false
  end

  outputConnections = 0
  for _ in pairs(ouputTable) do
    outputConnections = outputConnections + 1
  end

  num = num / outputConnections

  for i = 0, outputConnections - 1, 1 do
    promise = world.sendEntityMessage(outputTable[i], "cf_power", num)

    while not promise do end
    if promise:result() and power.takePower(promise:result()) then

      object.setOutputNodeLevel(nodeID, true)
      return true
    else
      object.setOutputNodeLevel(nodeID, false)
      return false
    end
  end
end

function cf_power.handler(message, localEnt, num)
  change = power.addPower(num)
  return change
end

function cf_power.getMaxPower()
  return (storage.maxPower or 0)
end

function cf_power.getPower()
  return (storage.power or 0)
end
