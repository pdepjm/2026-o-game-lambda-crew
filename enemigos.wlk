import movimientoRectangular.*
import helado.*
import manejadores.*
import frutas.*
import powerUps.*
import extras.*
import direcciones.*

// Clase de enemigos con movimiento rectangular
class Enemigo {
  const movimiento
  var property position

  method image() = "placeholders/enemigo.jpg"

  method movete() {
    movimiento.movete()
    position = movimiento.position()   // sincronizo mi posición con la del recorrido, igual que el Kiwi
  }

  method recibirChoqueDe(unHelado) {
    unHelado.morir()
  }
}
