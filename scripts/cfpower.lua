require "/scripts/util.lua"
cfpower = {}

function init()
  storage.maxPower = config.getParameter("maxPower", 0)
  storage.voltage = config.getParameter("voltage", 0)
  storage.power = storage.power or config.getParameter("startPower", 0)

  message.setHandler("cfpower", function(_, _, message)
    if message.voltage and message.voltage > storage.voltage then
      storage.power = 0
      message.power = 0
    end

    change = cfpower.createPower(message.power)
    if message.alternating then
      message.power = message.power - change
      message.voltage = storage.voltage
    else
      message.power = 0
      message.voltage = 0
    end

    return message
  end)
end

-- int cfpower.getMaxPower()
function cfpower.getMaxPower()
  return storage.maxPower
end

-- void cfpower.setMaxPower(int power)
function cfpower.setMaxPower(power)
  if type(power) == "number" then
    cfpower._setMaxPower(power)
    cfpower.setPower(storage.power)
  end
end

function cfpower._setMaxPower(power)
  storage.maxPower = power
end

-- int cfpower.getPower()
function cfpower.getPower()
  return storage.power
end

-- int cfpower.setPower(int power)
function cfpower.setPower(power)
  if type(power) == "number" then
    pPower = storage.power
    cfpower._setPower(util.clamp(power, 0, storage.maxPower))

    return storage.power - pPower
  end
end

function cfpower._setPower(power)
  storage.power = power
end

-- int cfpower.createPower(int power)
function cfpower.createPower(power)
  if type(power) == "number" then
    return cfpower._setPower(util.clamp(storage.power + power, 0, storage.maxPower))
  end
end

function cfpower._createPower(power)
  return cfpower._setPower(storage.power + power)
end

-- bool cfpower.consumePower(int power)
function cfpower.consumePower(power)
  if type(power) == "number" then
    if storage.power >= power then
      cfpower._consumePower(power)
      return storage.power
    end

    return storage.power - power
  end
end

function cfpower._consumePower(power)
  cfpower.setPower(storage.power - power)
end

-- int, int cfpower.pushPower(int nodeID, int power, [bool alternating], [int voltage])
function cfpower.pushPower(nodeID, power, alternating, voltage)
  voltage = voltage or storage.voltage
  alternating = alternating or false

  local outputTable = object.getOutputNodeIds(nodeID)
  local outputTableSize = util.tableSize(outputTable)
  if outputTableSize < 1 or storage.power < power then
    return 0
  end

  power = power / outputTableSize
  local successes = 0

  for i, _ in pairs(outputTable) do
    result = cfpower._pushPower(id)

    if result == nil then
      cfpower.createPower(power)
      object.setOutputNodeLevel(nodeID, false)
    elseif result < 0 then
      storage.power = 0
      object.setOutputNodeLevel(nodeID, false)
      return result
    else
      cfpower.createPower(promise:result().power)
      object.setOutputNodeLevel(nodeID, true)
      successes = successes + 1
    end
  end

  return successes
end

function cfpower._pushPower(id, power, alternating, voltage)
  local message = {
    power = power,
    voltage = voltage,
    alternating = alternating
  }

  promise = world.sendEntityMessage(i, "cfpower", message)

  while not promise do end
  if promise:result() and type(promise:result()) == "table" then
    message = promise:result()
    if message.voltage and message.voltage > storage.voltage then
      return -1
    end

    return promise:result().power
  else
    return nil
  end
end