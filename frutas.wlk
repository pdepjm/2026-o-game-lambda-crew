import movimientoRectangular.*
import manejadores.*
import helado.*
import extras.*


class Fruta {

  method image() {
    if (manejadorDeHielo.hayHieloEn(self.position())) {
      return self.imagenCongelada()
    } else {
      return self.imagenNormal()
    }
  }

  method imagenNormal()
  method imagenCongelada()

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
  override method imagenNormal() = "placeholders/frambuesa.jpg"
  override method imagenCongelada() = "placeholders/frambuesaCongelada.png"
  override method puntosOtorgados() = 100
}

class Uva inherits Fruta {
  override method imagenNormal() = "placeholders/uva.png"
  override method imagenCongelada() = "placeholders/uvaCongelada.png"
  override method puntosOtorgados() = 200
}

class Kiwi inherits Fruta {
  const movimiento    

  override method imagenNormal() = "placeholders/kiwi.jpg"
  override method imagenCongelada() = "placeholders/kiwiCongelado.png"
  override method puntosOtorgados() = 300

  override method movete() {
    movimiento.movete()
    position = movimiento.position()   // sincronizo mi posición con la del recorrido
  }
}