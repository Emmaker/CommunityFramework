require "/objects/scripts/cf_poweredprocessor.lua"
require "/scripts/cf_power.lua"

function init()
  self.powerUseAmount = config.getParameter("powerUseAmount")
  self.recipeList = config.getParameter("recipeList")
  self.recipes = root.assetJson("/recipes/" .. self.recipeList .. ".config")

  cf_power.setMaxPower(config.getParameter("maxPower"))
  sb.logInfo("%s", self.recipes)
end

function update()
  if world.containerItemAt(entity.id(), 0) == nil then return end

  for r, recipe in pairs(self.recipes) do
    if world.containerItemAt(entity.id(), 0).name == recipe[1] and canAddItems(recipe[2]) and cf_power.takePower(self.powerUseAmount) then
      addItems(recipe[2])
      world.containerConsumeAt(entity.id(), 0, 1)
      return
    end
  end
end