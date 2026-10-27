import enemigos.*
import manejadores.*
import frutas_y_powerups.*
import extras.*
import velocidades.*
import direcciones.*
import hielos.*

object helado {
  var property position = game.origin()
  var property velocidad = normal
  var enfriando = false
  var imagen = "placeholders/helado.png"
  var vivo = true
  var direccionActual = derecha
  var siguientePosicionHielo = game.origin()
  var direccionDeLaTira = derecha

  const hielos = []

  method image() = imagen

  method movimiento() {}

  method cambiarVelocidad(nuevaVelocidad) {
  velocidad = nuevaVelocidad
}

method terminarEnfriamiento() {
  enfriando = false
}

    method moverHacia(direccion) {
    direccionActual = direccion
    if (!enfriando) {
        direccion.mover(self)
        enfriando = true
        game.schedule(velocidad.intervalo(), { self.terminarEnfriamiento() })
    }
    }

    method moverA(destino) {
        if (vivo &&
            self.estaDentroDelTablero(destino) &&
            !self.hayHieloEn(destino) &&
            !self.hayParedEn(destino)
            ) {
            position = destino
        }
    }

    method estaDentroDelTablero(destino) {
        return destino.x() >= 0 &&
         destino.x() < game.width() &&
         destino.y() >= 0 &&
         destino.y() < game.height()
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

    //cambiamos el hay pared por el de la cosa de los niveles 
    method hayParedEn(destino) = configuracion.nivelActual().hayParedEn(destino)

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
        velocidad = normal
        enfriando = false
        imagen = "placeholders/helado.png"
        hielos.clear()                
        direccionActual = derecha 
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

        if (vivo && self.estaDentroDelTablero(destino) && !self.hayHieloEn(destino)&& !manejadorDeEnemigos.hayEnemigoEn(destino) && !self.hayParedEn(destino)) {
            const hielo = new Hielo(position = destino)
            hielos.add(hielo)
            game.addVisual(hielo)
            siguientePosicionHielo =
            direccionDeLaTira.posicionSiguiente(destino)
            game.schedule(200, { self.continuarTiraDeHielo() })
        }
    }
    method hieloEn(unaPosicion) {  //Esta deberia devolver el objeto del hielo en la pos que le mandamos
        return hielos.find({ hielo => hielo.position() == unaPosicion })
    }

    method iniciarRompidaDeHielo() { 
        direccionDeLaTira = direccionActual
        siguientePosicionHielo = self.posicionParaHielo()
    }

    method continuarRompidaDeHielo() {
        const destino = siguientePosicionHielo

        if (vivo && self.estaDentroDelTablero(destino) && self.hayHieloEn(destino)) {
            const hieloARomper = self.hieloEn(destino) // Obtener el objeto hielo en esa posición
            
            hielos.remove(hieloARomper)
            game.removeVisual(hieloARomper)
            
            siguientePosicionHielo = direccionDeLaTira.posicionSiguiente(destino)
            game.schedule(200, { self.continuarRompidaDeHielo() })
        }
}
}