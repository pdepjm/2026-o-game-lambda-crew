import movimientoRectangular.*
import manejadores.*
import helado.*
import extras.*


class Fruta {

  method image() 
  var property position 
  method puntosOtorgados () 

  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    cantFrut.sumarFruta()
  }
}

class FrutaRectangular inherits MovimientoRectangular {
 
  method image() 
  method puntosOtorgados () 

  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    cantFrut.sumarFruta()
  }
}

class Frambuesa inherits Fruta {
  override method image() = "placeholders/frambuesa.jpg"
  override method puntosOtorgados() = 100
}

class Uva inherits Fruta {
  override method image() = "placeholders/uva.png"
  override method puntosOtorgados() = 200
}
