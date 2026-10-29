import enemigos.*
import frutas.*
import helado.*
import extras.*
import direcciones.*
import niveles.*
import powerUps.*

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
    game.addVisual(acelerador)
    game.addVisual(relentizador)

    tick.start()
    tick2.start()
    
    keyboard.left().whilePressedDo({helado.moverHacia(izquierda)}, 25)
    keyboard.right().whilePressedDo({helado.moverHacia(derecha)}, 25)
    keyboard.up().whilePressedDo({helado.moverHacia(arriba)}, 25)
    keyboard.down().whilePressedDo({helado.moverHacia(abajo)}, 25)
    keyboard.space().onPressDo({ manejadorDeHielo.accionar() })

    game.onCollideDo(helado, {elemento => elemento.recibirChoqueDe(helado)})

    manejadorDeEnemigos.crearEnemigosMovRect()
    
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
    // En primera instancia quería hacer addVisual y add enemigo a lista de enemigos todo junto, pero por errores en wollok
    // lo tuve que hacer todo separado y queda muy largo el method. Es lo que hay por ahora
    method crearEnemigosMovRect () {
      listaDeEnemigos.clear()
      const enemigo1 = new EnemigoRectangular (x=0,lix=0,lsx=14,y=14,liy=0,lsy=14)
      const enemigo2 = new EnemigoRectangular (x=14,lix=0,lsx=14,y=0,liy=0,lsy=14)
      const enemigo3 = new EnemigoRectangular (x=4,lix=4,lsx=10,y=10,liy=4,lsy=10)
      const enemigo4 = new EnemigoRectangular (x=10,lix=4,lsx=10,y=4,liy=4,lsy=10)

      game.addVisual (enemigo1)
      game.addVisual (enemigo2)
      game.addVisual (enemigo3)
      game.addVisual (enemigo4)

      listaDeEnemigos.add(enemigo1)
      listaDeEnemigos.add(enemigo2)
      listaDeEnemigos.add(enemigo3)
      listaDeEnemigos.add(enemigo4)
    }

    method moverEnemigos () {
      listaDeEnemigos.forEach{enemigo => enemigo.movete()}
    }

    method hayEnemigoEn(destino) { //para preguntar cuando creamos hielos
      return listaDeEnemigos.any({ enemigo => enemigo.position() == destino })
    }
}

object cartelReintentar {
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

  method accionar() {
    if (helado.hayHieloEn(helado.posicionParaHielo())) {
      helado.iniciarRompidaDeHielo()
      helado.continuarRompidaDeHielo()
    } else {
      helado.iniciarTiraDeHielo()
      helado.continuarTiraDeHielo()
    }
  }
}