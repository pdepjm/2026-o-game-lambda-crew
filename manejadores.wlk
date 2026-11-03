import enemigos.*
import frutas.*
import helado.*
import extras.*
import direcciones.*
import niveles.*
import powerUps.*
import hielos.*

object configuracion {
  var nivelActual = nivel1
  method nivelActual() = nivelActual

  method iniciar() {
    nivelActual.iniciar()       // dibuja el mapa y posiciona al helado
    const tick = game.tick(666, { manejadorDeEnemigos.moverEnemigos() }, false)
    const tick2 = game.tick(500, { self.nivelActual().moverFrutas() }, false)


    game.addVisual(helado)
    //game.addVisual(p) --> Lo sacamos pq ahora lo hace nivel 
    game.addVisual(puntaje)
    game.addVisual(cantFrut)


    tick.start()
    tick2.start()
    
    keyboard.left().whilePressedDo({helado.moverHacia(izquierda)}, 25)
    keyboard.right().whilePressedDo({helado.moverHacia(derecha)}, 25)
    keyboard.up().whilePressedDo({helado.moverHacia(arriba)}, 25)
    keyboard.down().whilePressedDo({helado.moverHacia(abajo)}, 25)
    keyboard.space().onPressDo({ manejadorDeHielo.accionar() })

    game.onCollideDo(helado, {elemento => elemento.recibirChoqueDe(helado)})

    
    // TEMPORAL, solo para probar q el nivel 2 se gebere bueb 
    //dsp vemos como hacer para que se genere al comer todas las frutas
      // creo que con meter pasar de nivel al creador de las frutas funca 
    keyboard.n().onPressDo({ self.pasarDeNivel() })
  }


  method pasarDeNivel() {
    nivelActual = nivelActual.siguienteNivel()
    game.clear()
    helado.reiniciar()
    self.iniciar()
  }
}

object manejadorDeEnemigos {
    const listaDeEnemigos = []
    
    method cargarEnemigos(nuevosEnemigos) {
        listaDeEnemigos.clear()
        listaDeEnemigos.addAll(nuevosEnemigos)
        listaDeEnemigos.forEach({ enemigo => game.addVisual(enemigo) })
    }

    method moverEnemigos () {
      listaDeEnemigos.forEach{enemigo => enemigo.movete()}
    }

    method hayEnemigoEn(destino) { //para preguntar cuando creamos hielos
      return listaDeEnemigos.any({ enemigo => enemigo.position() == destino })
    }

}
object cartelReintentar inherits Ornamental {
  method position() = game.at(3, 7)
  method text() = "GAME OVER - Apretá R para reintentar"
  method textColor() = "FF0000FF"   // rojo

  method mostrar() {
    game.addVisual(self)
    keyboard.r().onPressDo({ self.reintentar() })
  }

  method reintentar() {
    game.clear()          // saca todos los visuals, teclas, ticks y colisiones
    helado.reiniciar()
    puntaje.reiniciar()
    configuracion.iniciar()
  }
}

object manejadorDeHielo {
  const hielos = []

  method accionar() {
    if (self.hayHieloEn(helado.posicionParaHielo())) {
      helado.iniciarRompidaDeHielo()
      helado.continuarRompidaDeHielo()
    } else {
      helado.iniciarTiraDeHielo()
      helado.continuarTiraDeHielo()
    }
  }

  method hayHieloEn(destino) {
    return hielos.any({ hielo => hielo.position() == destino })
  }

  method hieloEn(destino) {
    return hielos.find({ hielo => hielo.position() == destino })
  }

    method crearHieloEn(destino) {
        self.agregarHielo(new Hielo(position = destino))
    }

    method crearHieloResistenteEn(destino) {
        self.agregarHielo(new HieloResistente(position = destino))
    }

    method agregarHielo(hielo) {
        hielos.add(hielo)
        game.addVisual(hielo)
    }

    method romperHieloEn(destino) {
        const hielo = self.hieloEn(destino)
        hielo.recibirGolpe()
        if (hielo.estaRoto()) {
            hielos.remove(hielo)
            game.removeVisual(hielo)
        }
    }

  method reiniciar() {
    hielos.clear()
  }
}