import enemigos.*
import frutas_y_powerups.*
import helado.*
import extras.*
import direcciones.*

object configuracion {
  method iniciar() {
    const tick = game.tick(666, { manejadorDeEnemigos.moverEnemigos() }, false)

    game.addVisual(helado)
    game.addVisual(pared)
    game.addVisual(puntaje)
    game.addVisual(cantFrut)
    game.addVisual(acelerador)
    game.addVisual(relentizador)

    tick.start()

    keyboard.left().whilePressedDo({helado.moverHacia(izquierda)}, helado.velocidad())
    keyboard.right().whilePressedDo({helado.moverHacia(derecha)}, helado.velocidad())
    keyboard.up().whilePressedDo({helado.moverHacia(arriba)}, helado.velocidad())
    keyboard.down().whilePressedDo({helado.moverHacia(abajo)}, helado.velocidad())

    game.onCollideDo(helado, {elemento => elemento.recibirChoqueDe(helado)})

    creadorDeFrutas.crearFrambuesas()
    manejadorDeEnemigos.crearEnemigosMovRect()
  }
}
object creadorDeFrutas {

  var cantidadDeFrutas = 0

  method crearFrambuesas() {
    cantidadDeFrutas = 0
    const limiteX = game.width() - 1
    const limiteY = game.height() - 1

    (0..limiteX).forEach { posicionEnX =>
      (0..limiteY).forEach { posicionEnY =>
        
        if (posicionEnY.odd() && posicionEnX.even()) {
          game.addVisual(new Fruta(x = posicionEnX, y = posicionEnY, imagen = "placeholders/frambuesa.jpg"))
          cantidadDeFrutas +=1
        }
      }
    }
  }

  method cantidadDeFrutas () = cantidadDeFrutas
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
    cantFrut.reiniciar()
    configuracion.iniciar()
  }
}