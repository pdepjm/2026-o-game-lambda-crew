import enemigos.*
import manejadores.*
import frutas_y_powerups.*
import extras.*
import velocidades.*
import direcciones.*

object helado {
  var property position = game.origin()
  var puntos = 0
  var velocidad = 150 
  var condicionDeVelocidad = 2

  method position () = position

  method velocidad() = velocidad

  method image() = "placeholders/helado.jpeg"

  method cambiarCondicionDeVelocidad(numero) {
    condicionDeVelocidad = numero
  }

  // este method sin el if hace que el helado coma ABSOLUTAMENTE TODO (sin discriminar). Prueba de polimorfismo (?
  // tuve que añadir el method esUnaFruta para definir la interfaz de una fruta. Supongo que en el futuro fruta tendrá una mejor interfaz
  method consumir(consumible) {
    if (consumible.esUnaFruta()) {
    game.removeVisual(consumible)
    puntaje.sumarPuntos(consumible.puntosOtorgados())
    cantFrut.sumarFruta()
    } else if (consumible.esUnPowerUp()) {
      game.removeVisual(consumible)
      consumible.aplicarEfecto()
    }
  }
    
    method moverHacia(direccion) {
        direccion.mover(self)
    }

    method moverA(destino) {
        if (
            destino != pared.position() &&
            destino.x() >= 0 &&
            destino.x() < 14.5 &&
            destino.y() >= 0 &&
            destino.y() < 14.5
        ) {
            position = destino
        }
    }
}