local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())
local mode = 0
-- 0 - Ожидание работы
-- 1 - Раздача товара
-- 2 - Забор схемы

setBundledOutput(2, 14, 0)
setBundledOutput(2, 15, 0)

while true do
  if mode == 0 then
    mode = waitForWork()
  end  
  if mode == 1 then
  end
  if mode == 2 then
  end
  if rs.getInput(3) > 0 then
    computer.beep()
  end
  rs.setOutput(2, 15)
  computer.pullSignal(1)
  rs.setOutput(2, 0)
  computer.pullSignal(1)
end

function waitForWork()
  local chestInv = trs.getAllStacks(1)
  if chestInv.count() > 0 then
    return 1
  end
  
  return 0
end
