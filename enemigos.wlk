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



