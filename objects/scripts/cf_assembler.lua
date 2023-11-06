require "/scripts/cf_power.lua"

pInit = init
function init()
  if pInit then pInit() end
	
  self.powerUseAmount = config.getParameter("powerUseAmount", 0)
  self.recipeList = config.getParameter("recipeList")
  self.recipes = root.assetJson("/recipes/" .. self.recipeList .. ".config")
	
  self.assemblerSlots = self.recipes[1]
  table.remove(self.recipes, 1)
end

function update()
  containsItems = false
  for i = 0, self.assemblerSlots - 1, do
    if world.containerItemAt(entity.id(), i) != nil then
	  containsItems = true
	end
  end
  if not containsItems then return end
  if not cf_power.consumePower(self.powerUseAmount) then return end
  
  ingredients = [ ]
  for r, recipe in pairs(self.recipes) do
    for i = 0, self.assemblerSlots - 1, do
      ingredients[i + 1] = world.containerItemAt(entity.id(), i)
    end
  end
  
  -- WIP
end

function canAddItems(items)
  for i, item in pairs(items) do
    if not canAddItem(item[2]) then return false end
  end

  return true
end

function canAddItem(i)
  for x = 1, world.containerSize(entity.id()) - 1, 1 do
    local slotItem = world.containerItemAt(entity.id(), x)

    if not slotItem or slotItem.name == i then
      return true
    end
  end
  
  return false
end

function addItems(items)
  for i, item in pairs(items) do
    if math.random() <= item[1] then
      addItem(item[2])
    end
  end
end

function addItem(i)
  for x = 1, world.containerSize(entity.id()) - 1, 1 do
    local slotItem = world.containerItemAt(entity.id(), x)

    if not slotItem or slotItem.name == i then
      world.containerPutItemsAt(entity.id(), i, x)
      return
    end
  end
end