object creadorDeFrutas {

  method crearFrambuesas() {
    const limiteX = game.width() - 1
    const limiteY = game.height() - 1

    (0..limiteX).forEach { posicionEnX =>
      (0..limiteY).forEach { posicionEnY =>
        
        if (posicionEnY.odd() && posicionEnX.even()) {
          game.addVisual(new Frambuesa(x = posicionEnX, y = posicionEnY))
        }
        
      }
    }
  }
}

object manejadorDeEnemigos {

    const listaDeEnemigos = []
    // En primera instancia quería hacer addVisual y add enemigo a lista de enemigos todo junto, pero por errores en wollok
    // lo tuve que hacer todo separado y queda muy largo el method. Es lo que hay por ahora
    method crearEnemigosMovRect () {

      const enemigo1 = new Enemigo (x=0,lix=0,lsx=14,y=14,liy=0,lsy=14)
      const enemigo2 = new Enemigo (x=14,lix=0,lsx=14,y=0,liy=0,lsy=14)
      const enemigo3 = new Enemigo (x=4,lix=4,lsx=10,y=10,liy=4,lsy=10)
      const enemigo4 = new Enemigo (x=10,lix=4,lsx=10,y=4,liy=4,lsy=10)

      game.addVisual (enemigo1)
      game.addVisual (enemigo2)
      game.addVisual (enemigo3)
      game.addVisual (enemigo4)

      listaDeEnemigos.add(enemigo1)
      listaDeEnemigos.add(enemigo2)
      listaDeEnemigos.add(enemigo3)
      listaDeEnemigos.add(enemigo4)
    }

    method moverEnemigos () {
      listaDeEnemigos.forEach{enemigo => enemigo.movete()}
    }
}

object helado {
  var property position = game.origin()
  var puntos = 0

  method image() = "placeholders/helado.jpeg"

  method subir() {
    self.moverA(position.up(1))
  }
  
  method bajar() {
    self.moverA(position.down(1))
  }
  
  method derecha() {
    self.moverA(position.right(1))
  }
  
  method izquierda() {
    self.moverA(position.left(1))
  }

  // este method sin el if hace que el helado coma ABSOLUTAMENTE TODO (sin discriminar). Prueba de polimorfismo (?
  // tuve que añadir el method esUnaFruta para definir la interfaz de una fruta. Supongo que en el futuro fruta tendrá una mejor interfaz
  method comer(fruta) {
    if (fruta.esUnaFruta()) {
    game.removeVisual(fruta)
    puntaje.sumarPuntos(fruta.puntosOtorgados())
    }
  }

method moverA(destino) {
  if (
    destino != pared.position() &&
    destino.x() >= 0 &&
    destino.x() < game.width() &&
    destino.y() >= 0 &&
    destino.y() < game.height()
  ) {
    position = destino
  }
}

}

class Frambuesa {
  method image() = "placeholders/frambuesa.jpg"

  var x
  var y
  var property position = game.at(x,y)
  method puntosOtorgados () = 100
  method esUnaFruta() = true
}

object puntaje {
  var puntos = 0
  method position() = game.at(14,14)
  method text() = ("Puntos: "+ self.puntos())
  method puntos() = puntos
  method sumarPuntos(punt) {
    puntos += punt
  }
}

object pared {
  method image() = "placeholders/pared.jpg"
  
  var property position = game.center()

  method esUnaFruta() = false
}
// Clase de enemigos con movimiento rectangular
class Enemigo {
  method image() = "placeholders/enemigo.jpg" 
  var x
  var y
  // ls = limite superior
  var lsy
  var lsx
  // li = limite inferior
  var liy
  var lix
  var property position = game.at(x,y)
  var sentido = "derecha"

  method esUnaFruta() = false

  method movete () {
    self.evaluarMovimiento()
    if (sentido=="abajo") {
      position = position.down(1)
    } else if (sentido=="arriba") {
      position = position.up(1) 
    } else if (sentido=="derecha") {
      position = position.right(1) 
    } else if (sentido=="izquierda") {
      position = position.left(1) 
    }
  }

  method evaluarMovimiento() {
    if (position == game.at(lsx,lsy)) {
      sentido = "abajo"
  } else if (position == game.at(lsx,liy)) {
      sentido = "izquierda"
  } else if (position == game.at(lix,lsy)) {
      sentido = "derecha"
  } else if (position == game.at(lix,liy)) {
      sentido = "arriba"
  }
}
}

