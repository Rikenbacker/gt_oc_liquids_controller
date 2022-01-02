-- КОД НЕ ВЛЕЗЕТ В КОНТРОЛЛЕР. ВОСПОЛЬЗУЙСЯ УМЕНЬШИТЕЛЕМ!!! https://goonlinetools.com/lua-minifier/

local trs = component.proxy(component.list("transposer")())
local rs = component.proxy(component.list("redstone")())

-- При получении сигнала в морду перечитывает сундук с шаблонами. Зажиигает лампу наверху если начитанное совпадает с сундуком
-- Перечитывает содержимоег ёмкости пока не встретит первое что совпадает с шаблоном. Тогда выгружает из сундука максимум кратный шаблону

-- Шаблон
local template = {}

local sideTemplate = 5
local sodeOuput = 3
local sideInput = 4
local sideLamp = 1
local sideReloadInputSignal = 2

local function isEmpty(table)
  for i = 0, #table do
    if table[i] ~= nill then		
      if table[i].label ~= nil then
        return false
      end
    end
  end
  
  return true
end

local function reloadTemplate(args)
  local signal = rs.getInput(sideReloadInputSignal)
  
  if signal > 0 then
    rs.setOutput(sideLamp, 15)
  else
    rs.setOutput(sideLamp, 0)
  end

end

while true do
  reloadTemplate()

  computer.pullSignal(1)
end
