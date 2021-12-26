local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())

-- 0 - Ожидание работы (Пока во входном сундуке не появится что-либо)
-- 1 - Раздача товара (пока не опустеет входной сундук)
-- 2 - Ожидание завершения (пока не опустеет выходной сундук и пока не погаснет белый сигнал)
-- 3 - Забор схемы (пока не погаснет синий сигнал)
local mode = 0

-- Сортировка танков по слотам
local sortTanksTable = {}
-- Текущее положение обычных предмето
local curentItemPosition = 0
-- Флаг обозначающий то что микросхема уже положена в контроллера
local isCircuitPlanted = false


local tanks = {"gregtech:gt.Volumetric_Flask"}
local circuit = "gregtech:gt.integrated_circuit"

local sideNorth = 2
local sideBack = 2
local sideSouth = 3
local sideTop = 1

local colorRed = 14
local colorBlack = 15

-- Положение мусорки сундуке (не будет класться в шину, а сразу в выход)
local positionTrash = 16
-- Стартовая Позиция в сундуке откуда начинают забираться обычные предметы
local positionStartNonTanks = 17

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

local function isTank(item)
  for i = 0, #tanks do
    if tanks[i] == item.name then
      return true
    end
  end
  return false
end

local function getTankSlot(item)
  for i, v in pairs(sortTanksTable) do
    if v.name == item.name and v.tag == item.tag then
      return i
    end
  end
  
  tankItem = {name = item.name, tag = item.tag}
  table.insert(sortTanksTable, tankItem)
  
  return #sortTanksTable
end

local function isItemCircuit(item)
  if circuit == item.name then
    return true
  end
  
  return false
end

local function calcPositionToMove(item)
  if item.name == nil then
    return nil
  end
  
  if isTank(item) == true then
    return getTankSlot(item) 
  end
  
  if isItemCircuit(item) == true then
    if isCircuitPlanted == true then
	  return positionTrash
	else
	  isCircuitPlanted = true
	end
  end
  
  curentItemPosition = curentItemPosition + 1
  return curentItemPosition
end

local function waitForWork(args)
  local chestInv = trs.getAllStacks(sideNorth).getAll()
  if isEmpty(chestInv) == false then
    sortTanksTable = {}
    return 1
  end
  
  return 0
end

local function sendIngridients(args)
  rs.setBundledOutput(sideBack, colorRed, 255)
  
  local chestInv = trs.getAllStacks(sideNorth).getAll()
  if isEmpty(chestInv) == true then
	return 2
  end  
  
  curentItemPosition = positionStartNonTanks
  for i, item in pairs(chestInv) do
    if (item.name ~= nil) then
      local pos = calcPositionToMove(item)
      if pos ~= nil then
        trs.transferItem(sideNorth, sideSouth, item.size, i + 1, pos)
      end
    end
  end

  -- После проброски вещей снова проверяю сундук, чтобы не было лага между тиками, когда интефейс накидает новых вещей
  local chestInv = trs.getAllStacks(sideNorth).getAll()
  if isEmpty(chestInv) == true then
	return 2
  end  
  
  return 1
end

local function waitWhileWorking(args)
  local chestInv = trs.getAllStacks(sideSouth).getAll()
  if isEmpty(chestInv) == true then
	return 3
  end  
  
  return 2
end

local function finishing(args)
  rs.setBundledOutput(sideBack, colorRed, 0)
  rs.setBundledOutput(sideBack, colorBlack, 255)
  
  return 3
end

while true do
  if mode == 0 then
    mode = waitForWork()
  end  
  if mode == 1 then
    mode = sendIngridients()
  end
  if mode == 2 then
	mode = waitWhileWorking()
  end
  if mode == 3 then
	mode = finishing()
  end  

  computer.pullSignal(1)
end
