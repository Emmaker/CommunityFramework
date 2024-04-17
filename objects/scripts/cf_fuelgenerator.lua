require "/objects/scripts/cf_power.lua"

pInit = init
function init()
  if pInit then pInit() end

  self.fuelsList = config.getParameter("fuelsList")
  self.timerMax = config.getParameter("timerMax")
end

function update(dt)
  self.timer = (self.timer or 0) + dt
  if self.timer < self.timerMax then return end
  self.timer = 0

  for x = 0, world.containerSize(entity.id()) - 1, 1 do
    for f, fuel in pairs(self.fuelsList) do
      if fuel[2] == world.containerItemAt(entity.id(), x) then
        world.containerConsumeAt(entity.id(), x, 1)
        cf_power.createPower(fuel[1])
	    return
      end
    end
  end
end
