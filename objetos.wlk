object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}

object helado {
  var property position = game.origin()
  var puntos = 0

  method image() = "placeholders/helado.jpeg"

  method subir() {
    position = position.up(1)
  }

  method bajar() {
    position = position.down(1)
  }

  method derecha() {
    position = position.right(1)
  }

  method izquierda() {
    position = position.left(1)
  }

  // este method sin el if hace que el helado coma ABSOLUTAMENTE TODO (sin discriminar). Prueba de polimorfismo (?
  // tuve que añadir el method esUnaFruta para definir la interfaz de una fruta. Supongo que en el futuro fruta tendrá una mejor interfaz
  method comer(fruta) {
    if (fruta.esUnaFruta()) {
    game.removeVisual(fruta)
    puntos += 100
    }
  }

}

object fruta {
  method image() = "placeholders/fruta.jpg"

  var property position = game.at(11,5)

  method esUnaFruta() = true
}

object pared {
  method image() = "placeholders/pared.jpg"
  
  var property position = game.center()

  method esUnaFruta() = false
}

object enemigo {
  method image() = "placeholders/enemigo.jpg" 
  var property position = game.at(1,15)

  method esUnaFruta() = false
  method move() {
    const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0)
    position = game.at(x,y)
  }
}


