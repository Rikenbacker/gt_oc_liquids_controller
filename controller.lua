local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())

-- 0 - Ожидание работы (Пока во входном сундуке не появится что-либо)
-- 1 - Раздача товара (пока не опустеет входной сундук)
-- 2 - Ожидание заполненности зотя-бы одного танка (появление белого сигнала)
-- 3 - Запуск работы (выдача зелёного сигнала) и ожидания выключения белого сигнала
-- 4 - Забор схемы (пока не погаснет синий сигнал)
local mode = 0

-- Сортировка танков по слотам
local sortTanksTable = {}
-- Текущее положение обычных предмето
local curentItemPosition = 0
-- Флаг обозначающий то что микросхема уже положена в контроллера
local isCircuitPlanted = false
-- Состояние входного сундука
local inputChest = {}


local tanks = {"gregtech:gt.Volumetric_Flask"}
local circuit = "gregtech:gt.integrated_circuit"

local sideNorth = 2
local sideBack = 2
local sideSouth = 3
local sideTop = 1

local colorRed = 14
local colorBlack = 15
local colorWhite = 0
local colorBlue = 11
local colorGreen = 13

-- Положение мусорки сундуке (не будет класться в шину, а сразу в выход)
local positionTrash = 16
-- Стартовая Позиция в сундуке откуда начинают забираться обычные предметы
local positionStartNonTanks = 17

rs.setBundledOutput(sideBack, colorRed, 0)
rs.setBundledOutput(sideBack, colorBlack, 0)
rs.setBundledOutput(sideBack, colorGreen, 0)

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
  rs.setBundledOutput(sideBack, colorRed, 0)
  rs.setBundledOutput(sideBack, colorBlack, 0)
  rs.setBundledOutput(sideBack, colorGreen, 0)

  sortTanksTable = {}
  isCircuitPlanted = false
  inputChest = {}

  inputChest = trs.getAllStacks(sideNorth).getAll()
  if isEmpty(inputChest) == false then
    return 1
  end
  
  return 0
end

local function sendIngridients(args)
  rs.setBundledOutput(sideBack, colorRed, 255)
    
  curentItemPosition = positionStartNonTanks
  for i, item in pairs(inputChest) do
    if (item.name ~= nil) then
      local pos = calcPositionToMove(item)
      if pos ~= nil then
        local transfer = trs.transferItem(sideNorth, sideSouth, item.size, i + 1, pos)
	if (item.size - transfer) == 0 then
          inputChest[i] = nil
        else
          inputChest[i].size = item.size - transfer 
        end
      end
    end
  end

  if isEmpty(inputChest) == true then
    return 2
  end  
  
  return 1
end

local function waitFillTank(args)
  local signal = rs.getBundledInput(sideBack, colorWhite)
  if signal > 1 then
    return 3
  end  
  
  return 2
end

local function waitWhileWorking(args)
  rs.setBundledOutput(sideBack, colorGreen, 255)
  local chestInv = trs.getAllStacks(sideSouth).getAll()
  local signal = rs.getBundledInput(sideBack, colorWhite)
  if isEmpty(chestInv) == true and signal == 0 then
    return 4
  end  
  
  return 3
end

local function finishing(args)
  rs.setBundledOutput(sideBack, colorRed, 0)
  rs.setBundledOutput(sideBack, colorBlack, 255)
  rs.setBundledOutput(sideBack, colorGreen, 0)

  local signal = rs.getBundledInput(sideBack, colorBlue)
  if signal == 0 then
    rs.setBundledOutput(sideBack, colorBlack, 0)
    return 0
  end  
  
  return 4
end

while true do
  if mode == 0 then
    mode = waitForWork()
  elseif mode == 1 then
    mode = sendIngridients()
  elseif mode == 2 then
    mode = waitFillTank()
  elseif mode == 3 then
    mode = waitWhileWorking()
  elseif mode == 4 then
    mode = finishing()
  end  

  computer.pullSignal(1)
end
