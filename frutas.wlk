import movimientoRectangular.*
import manejadores.*
import helado.*
import extras.*


class Fruta {
  //Para saber que foto poner, si la congelada o la normal
  var congelada = false

  //Sistema de congelamiento para q evitemos el lag q hacia la otra forma 
  method image() = if (congelada) self.imagenCongelada() else self.imagenNormal()

  method actualizarCongelamiento() {
    congelada = manejadorDeHielo.hayHieloEn(position)
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
    const anterior = position
    movimiento.movete()
    position = movimiento.position()   // sincronizo mi posición con la del recorrido
    //aviso a la celda q me moví 
      //basicamente es para que el hielo de ahí no quede con la imagen congelada de un kiwi que ya no está
    self.actualizarCongelamiento()
    manejadorDeHielo.refrescarEn(anterior)
  }
}