import enemigos.*
import manejadores.*
import frutas_y_powerups.*
import helado.*

class Ornamental {
  method recibirChoqueDe(unHelado) { }
}

object puntaje inherits Ornamental{
  var puntos = 0
  method position() = game.at(14,14)
  method text() = ("Puntos: "+ self.puntos())
  method puntos() = puntos
  method sumarPuntos(punt) {
    puntos += punt
  }
}

object cantFrut inherits Ornamental{
  var frutas = 0
  method position() = game.at(0,14)
  method text() = ("Frutas Comidas: "+ self.frutas() + "/" + creadorDeFrutas.cantidadDeFrutas())
  method frutas() = frutas
  method sumarFruta() {
    frutas += 1
  }
}

object pared inherits Ornamental {
  method image() = "placeholders/pared.jpg"
  
  var property position = game.center()
}
