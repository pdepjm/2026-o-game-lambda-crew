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
    nivelActual.mostrarIndicadores()


    tick.start()
    tick2.start()
    
    keyboard.left().whilePressedDo({helado.moverHacia(izquierda)}, 75)
    keyboard.right().whilePressedDo({helado.moverHacia(derecha)}, 75)
    keyboard.up().whilePressedDo({helado.moverHacia(arriba)}, 75)
    keyboard.down().whilePressedDo({helado.moverHacia(abajo)}, 75)
    keyboard.space().onPressDo({ manejadorDeHielo.accionar() })

    game.onCollideDo(helado, {elemento => elemento.recibirChoqueDe(helado)})
    keyboard.n().onPressDo({ self.pasarDeNivel() })
    keyboard.v().onPressDo({ self.volverAEmpezar() })
  }

  method nivelCompletado() {
    helado.detener()              
    pantallaContinuar.mostrar()
  }


  method pasarDeNivel() {
    nivelActual = nivelActual.siguienteNivel()
    game.clear()
    helado.reiniciar()
    self.iniciar()
  }
    method volverAEmpezar() {
    nivelActual = nivelActual.nivelInicial()
    game.clear()
    helado.reiniciar()
    self.iniciar()
  }
}


//====== MENU =======
object imagenMenu {
  method position() = game.origin()
  method image() = "placeholders/menu.png"
}

object menuInicio {
  method mostrar() {
    game.addVisual(imagenMenu)
    keyboard.enter().onPressDo({ self.empezar() })
  }

  method empezar() {
    game.clear()                 
    configuracion.iniciar()     
  }
}

//======== Menu para pasar nivel ====== 
object imagenContinuar {
  method position() = game.origin()
  method image() = "placeholders/continuar.png"
}

object pantallaContinuar {
  method mostrar() {
    game.addVisual(imagenContinuar)
    game.addVisual(puntaje)
    keyboard.enter().onPressDo({ configuracion.pasarDeNivel() })
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
object textoGameOver inherits Ornamental {
  method position() = game.at(4, 7)
  method image() = "placeholders/gameOver.png"
}

object textoReintentar inherits Ornamental{
  method position() = game.at(4, 6)
  method image() = "placeholders/reintentar.png"
}

object cartelReintentar inherits Ornamental {
  method mostrar() {
    game.addVisual(textoGameOver)
    game.addVisual(textoReintentar)
    keyboard.r().onPressDo({ self.reintentar() })
  }

  method reintentar() {
    game.clear()
    helado.reiniciar()
    puntaje.reiniciar()
    configuracion.iniciar()
  }
}

object manejadorDeHielo {
  const hielos = []

   method accionar() {
    if (self.hayHieloEn(helado.posicionParaHielo())) {
      helado.romperHielo()
    } else {
      helado.tirarHielo()
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
    self.refrescarEn(hielo.position()) // señal de q aparecio un iceFrioHielo  
  }

  //avisa que cambio algo en la celda --> apareció un hielo 
  method refrescarEn(posicion) {
    if (self.hayHieloEn(posicion)) {
      self.hieloEn(posicion).actualizarImagen()
    }
    configuracion.nivelActual().refrescarCongelamientoEn(posicion)
  }
  method romperHieloEn(destino) {
      const hielo = self.hieloEn(destino)
      hielo.recibirGolpe()
      if (hielo.estaRoto()) {
          hielos.remove(hielo)
          game.removeVisual(hielo)
      }
    self.refrescarEn(destino)
  }

  method reiniciar() {
    hielos.clear()
  }
}