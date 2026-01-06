#import "@preview/cetz:0.4.0"

#let draw-orbit(radius, electrons, etotal, ewritten, color: luma(90%), point: (0, 0), valence: 0, valence-color: red) = {
  import cetz.draw: *

  set-style(content: (padding: .2),
      fill: color,
      stroke: black)

  circle(point, radius: radius, fill: none)

  for i in range(electrons) {
    if valence > 0 and (etotal - ewritten - (i+1) < valence) {
      set-style(stroke: valence-color)
    } else {
      set-style(stroke: black)
    }

    circle(((radius*calc.sin(360deg/electrons*i) + point.at(0)), (radius*calc.cos(360deg/electrons*i) + point.at(1))), radius: 0.13)
    content((), "-")
  }

  set-style(stroke: black)
}

#let draw-center(atomic, mass, atom, radius: 0.6, color: luma(90%), point: (0, 0)) = {

  import cetz.draw: *

  if (atom.len() < 2){
    atom = atom + " "
  }

  set-style(content: (padding: .2),
      fill: color,
      stroke: black)

  circle(point, radius: radius)
  content((),$""_atomic^(mass)atom$,)
}

#let draw-atom(atomic, mass, atom, electrons, orbitals: 1.0, step: 0.4, center: 0.6, color: luma(90%), point: (0, 0), valence: 0) = {

  import cetz.draw: *

  if type(electrons) == array {

    let loop = 0
    let electrons_total = electrons.sum()
    let electrons_written = 0
    let show_valence = false

    for i in electrons {
      draw-orbit((orbitals + loop*step), i, electrons_total, electrons_written, color: color, point: point, valence: valence)
      loop = loop + 1
      electrons_written = electrons_written + i
    }

    draw-center(atomic, mass, atom, radius: center, color: color, point: point)

  }

  if type(electrons) == int or type(electrons) == float {
    let electronLevels = calc.floor(calc.sqrt(electrons/2)) + 1
    let rounds = ()

    for i in range(electronLevels) {
      if (electrons > 2*calc.pow(i+1, 2)){
        rounds.push(2*calc.pow(i+1, 2))
        electrons = electrons - (2*calc.pow(i+1, 2))
      } else {
        rounds.push(electrons)
      }
    }

    draw-atom(atomic, mass, atom, rounds, orbitals: orbitals, step: step, center: center, color: color, point: point, valence: valence)
  }
}

#let atom(atomic, mass, atom, electrons, orbitals: 1.0, step: 0.4, center: 0.6, color: luma(90%), point: (0, 0), valence: 0) = {

  if type(electrons) == int or type(electrons) == float {
    cetz.canvas({
    import cetz.draw: *
    let electronLevels = calc.floor(calc.sqrt(electrons/2)) + 1
    let rounds = ()

    for i in range(electronLevels) {
      if (electrons > 2*calc.pow(i+1, 2)){
        rounds.push(2*calc.pow(i+1, 2))
        electrons = electrons - (2*calc.pow(i+1, 2))
      } else {
        rounds.push(electrons)
      }
    }

    draw-atom(atomic, mass, atom, rounds, orbitals: orbitals, step: step, center: center, color: color, point: point, valence: valence)
  })
  }

  if type(electrons) == array {
    cetz.canvas({
    import cetz.draw: *
    draw-atom(atomic, mass, atom, electrons, orbitals: orbitals, step: step,
    center: center, color: color, point: point, valence: valence)
  })
  }

}
