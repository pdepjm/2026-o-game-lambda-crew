import enemigos.*
import manejadores.*
import frutas.*
import powerUps.*
import extras.*
import velocidades.*
import direcciones.*
import hielos.*

object helado {
  var property position = game.origin()
  var property velocidad = normal
  var efecto = false
  var imagen = "placeholders/helado.png"
  var vivo = true
  var direccionActual = derecha
  var siguientePosicionHielo = game.origin()
  var direccionDeLaTira = derecha
  var efectosAplicados = 0


  method image() = imagen
    method estaVivo() = vivo
  method movimiento() {}

method terminarEfecto() {
  efecto = false
}

    method moverHacia(direccion) {
    direccionActual = direccion
    if (!efecto) {
        direccion.mover(self)
        efecto = true
        game.schedule(velocidad.intervalo(), { self.terminarEfecto() })
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

    method crearHieloEn(destino) {
        manejadorDeHielo.crearHieloEn(destino)
    }

    method crearHielo() {
        const destino = self.posicionParaHielo()
        if (vivo && self.estaDentroDelTablero(destino) && !self.hayHieloEn(destino)) {
            self.crearHieloEn(destino)
        }
    }

    method hayHieloEn(destino) {
        return manejadorDeHielo.hayHieloEn(destino)
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
        efecto = false
        imagen = "placeholders/helado.png"
        manejadorDeHielo.reiniciar()                
        direccionActual = derecha 
        efectosAplicados += 1   // invalida cualquier efecto pendiente
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

        if (vivo && self.estaDentroDelTablero(destino) && !self.hayHieloEn(destino)&&  !manejadorDeEnemigos.hayEnemigoEn(destino) && !self.hayParedEn(destino)) {
            self.crearHieloEn(destino)
            siguientePosicionHielo =
            direccionDeLaTira.posicionSiguiente(destino)
            game.schedule(200, { self.continuarTiraDeHielo() })
        }
    }

    method hieloEn(unaPosicion) {
        return manejadorDeHielo.hieloEn(unaPosicion)
    }

    method romperHieloEn(destino) {
        manejadorDeHielo.romperHieloEn(destino)
    }

    method iniciarRompidaDeHielo() { 
        direccionDeLaTira = direccionActual
        siguientePosicionHielo = self.posicionParaHielo()
    }

    method continuarRompidaDeHielo() {
        const destino = siguientePosicionHielo

        if (vivo && self.estaDentroDelTablero(destino) && self.hayHieloEn(destino)) {
            self.romperHieloEn(destino)
            siguientePosicionHielo = direccionDeLaTira.posicionSiguiente(destino)
            game.schedule(200, { self.continuarRompidaDeHielo() })
        }
    }

    method cambiarVelocidadTemporalmente(unaVelocidad, duracion) {
        velocidad = unaVelocidad
        efectosAplicados += 1
        const efectoActual = efectosAplicados
        game.schedule(duracion, { 
            if (efectosAplicados == efectoActual) velocidad = normal 
        })
    }
}