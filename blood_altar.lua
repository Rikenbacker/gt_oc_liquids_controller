local trp = component.proxy(component.list("transposer")())
local red = component.proxy(component.list("redstone")())

-- Bottom (bottom) (down), Number: 0
-- Top (top) (up), Number: 1
-- Back (back) (north), Number: 2
-- Front (front) (south), Number: 3
-- Right (right) (west), Number: 4
-- Left (left) (east), Number: 5
-- The following aliases are defined per default:

altarSide = 2
inputSide = 4
outputSide = 5
orbSide = 1
acceleratorSide = 0 --relative???

function enableAccelerator()
    red.setOutput(acceleratorSide, 15)
end

function disableAccelerator()
    red.setOutput(acceleratorSide, 0)
end

function main()
    disableAccelerator()
    while true do
        inputItem = trp.getStackInSlot(inputSide, 2)

        if inputItem ~= nil then
            trp.transferItem(altarSide, orbSide)
            trp.transferItem(inputSide, altarSide)
            while trp.getStackInSlot(altarSide, 1).label == inputItem.label do
                enableAccelerator()
                computer.pullSignal(1)
            end
            trp.transferItem(altarSide, outputSide)
            trp.transferItem(orbSide, altarSide)
            disableAccelerator()
        else
            computer.pullSignal(5)
        end
    end
end

main()
