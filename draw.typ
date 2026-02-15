#import "gcode.typ": ctx, move, line, printer-dimensions

#set page(
  width: printer-dimensions.x,
  height: printer-dimensions.y,
  margin: 0mm,
)

#ctx(
  move(50, 50),
  line(0, 100),
  move(0, -50),
  line(30, 0),
  line(0, 50),
  line(0, -100),

  move(20, 0),

  line(0, 50),
  move(-10, 30),
  line(20, 0),
  move(-10, 10),
  line(0, -20),
  move(20, -70),
)


