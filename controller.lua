local rs = component.proxy(component.list("redstone")())
while true do
  if rs.getInput(3) > 0 then
    computer.beep()
  end
  computer.pullSignal()
end
