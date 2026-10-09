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
  var horario = true

  method recibirChoqueDe(unHelado) {
    unHelado.morir()
}

  method movete () {
    self.evaluarMovimiento()
    sentido.mover(self)
  }

  method moverA(destino) {                         
    if (helado.hayHieloEn(destino)) {   // hay hielo: se da vuelta
    horario = !horario
    sentido = sentido.opuesta()
  } else {
    position = destino
  }
  }

  method evaluarMovimiento() {
    if (position == game.at(lsx,lsy)) {
    sentido = if (horario) abajo else izquierda
  } else if (position == game.at(lsx,liy)) {
    sentido = if (horario) izquierda else arriba
  } else if (position == game.at(lix,liy)) {
    sentido = if (horario) arriba else derecha
  } else if (position == game.at(lix,lsy)) {
    sentido = if (horario) derecha else abajo
  }

}
}