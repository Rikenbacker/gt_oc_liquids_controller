local rs = component.proxy(component.list("redstone")())
while true do
  if rs.getInput(3) > 0 then
    computer.beep()
  end
  rs.setOutput(2, 15)
  computer.pullSignal()
  rs.setOutput(2, 0)
end
