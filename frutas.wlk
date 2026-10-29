import movimientoRectangular.*
import manejadores.*
import helado.*
import extras.*


class Fruta {

  method image() 
  var property position 
  method puntosOtorgados () 
  method movete() {} 
    //Por defecto no se mueven, cuando hago el kiwi lo sobreescribo


  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    configuracion.nivelActual().frutaComida(self) 
  }
}

class FrutaRectangular inherits MovimientoRectangular {
  
  method puntosOtorgados () 

  method recibirChoqueDe(unHelado){
    game.removeVisual(self)
    puntaje.sumarPuntos(self.puntosOtorgados())
    configuracion.nivelActual().frutaComida(self)
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

class Kiwi inherits Fruta {
  const movimiento    

  override method image() = "placeholders/kiwi.jpg"
  override method puntosOtorgados() = 300

  override method movete() {
    movimiento.movete()
    position = movimiento.position()   // sincronizo mi posición con la del recorrido
  }
}