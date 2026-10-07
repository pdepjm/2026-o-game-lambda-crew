import helado.*
import manejadores.*
import frutas_y_powerups.*
import extras.*
import direcciones.*

// Clase de enemigos con movimiento rectangular
class EnemigoRectangular {
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
  var sentido = derecha

  method recibirChoqueDe(unHelado) {
    unHelado.morir()
  // pendiente: definir con el grupo qué le pasa al helado
  //ACTUALIZACION: El helado muere
}

  method movete () {
    self.evaluarMovimiento()
    sentido.mover(self)
  }

  method moverA(destino) {                         // si hay hielo no se puede mover 
    if (!helado.hayHieloEn(destino)) {
        position = destino
    }
  }

  method evaluarMovimiento() {
    if (position == game.at(lsx,lsy)) {
      sentido = abajo
  } else if (position == game.at(lsx,liy)) {
      sentido = izquierda
  } else if (position == game.at(lix,lsy)) {
      sentido = derecha
  } else if (position == game.at(lix,liy)) {
      sentido = arriba
  }
}
}