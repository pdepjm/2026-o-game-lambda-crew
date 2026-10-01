import enemigos.*
import manejadores.*
import frutas_y_powerups.*
import helado.*

object puntaje {
  var puntos = 0
  method esUnPowerUp () = false
  method esUnaFruta () = false
  method position() = game.at(14,14)
  method text() = ("Puntos: "+ self.puntos())
  method puntos() = puntos
  method sumarPuntos(punt) {
    puntos += punt
  }
}

object cantFrut {
  var frutas = 0
  method esUnPowerUp () = false
  method esUnaFruta () = false
  method position() = game.at(0,14)
  method text() = ("Frutas Comidas: "+ self.frutas() + "/" + creadorDeFrutas.cantidadDeFrutas())
  method frutas() = frutas
  method sumarFruta() {
    frutas += 1
  }
}

object pared {
  method image() = "placeholders/pared.jpg"
  
  var property position = game.center()

  method esUnaFruta() = false
  method esUnPowerUp () = false
}
