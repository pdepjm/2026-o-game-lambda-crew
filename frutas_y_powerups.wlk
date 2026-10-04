import enemigos.*
import manejadores.*
import helado.*
import extras.*

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
  var imagen = "diesel.jpg"
  method image () = imagen 

  var property position = game.at(13,13)
  method aplicarEfecto (unHelado) {
    unHelado.cambiarCondicionDeVelocidad(3)
    game.schedule(10000, {unHelado.cambiarCondicionDeVelocidad(2)})
  }
  method recibirChoqueDe(unHelado) {
  game.removeVisual(self)
  self.aplicarEfecto(unHelado)
}
}

object relentizador {
  var imagen = "copito.jpg"
  method image () = imagen 

  var property position = game.at(6,6)
  method aplicarEfecto (unHelado) {
    unHelado.cambiarCondicionDeVelocidad(1)
    game.schedule(10000, {unHelado.cambiarCondicionDeVelocidad(2)})
  }
  method recibirChoqueDe(unHelado) {
  game.removeVisual(self)
  self.aplicarEfecto(unHelado)
}
}