require "/scripts/util.lua"
cf_power = {}

function init()
  storage.maxPower = config.getParameter("maxPower", 0)
  storage.voltage = config.getParameter("voltage", 0)
  storage.power = storage.power or config.getParameter("startPower", 0)
  
  message.setHandler("cf_power", cf_power.handler)
end

-- int cf_power.getMaxPower()
function cf_power.getMaxPower()
  return storage.maxPower
end

-- void cf_power.setMaxPower(int power)
function cf_power.setMaxPower(power)
  storage.maxPower = power
  cf_setPower(storage.power)
end

-- int cf_power.getPower()
function cf_power.getPower()
  return storage.power
end

-- int cf_power.setPower(int power)
function cf_power.setPower(power)
  pPower = storage.power
  storage.power = util.clamp(power, 0, storage.maxPower)

  return storage.power - pPower
end

-- int cf_power.createPower(int power)
function cf_power.createPower(power)
  return cf_power.setPower(storage.power + power)
end

-- bool cf_power.consumePower(int power)
function cf_power.consumePower(power)
  if storage.power >= power then
    cf_power.setPower(storage.power - power)
    return storage.power
  end

  return storage.power - power
end

-- int, int cf_power.pushPower(int nodeID, int power, [bool alternating], [int voltage])
function cf_power.pushPower(nodeID, power, alternating, voltage)
  local outputTable = object.getOutputNodeIds(nodeID)
  if #outputTable > 0 or storage.power < power then
    return 0
  end

  power = power / #outputTable
  local successes = 0

  for i = 0, #outputTable - 1, 1 do
    local message = {
      power = power,
      voltage = voltage or storage.voltage,
      alternating = alternating or false
    }

    cf_power.consumePower(power)
    promise = world.sendEntityMessage(outputTable[i], "cf_power", message)

    while not promise do end
    if promise:result() and type(promise:result()) == "table" then
      message = promise:result()
      if message.voltage and message.voltage > storage.voltage then
        storage.power = 0
        object.setOutputNodeLevel(nodeID, false)
        return -1
      end

      cf_power.createPower(promise:result().power)
      object.setOutputNodeLevel(nodeID, true)
      successes = successes + 1
    else
      cf_power.createPower(power)
      object.setOutputNodeLevel(nodeID, false)
    end
  end

  return successes
end

function cf_power.handler(_, _, message)
  if message.voltage and message.voltage > storage.voltage then
    storage.power = 0
    message.power = 0
  end

  change = power.createPower(message.power)
  if message.alternating then
    message.power = message.power - change
    message.voltage = storage.voltage
  else
    message.power = 0
    message.voltage = 0
  end

  return message
end
