import wollok.game.*
import helado.*
import extras.*


class Nivel {
    const initialGridMap

    const property siguienteNivel

    const paredes = []
    var posicionInicialHelado = game.origin()

    //Logica similar al reiniciar 
    //Borramos paredes, dibujamos y metemos al heladito en el origen
    method iniciar (){
        paredes.clear() //de momento solo pares, si queremos borrar todo, abstraemos (self.clearpositions())
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

//================== NIVELEEEEES =========================

const nivel1 = new Nivel(
    initialGridMap = [
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //1 
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //2
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //3
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //4
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_],
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_], // 7
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //CENTRO 
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_], //7
        [_,_,_,_,_,p,_,_,_,p,_,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //4
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //3
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