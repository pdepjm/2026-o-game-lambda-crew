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
        if (self.habilitado(destino) && self.noHayBloques(destino)) {
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
        if (self.habilitado(destino) && !manejadorDeHielo.hayHieloEn(destino)) {
            self.crearHieloEn(destino)
        }
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
     // pantalla final: el helado queda quieto
    method detener() {
        vivo = false
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

    method tirarHielo() {
        self.continuarTiraDeHielo(self.posicionParaHielo(), direccionActual)
    }

    method continuarTiraDeHielo(destino, direccion) {
        if (self.habilitado(destino) && self.noHayBloques(destino) && !manejadorDeEnemigos.hayEnemigoEn(destino)) {
            self.crearHieloEn(destino)
            game.schedule(200, { self.continuarTiraDeHielo(direccion.posicionSiguiente(destino), direccion) })
        }
    }

    method romperHielo() {
        self.continuarRompidaDeHielo(self.posicionParaHielo(), direccionActual)
    }

    method continuarRompidaDeHielo(destino, direccion) {
        if (self.habilitado(destino) && manejadorDeHielo.hayHieloEn(destino)) {
            self.romperHieloEn(destino)
            game.schedule(200, { self.continuarRompidaDeHielo(direccion.posicionSiguiente(destino), direccion) })
        }
    }

    method habilitado (destino) = vivo && self.estaDentroDelTablero(destino)

    method noHayBloques (destino) = !manejadorDeHielo.hayHieloEn(destino) && !self.hayParedEn(destino)

    method hieloEn(unaPosicion) {
        return manejadorDeHielo.hieloEn(unaPosicion)
    }

    method romperHieloEn(destino) {
        manejadorDeHielo.romperHieloEn(destino)
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