-- КОД НЕ ВЛЕЗЕТ В КОНТРОЛЛЕР. ВОСПОЛЬЗУЙСЯ УМЕНЬШИТЕЛЕМ!!! https://goonlinetools.com/lua-minifier/

local trs = component.proxy(component.list("transposer")())
local rs = component.proxy(component.list("redstone")())

-- При получении сигнала в морду перечитывает сундук с шаблонами. Зажиигает лампу наверху если начитанное совпадает с сундуком
-- Перечитывает содержимоег ёмкости пока не встретит первое что совпадает с шаблоном. Тогда выгружает из сундука максимум кратный шаблону

-- Шаблон
local template = {}

local sideTemplate = 4
local sideOutput = 2
local sideInput = 5
local sideSignal = 1

local colorRed = 14
local colorWhite = 0
local colorBlack = 15

local function readTemplate(arg)
  local inputChest = trs.getAllStacks(sideTemplate).getAll()
  template = {}
  
  for i, item in pairs(inputChest) do
    if item.name ~= nill then		
      local tmp = {name = item.name, damage = item.damage, size = item.size}
      table.insert(template, tmp)
    end
  end
end

local function getFromTemplate(item)
  for i, t_item in pairs(template) do
    if item.name == t_item.name and item.damage == t_item.damage then
      return t_item
    end
  end
  
  return nil
end

local function getOutputEmptySlot(arg)
  local stacks = trs.getAllStacks(sideOutput)
  if stacks == nil then
    return
  end
  
  local chest = stacks.getAll()
  for i, item in pairs(chest) do
    if item.name == nil then
      return i
    end
  end
  
  return nil
end

local function sendItems(arg)
  local outputSlot = getOutputEmptySlot()
  if outputSlot == nil then
    return
  end
  
  local slotsCount = trs.getInventorySize(sideInput)
  
  for i = 1, slotsCount do
    local item = trs.getStackInSlot(sideInput, i)

    if item ~= nil then
      local tmplt = getFromTemplate(item)
      if tmplt ~= nill then		
        if item.size >= tmplt.size then
          local count = item.size - (item.size % tmplt.size)
          trs.transferItem(sideInput, sideOutput, count, i, outputSlot + 1)
          return
        end
      end
    else
      return
    end 
  end
end

local function reloadTemplate(args)
  local signal = rs.getBundledInput(sideSignal, colorRed)
  
  if signal > 0 then
    readTemplate()
    rs.setBundledOutput(sideSignal, colorWhite, 255)
    rs.setBundledOutput(sideSignal, colorBlack, #template)
  else
    rs.setBundledOutput(sideSignal, colorWhite, 0)
  end

end

while true do
  reloadTemplate()
  
  sendItems()

  computer.pullSignal(1)
end
