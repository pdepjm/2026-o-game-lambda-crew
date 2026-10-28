import movimientoRectangular.*
import manejadores.*
import helado.*
import extras.*


class Fruta {
  var imagen
  var puntos
  method image() = imagen

  var x
  var y
  var property position = game.at(x,y)
  method puntosOtorgados () = puntos

  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    cantFrut.sumarFruta()
  }
}

class FrutaRectangular inherits MovimientoRectangular {
  var imagen
  var puntos
  method image() = imagen

  method puntosOtorgados () = puntos

  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    cantFrut.sumarFruta()
  }
}
