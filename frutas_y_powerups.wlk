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
  method esUnaFruta() = true
  method esUnPowerUp () = false
}

object acelerador {
  var imagen = "diesel.jpg"
  method image () = imagen 
  method esUnPowerUp () = true
  method esUnaFruta () = false

  var property position = game.at(13,13)
  method aplicarEfecto () {
    helado.cambiarCondicionDeVelocidad(3)
    game.schedule(10000, {helado.cambiarCondicionDeVelocidad(2)})
  }
}

object relentizador {
  var imagen = "copito.jpg"
  method image () = imagen 
  method esUnPowerUp () = true
  method esUnaFruta () = false

  var property position = game.at(6,6)
  method aplicarEfecto () {
    helado.cambiarCondicionDeVelocidad(1)
    game.schedule(10000, {helado.cambiarCondicionDeVelocidad(2)})
  }
}