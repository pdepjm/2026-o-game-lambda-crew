import enemigos.*
import manejadores.*
import frutas_y_powerups.*
import extras.*
import velocidades.*
import direcciones.*
import hielos.*

object helado {
  var property position = game.origin()
  var puntos = 0
  var velocidad = 150
  var condicionDeVelocidad = 2
  var imagen = "placeholders/helado.png"
  var vivo = true
  var direccionActual = derecha
  var siguientePosicionHielo = game.origin()
  var direccionDeLaTira = derecha

  const hielos = []

  method position () = position

  method velocidad() = velocidad

  method image() = imagen

  method cambiarCondicionDeVelocidad(numero) {
    condicionDeVelocidad = numero
  }

    // Creo que este es el método y la forma en la que diana se refería que teníamos que hacer las cosas.
    // Ahora si, hay un nuevo bug que de vez en cuando el personaje mete turbo sin razón aparente. 
    method moverHacia(direccion) {
        direccionActual = direccion
        direccion.mover(self)
    }

   method moverA(destino) {
        if (vivo &&
            self.estaDentroDelTablero(destino) &&
            !self.hayHieloEn(destino)
            ) {
            position = destino
        }
    }

    method estaDentroDelTablero(destino) {  // era mas facil crear un metodo 
      return destino.x() >= 0 &&
             destino.x() < 14.5 &&
             destino.y() >= 0 &&
             destino.y() < 14.5
    }


    method crearHielo() {
        const destino = self.posicionParaHielo()
        if (vivo && self.estaDentroDelTablero(destino) && !self.hayHieloEn(destino)) {
            const hielo = new Hielo(position = destino)
            hielos.add(hielo)
            game.addVisual(hielo)
        }
    }

    method hayHieloEn(destino) {          // consulta si hay hielos en el lugar 
        return hielos.any({ hielo => hielo.position() == destino }) 
    }

    method morir() {
     if (vivo) {   
        vivo = false
        imagen = "placeholders/helado_muerto.jpg"
        cartelReintentar.mostrar()
    }
    }

// vuelve al principio
    method reiniciar() {
        position = game.origin()
        vivo = true
        condicionDeVelocidad = 2
    }

    method posicionParaHielo() {
     return direccionActual.posicionSiguiente(position)   // ve cual es la ultima direccion en la que se mov 
    }                                                    // y le suma uno, la funcion esta en direcciones. 

    method iniciarTiraDeHielo() {
        direccionDeLaTira = direccionActual
        siguientePosicionHielo = self.posicionParaHielo()
    }

    method continuarTiraDeHielo() {
        const destino = siguientePosicionHielo

        if (vivo && self.estaDentroDelTablero(destino) && !self.hayHieloEn(destino)) {
            const hielo = new Hielo(position = destino)
            hielos.add(hielo)
            game.addVisual(hielo)
            siguientePosicionHielo =
            direccionDeLaTira.posicionSiguiente(destino)
            game.schedule(200, { self.continuarTiraDeHielo() })
        }
    }
}