local rs = component.proxy(component.list("redstone")())
local trs = component.proxy(component.list("transposer")())

-- 0 - Ожидание работы
-- 1 - Раздача товара
-- 2 - Ожидание завершения
-- 3 - Забор схемы
local mode = 0

local sortTanksTable = {}
local curentItemPosition = 0

local tanks = {"gregtech:gt.Volumetric_Flask"}

local sideBTop = 1
local sideBack = 2
local sideRignt = 4

local colorRed = 14
local colorBlack = 14

-- Стартовая Позиция в сундуке откуда начинают забираться обычные предметы
local positionStartNonTanks = 16

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
  for i, v in #sortTanksTable do
    if v.name == item.name and v.tag == name.tag then
      return i
    end
  end
  
  local pos = #sortTanksTable
  tankItem = {name = item.name, tag = item.tag}
  sortTanksTable[#sortTanksTable] = tankItem
  
  return pos
end

local function calcPositionToMove(item)
  if item.name == nil then
    return nil
  end
  
  if isTank(item) == true then
    return getTankSlot(item)
  else
    local tmp = curentItemPosition
    curentItemPosition = curentItemPosition + 1
    return tmp
  end
end

local function waitForWork(args)
  local chestInv = trs.getAllStacks(sideBTop).getAll()
  if isEmpty(chestInv) == false then
    sortTanksTable = {}
    return 1
  end
  
  return 0
end

local function sendIngridients(args)
  rs.setBundledOutput(sideBack, colorRed, 255)
  
  local chestInv = trs.getAllStacks(sideBTop).getAll()
  if isEmpty(chestInv) == false then
    return 2
  end  
  
  curentItemPosition = positionStartNonTanks
  for i, item in chestInv do
    local pos = calcPositionToMove(item)
    if pos ~= nil then
      trs.transferItem(sideTop, sideRignt, item.size, i, pos)
    end
  end

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
