local component = require("component")
trs = component.transposer
print(trs)
for i, item in pairs(trs) do print (i, item) end
print(trs.getAllStacks(2))
print(trs.getInventoryName(2))
items = trs.getAllStacks(2)
for i, item in pairs(items.getAll()) do if item.name and i < 30 then print (i, item.name, item.damage, item.size, item) end end
