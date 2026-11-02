import movimientoRectangular.*
import helado.*
import manejadores.*
import frutas.*
import powerUps.*
import extras.*
import direcciones.*

// Clase de enemigos con movimiento rectangular
class EnemigoRectangular inherits MovimientoRectangular{
  method recibirChoqueDe(unHelado) {
  unHelado.morir()
}
}

// Clase de enemigos inteligentes

class EnemigoRompeHielo inherits EnemigoRectangular{

  var estaRompiendoHielo = false

  override method image () {
    if (estaRompiendoHielo) {
      return self.imagenRompedora()
    } else {
      return self.imagenNormal()
    }
  }

  method imagenRompedora() = "placeholders/enemigoRompedorRompiendo.jpg"
  method imagenNormal() = "placeholders/enemigoRompedor.jpg"

  override method moverA(destino) {
    if (configuracion.nivelActual().hayParedEn(destino)) {
      horario = !horario
      sentido = sentido.opuesta()
    } else if (manejadorDeHielo.hayHieloEn(destino)) {
      estaRompiendoHielo = true
      game.schedule(2000, {
        if (manejadorDeHielo.hayHieloEn(destino)){
          manejadorDeHielo.romperHieloEn(destino)
        }
        estaRompiendoHielo = false
      })
    } else {
      position = destino
    }
  }
}


// Enemigo que persigue al helado
class EnemigoPerseguidor {
    var property position

    method image() = "placeholders/perseguidor.png"   // cambiar cuando haya sprite propio

    method recibirChoqueDe(unHelado) {
        unHelado.morir()
    }

    method movete() {
        position = self.direccionesHaciaHelado()
            .map({ direccion => direccion.posicionSiguiente(position) })
            .findOrDefault({ destino => self.puedeIrA(destino) }, position)
    }

    // Devuelve las direcciones que acercan al helado, la del eje más lejano primero.
    // Si la primera está bloqueada, prueba la segunda: así no se traba contra una pared.
    method direccionesHaciaHelado() {
        const dx = helado.position().x() - position.x()
        const dy = helado.position().y() - position.y()
        const horizontales = if (dx > 0) [derecha] else if (dx < 0) [izquierda] else []
        const verticales = if (dy > 0) [arriba] else if (dy < 0) [abajo] else []
        return if (dx.abs() >= dy.abs()) horizontales + verticales else verticales + horizontales
    }

    method puedeIrA(destino) =
        helado.estaDentroDelTablero(destino) &&
        !configuracion.nivelActual().hayParedEn(destino) &&
        !manejadorDeHielo.hayHieloEn(destino)
}


// Perseguidor que, si el hielo le tapa el camino, lo rompe
class EnemigoPerseguidorRompeHielo inherits EnemigoPerseguidor {
    var estaRompiendoHielo = false

    override method image() =
        if (estaRompiendoHielo) "placeholders/enemigoRompedorRompiendo.jpg"
        else "placeholders/enemigoRompedor.jpg"

    override method movete() {
        if (!estaRompiendoHielo) {
            const direcciones = self.direccionesHaciaHelado()
            if (!direcciones.isEmpty() && self.hayHieloAl(direcciones.first())) {
                self.romperHieloAl(direcciones.first())
            } else {
                super()
            }
        }
    }

    method hayHieloAl(direccion) =
        manejadorDeHielo.hayHieloEn(direccion.posicionSiguiente(position))

    method romperHieloAl(direccion) {
        const destino = direccion.posicionSiguiente(position)
        estaRompiendoHielo = true
        game.schedule(2000, {
            if (manejadorDeHielo.hayHieloEn(destino)) {
                manejadorDeHielo.romperHieloEn(destino)
            }
            estaRompiendoHielo = false
        })
    }
}

