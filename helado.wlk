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
  var imagen = "placeholders/helado.jpeg"
  var vivo = true

  method position () = position

  method velocidad() = velocidad

  method image() = imagen

  method cambiarCondicionDeVelocidad(numero) {
    condicionDeVelocidad = numero
  }

    // Creo que este es el método y la forma en la que diana se refería que teníamos que hacer las cosas.
    // Ahora si, hay un nuevo bug que de vez en cuando el personaje mete turbo sin razón aparente. 
    method moverHacia(direccion) {
        direccion.mover(self)
    }

    method moverA(destino) {
        if (
            vivo &&
            destino != pared.position() &&
            destino.x() >= 0 &&
            destino.x() < 14.5 &&
            destino.y() >= 0 &&
            destino.y() < 14.5
        ) {
            position = destino
        }
    }

    method morir() {
     if (vivo) {   
        vivo = false
        imagen = "placeholders/helado_muerto.jpeg"
        cartelReintentar.mostrar()
    }
    }

// vuelve al principio
    method reiniciar() {
        position = game.origin()
        vivo = true
        condicionDeVelocidad = 2
    }
}