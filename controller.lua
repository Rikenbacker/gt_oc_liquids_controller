local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())
local mode = 0
-- 0 - Ожидание работы
-- 1 - Раздача товара
-- 2 - Забор схемы

rs.setBundledOutput(2, 14, 0)
rs.setBundledOutput(2, 15, 0)

local function waitForWork(args)
  local chestInv = trs.getAllStacks(1)
  if chestInv.count() > 0 then
    return 1
  end
  
  return 0
end

local function sendIngridients(args)
  rs.setBundledOutput(2, 14, 15)
  
  local chestInv = trs.getAllStacks(1)

  
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
