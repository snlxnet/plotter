#import "@preview/cetz:0.4.2"

#let printer-dimensions = (
  x: 255mm,
  y: 210mm,
)

// raw gcode helpers
#let cmd(code, ..args) = text[#code #args.pos().join([ ]) E0 F1500]
#let slow(code, ..args) = text(fill: gray)[#code #args.pos().join([ ]) E0 F200]
#let x(pos) = text(fill: red, "X" + str(pos))
#let y(pos) = text(fill: green, "Y" + str(pos))
#let z(pos) = text(fill: blue, "Z" + str(pos))

// helpers
#let move(dx, dy) = {
  (start-x, start-y) => {
    let end-x = start-x + dx
    let end-y = start-y + dy

    (
      gcode: (
        slow("G1", z(51)),
        cmd("G1", x(end-x), y(end-y)),
      ),
      visual: cetz.draw.line(stroke: gray, (start-x, start-y), (end-x, end-y)),
      x: end-x,
      y: end-y,
    )
  }
}
#let line(dx, dy) = {
  (start-x, start-y) => {
    let end-x = start-x + dx
    let end-y = start-y + dy

    (
      gcode: (
        slow("G1", z(50)),
        cmd("G1", x(end-x), y(end-y)),
      ),
      visual: cetz.draw.line(stroke: 1mm + black, (start-x, start-y), (end-x, end-y)),
      x: end-x,
      y: end-y,
    )
  }
}
// TODO arc
/* arc example
G1 X100 Y60 E0 F1500 ; start position
G1 Z50 E0 F200 ; pen down
G3 X100 Y100 E0 F1500 R20 ; arc
*/

#let ctx(..args) = {
  let x = 0
  let y = 0
  let pen-down = true

  let sequence = ()
  for command in args.pos() {
    let result = command(x, y)
    x = result.x
    y = result.y
    sequence.push(result)
  }

  [
    #cetz.canvas(length: 1mm, {
      cetz.draw.grid(
        (0, 0),
        (printer-dimensions.x/1mm, printer-dimensions.y/1mm),
        stroke: rgb("#eee"),
        step: 5,
      )
      for val in sequence { val.visual }
    })

    #place(
      top+right,
      box(
        inset: 1cm,
        fill: white,
      )[
        #set align(left)
        #set text(font: "JetBrains Mono", size: 2.5mm)
        ; start\
        G28\
        #slow("G1", z(51))

        ; body\
        #sequence.map(val => val.gcode).flatten().join(linebreak())

        ; end\
        #slow("G1", z(51))\
        G28 X0 Y0 F1500\
        M84 ; disable motors
      ],
    )
  ]
}
