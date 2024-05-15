-- КОД НЕ ВЛЕЗЕТ В КОНТРОЛЛЕР. ВОСПОЛЬЗУЙСЯ УМЕНЬШИТЕЛЕМ!!! https://goonlinetools.com/lua-minifier/

-- Перекладывает жижу из чана с бактериями в танк так, чтобы в чане оставалось половина шлюза.
-- Перекладывает стержни в радиоактивный люк
-- Вырубает чан если работа не требуется.

-- flash bact_vat.lua BACT_VAT

local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())

-- Юг 		3	OutputHatch в котором нужно поддерживать половину
-- Верх		1	танк куда выгружать жижу
-- Низ 		0	Источник сигналов
-- Восток	5	RadioHatch
-- Запад	4	Место где хранятся стержни

local sideRedstone = 0

local sideTank = 1
local sideOutputHatch = 3
local sideRadio = 5
local sideRod = 4

-- Красный	14	Включить машину
local colorMain = 14

-- 1 - полный танк. Если нужно заполнять не до конца, то меньше 1
local tankStorageMultiplier = 0.8

local function transferFluid()
  local outCapacity = math.floor(trs.getTankCapacity(sideOutputHatch) * 0.495)
  local outLevel = trs.getTankLevel(sideOutputHatch)
  local storageCapacity = math.floor(trs.getTankCapacity(sideTank) * tankStorageMultiplier)
  local storageLevel = trs.getTankLevel(sideTank)
  
  local needToTransfer = outLevel - outCapacity
  if needToTransfer <= 0 then
	return true
  end
  
  local canAccept = storageCapacity - storageLevel
  if canAccept <= 0 then
	return false
  end
  
  local transferCount = 0
  if needToTransfer > canAccept then
	transferCount = canAccept
  else
	transferCount = needToTransfer
  end
  
  trs.transferFluid(sideOutputHatch, sideTank, transferCount)
  return true
end

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

local function transferRods()
  local allStacks = trs.getAllStacks(sideRadio)
  if allStacks == nil then
	return false
  end
  local radioStack = allStacks.getAll()
  if radioStack == nil then
	return false
  end
  
  if isEmpty(radioStack) == false then
	return true
  end  
	
  local transferCount = trs.transferItem(sideRod, sideRadio, 1)
  
  if transferCount == 1 then
	return true
  else 
    return false
  end
end

rs.setOutput(sideRedstone, 15)

while true do
  canTransferFluid = transferFluid()
  canTransferRod = false
  if canTransferFluid == true then
	canTransferRod = transferRods(canTransferFluid)
  end
  
  if canTransferFluid == true and canTransferRod == true then
	rs.setOutput(sideRedstone, 15)
  else
	rs.setOutput(sideRedstone, 0)
  end

  computer.pullSignal(1)
end
