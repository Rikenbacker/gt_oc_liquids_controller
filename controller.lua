local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())

local mode = 0
-- 0 - Ожидание работы
-- 1 - Раздача товара
-- 2 - Забор схемы

local sideBTop = 1
local sideBack = 2

local colorRed = 14
local colorBlack = 14

rs.setBundledOutput(sideBack, colorRed, 0)
rs.setBundledOutput(sideBack, colorBlack, 0)

local function isEmpty(table)
  for i = 0, #table do
    if table[i].label ~= nil then
      return false
    end
  end
  
  return true
end

local function waitForWork(args)
  local chestInv = trs.getAllStacks(sideBTop).getAll()
  if isEmpty(chestInv) == false then
    return 1
  end
  
  return 0
end

local function sendIngridients(args)
  rs.setBundledOutput(sideBack, colorRed, 255)
  
  local chestInv = trs.getAllStacks(sideBTop)

  
  return 1
end

while true do
  if mode == 0 then
    mode = waitForWork()
  end  
  if mode == 1 then
    mode = sendIngridients()
  end
  if mode == 2 then
  end

  computer.pullSignal(1)
end
