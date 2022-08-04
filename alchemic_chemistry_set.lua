local trp = component.proxy(component.list("transposer")())
local red = component.proxy(component.list("redstone")())

-- Bottom (bottom) (down), Number: 0
-- Top (top) (up), Number: 1
-- Back (back) (north), Number: 2
-- Front (front) (south), Number: 3
-- Right (right) (west), Number: 4
-- Left (left) (east), Number: 5
-- The following aliases are defined per default:

alchemySide = 1
inputSide = 4
outputSide = 5
acceleratorSide = 2

red.setOutput(acceleratorSide, 0)
while true do
    if trp.getStackInSlot(inputSide, 1) ~= nil then
        local slot = 1
        for i = 1, 5 do
            if trp.getStackInSlot(inputSide, slot) == nil then
                slot = slot + 1
            end
            trp.transferItem(inputSide, alchemySide, 1, slot, i + 1)
        end
        red.setOutput(acceleratorSide, 15)
        while trp.getStackInSlot(alchemySide, 7) == nil do computer.pullSignal(1) end
        red.setOutput(acceleratorSide, 0)
        trp.transferItem(alchemySide, outputSide, 64, 7)
    else
        computer.pullSignal(3)
    end
end
