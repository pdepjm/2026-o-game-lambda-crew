import wollok.game.*
import helado.*
import extras.*
import frutas.*

class Nivel {
    const initialGridMap

    const property siguienteNivel

    const paredes = []
    const frutas = []
    const enemigos = []
    var posicionInicialHelado = game.origin()

    //Logica similar al reiniciar 
    //Borramos paredes, dibujamos y metemos al heladito en el origen
    method iniciar (){
        paredes.clear() //de momento solo pares, si queremos borrar todo, abstraemos (self.clearpositions())
        frutas.clear()
        enemigos.clear()
        self.dibujarMapa() // Si queremos poner menu lo tenemos que poner aca abajo
       
        helado.position(posicionInicialHelado) 
    }

    method dibujarMapa(){
        var y = game.height() - 1

        //Usamos el foreach de mate con las frutas para recorrer todo el mapa 
        //En cada columna en y recorremos la fila en x 
        //aplicamos el metodo decode en cada celda que van a entender todos los objetos gracias al POLIMORFISMO 
        initialGridMap.forEach({fila => var x = 0 fila.forEach({celda => celda.decode(x, y, self) x += 1 }) y -= 1 })
    }

    //Como las paredes las paredes se crean por nivel lo ponemos aca 
    //quizas dsp hay que pasarlo a un generador de paredes o algo asi 

    method agregarPared(x, y) {
        const pared = new Pared(position = game.at(x, y))
        game.addVisual(pared)
        paredes.add(pared)
    }

    method agregarFrambuesa(x, y){
        const fruta = new Frambuesa(position = game.at(x, y))
        game.addVisual(fruta)
        frutas.add(fruta)
    }

    method agregarUva(x, y){
        const fruta = new Uva(position = game.at(x, y))
        game.addVisual(fruta)
        frutas.add(fruta)
    }
    /*  
    method agregarEnemigo(x, y){
        const enemigo = new EnemigoRectangular(position = game.at(x, y))
        game.addVisual(enemigo)
        enemigos.add(enemigo)
    }
    */
    // misma lógica que hayHieloEn --> Lo sacamos de helado y lo ponemos aca 
    method hayParedEn(destino) = paredes.any({ pared => pared.position() == destino })
    
    method posicionInicialHelado(posicion) {
        posicionInicialHelado = posicion
     }
}

// ---------- Celdas (todas polimórficas jsjs: entienden decode) ----------

//Creador de suelo
object _ {
  method decode(x, y, nivel) {}
}

object p {
  method decode(x, y, nivel) {
    nivel.agregarPared(x, y) 
    }
}

object h {
  method decode(x, y, nivel) {
    nivel.posicionInicialHelado(game.at(x, y)) 
    }
}

object e {
    method decode(x, y, nivel) {
        nivel.agregarEnemigo(x, y)
    }
}

object f {
    method decode(x, y, nivel) {
        nivel.agregarFrambuesa(x, y)
    }
}

object u {
    method decode(x, y, nivel) {
        nivel.agregarUva(x, y)
    }
}
//================== NIVELEEEEES =========================

const nivel1 = new Nivel(
    initialGridMap = [
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //1 
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //2
        [_,_,_,f,_,_,_,_,_,_,_,_,_,_,_], //3
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //4
        [_,_,_,f,_,_,_,_,_,_,u,_,_,_,_],
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_],
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_], // 7
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //CENTRO 
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_], //7
        [_,_,_,f,_,p,_,_,_,p,_,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,u,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //4
        [_,_,_,f,_,_,_,u,_,_,u,_,_,_,_], //3
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //2
        [h,_,_,_,_,_,_,_,_,_,_,_,_,_,_]  //1
    ], 
    siguienteNivel = nivel2
) 

const nivel2 = new Nivel(
    initialGridMap = [
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //1 
        [_,p,p,_,_,_,_,_,_,_,_,_,p,p,_], //2
        [_,p,_,_,_,_,_,_,_,_,_,_,_,p,_], //3
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //4
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,p,p,p,p,p,_,_,_,_,_],
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_], // 7
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //CENTRO 
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_], //7
        [_,_,_,_,_,p,p,p,p,p,_,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //4
        [_,p,_,_,_,_,_,_,_,_,_,_,_,p,_], //3
        [_,p,p,_,_,_,_,_,_,_,_,_,p,p,_], //2
        [h,_,_,_,_,_,_,_,_,_,_,_,_,_,_]  //1
    ], 
    siguienteNivel = finDelJuego
) 

object finDelJuego {
  method iniciar() {}
  method hayParedEn(posicion) = false
  method siguienteNivel() = self
}
/*  method agregarFrmbuesa() {
    frutaActual = "frambuesa"
    const limiteX = game.width() - 1
    const limiteY = game.height() - 1

    (0..limiteX).forEach { posicionEnX =>
      (0..limiteY).forEach { posicionEnY =>
        
        if (posicionEnY.odd() && posicionEnX.even()) {
          const nuevaFrambuesa = new Fruta(x = posicionEnX, y = posicionEnY, imagen = "placeholders/frambuesa.jpg", puntos = 100)
          game.addVisual(nuevaFrambuesa)
          frambuesasCreadas.add(nuevaFrambuesa)
          cantidadDeFrutas+=1
        }
      }
    }
  }
  }
  */
  /*
  method crearUvas() {
    frutaActual = "uva"
    const limiteX = game.width() - 1
    const limiteY = game.height() - 1
    const columnas = [2,8,14]

    (0..limiteX).forEach { posicionEnX =>
      (0..limiteY).forEach { posicionEnY =>
        
        if (columnas.contains(posicionEnY) && posicionEnX.odd()) {
          const nuevaUva = new FrutaRectangular()
          game.addVisual(nuevaUva)
          uvasCreadas.add(nuevaUva)
          cantidadDeFrutas+=1
        }
      }
    }
  }
  */