import movimientoRectangular.*
import manejadores.*
import helado.*
import extras.*


class Fruta {
  var congelada = false
  var comida = false       

  method image() = if (congelada) self.imagenCongelada() else self.imagenNormal()

  method actualizarCongelamiento() {
    congelada = manejadorDeHielo.hayHieloEn(position)
  }

  method imagenNormal()
  method imagenCongelada()
  method tipo()              
  method comida() = comida    

  var property position

  method puntosOtorgados()
  method movete() {}

  method recibirChoqueDe(unHelado){
    comida = true            
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
  override method tipo() = "frambuesa"
  override method imagenNormal() = "placeholders/frambuesa.jpg"
  override method imagenCongelada() = "placeholders/frambuesaCongelada.png"
  override method puntosOtorgados() = 100
}

class Uva inherits Fruta {
  override method tipo() = "uva"
  override method imagenNormal() = "placeholders/uva.png"
  override method imagenCongelada() = "placeholders/uvaCongelada.png"
  override method puntosOtorgados() = 200
}

class Kiwi inherits Fruta {
  const movimiento    
  override method tipo() = "kiwi"
  override method imagenNormal() = "placeholders/kiwi.jpg"
  override method imagenCongelada() = "placeholders/kiwiCongelado.png"
  override method puntosOtorgados() = 300

  override method movete() {
    const anterior = position
    movimiento.movete()
    position = movimiento.position()   // sincronizo mi posición con la del recorrido
    //aviso a la celda q me moví 
    //basicamente es para que el hielo de ahí no quede con la imagen congelada de un kiwi que ya no está
    self.actualizarCongelamiento()
    manejadorDeHielo.refrescarEn(anterior)
  }
}