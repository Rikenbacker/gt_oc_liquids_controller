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
local sideSignal = 1

local colorRed = 14
local colorWhite = 0

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
  local signal = local signal = rs.getBundledInput(sideSignal, colorRed)
  
  if signal > 0 then
    rs.setBundledOutput(sideSignal, colorWhite, 255)
  else
    rs.setBundledOutput(sideSignal, colorWhite, 0)
  end

end

while true do
  reloadTemplate()

  computer.pullSignal(1)
end
