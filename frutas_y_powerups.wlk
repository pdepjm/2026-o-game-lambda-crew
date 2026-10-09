import enemigos.*
import manejadores.*
import helado.*
import extras.*
import velocidades.*

class Fruta {
  var imagen
  method image() = imagen

  var x
  var y
  var property position = game.at(x,y)
  method puntosOtorgados () = 100

  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    cantFrut.sumarFruta()
  }
}



object acelerador {
  var imagen = "placeholders/diesel.jpg"
  method image () = imagen 

  var property position = game.at(13,13)
  method aplicarEfecto (unHelado) {
    unHelado.cambiarVelocidad(veloz)
    game.schedule(10000, {unHelado.cambiarVelocidad(normal)})
  }
  method recibirChoqueDe(unHelado) {
    game.removeVisual(self)
    self.aplicarEfecto(unHelado)
  }
}

object relentizador {
  var imagen = "placeholders/copito.jpg"
  method image () = imagen 

  var property position = game.at(6,6)
  method aplicarEfecto (unHelado) {
    unHelado.cambiarVelocidad(lento)
    game.schedule(10000, {unHelado.cambiarVelocidad(normal)})
  }
  method recibirChoqueDe(unHelado) {
    game.removeVisual(self)
    self.aplicarEfecto(unHelado)
  }
}