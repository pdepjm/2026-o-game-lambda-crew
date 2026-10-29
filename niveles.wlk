import wollok.game.*
import helado.*
import extras.*
import frutas.*
import manejadores.*
import movimientoRectangular.*
import enemigos.*

class Nivel {
    const initialGridMap

    const property siguienteNivel

    const paredes = []
    const enemigos = []
    var posicionInicialHelado = game.origin()

    //Para generar una y dsp la otra generamos todo junto pero solo mostramos las activas
    const frutasActivas = []    // las que están visibles ahora
    const frutasEnEspera = []   // las que van a aparecer al comer todas las otras
    var totalXFase = 0

    //Logica similar al reiniciar 
    //Borramos paredes, dibujamos y metemos al heladito en el origen
    method iniciar (){
        paredes.clear() //de momento solo pares, si queremos borrar todo, abstraemos (self.clearpositions())
        frutasActivas.clear()
        frutasEnEspera.clear()
        enemigos.clear()
        totalXFase = 0    
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


    //============ FASES DE FRUTAS ===================
    //aca ponemos todo lo q refiera a la generacion de frutas x nivel 
    //con fase queremos decir FASE 1 frambuesas y FASE 2 uvas por ej 

    method agregarFrambuesa(x, y) { 
        self.mostrarFruta(new Frambuesa(position = game.at(x, y))) 
        }
    method agregarUva(x, y){
         frutasEnEspera.add(new Uva(position = game.at(x, y))) 
    }
    method agregarKiwi(x, y) {
        const recorrido = new MovimientoRectangular(
            x = x, y = y,
            lix = x, lsx = x + 4,
            lsy = y, liy = y - 4
        )
        self.mostrarFruta(new Kiwi(position = game.at(x, y), movimiento = recorrido))
    }

    //El nivel le dice a las frutas que se muevan
    method moverFrutas() {
        frutasActivas.forEach({ fruta => fruta.movete() })
    }

    //Muestra solo las acitvas
    method mostrarFruta(fruta) {
        game.addVisual(fruta)
        frutasActivas.add(fruta)
        totalXFase += 1
    }

    //Como es por nivel, la implementacion depende del nivel, entonces va aca
    method totalFrutas() = totalXFase
    method frutasComidas() = totalXFase - frutasActivas.size()

    //Esto no se si va aca pero de momento creo que no hay otra forma 
    //de avanzar la fase
    method frutaComida(fruta) {
        frutasActivas.remove(fruta)
        if (frutasActivas.isEmpty()) {
            self.avanzarFase()
        }
    }

    method avanzarFase() {
        if (frutasEnEspera.isEmpty()) {
            game.schedule(100, { configuracion.pasarDeNivel() })  // no quedan fases: siguiente nivel
        } else {
            totalXFase = 0
            frutasEnEspera.forEach({ fruta => self.mostrarFruta(fruta) })
            frutasEnEspera.clear()
        }
    }

    //================ FIN FRUTAS ===================

    // Igual que el Kiwi: la celda es la esquina superior izquierda del recorrido
    method agregarEnemigo(x, y, lado) {
        const recorrido = new MovimientoRectangular(
            x = x, y = y,
            lix = x, lsx = x + lado,
            lsy = y, liy = y - lado
        )
        const enemigo = new Enemigo(position = game.at(x, y), movimiento = recorrido)
        game.addVisual(enemigo)
        enemigos.add(enemigo)
    }

    // misma logica que el kiwi, el nivel los mueve
    method moverEnemigos() {
        enemigos.forEach({ enemigo => enemigo.movete() })
    }

    // reemplaza al hayEnemigoEn del manejadorDeEnemigos
    method hayEnemigoEn(destino) = enemigos.any({ enemigo => enemigo.position() == destino })

    // misma lógica que hayHieloEn --> Lo sacamos de helado y lo ponemos aca 
    method hayParedEn(destino) = paredes.any({ pared => pared.position() == destino })
    
    method posicionInicialHelado(posicion) {
        posicionInicialHelado = posicion
     }

     method agregarHielo(x, y) {
        manejadorDeHielo.crearHieloEn(game.at(x, y))
    }
}

// ---------- Celdas (todas polimórficas jsjs: entienden decode) ----------

//Creador de suelo
object _ {
  method decode(x, y, nivel) {}
}

object p { //pared
  method decode(x, y, nivel) {
    nivel.agregarPared(x, y) 
    }
}

object h { //helado
  method decode(x, y, nivel) {
    nivel.posicionInicialHelado(game.at(x, y)) 
    }
}

object e { //enemigo 
    method decode(x, y, nivel) {
        nivel.agregarEnemigo(x, y, 10)
    }
}

object f { //frambuesa
    method decode(x, y, nivel) {
        nivel.agregarFrambuesa(x, y)
    }
}

object u { //uva
    method decode(x, y, nivel) {
        nivel.agregarUva(x, y)
    }
}

object k { //kiwi
  method decode(x, y, nivel) {
    nivel.agregarKiwi(x, y)
  }
}

object i { //hielo
  method decode(x, y, nivel) {
    nivel.agregarHielo(x, y)
  }
}
//================== NIVELEEEEES =========================

const nivel1 = new Nivel(
    initialGridMap = [
        [_,u,u,u,_,_,_,_,_,_,_,u,u,u,_], //1 
        [e,f,f,f,e,_,_,_,_,_,_,f,f,f,_], //2
        [_,f,e,_,_,_,_,_,_,_,_,_,_,f,_], //3
        [_,f,e,_,_,_,_,_,_,_,_,_,_,f,_], //4
        [_,_,_,_,_,_,_,_,_,f,f,_,_,_,_],
        [u,_,_,_,_,p,p,i,p,p,f,_,_,_,u],
        [u,_,_,_,_,p,u,_,u,p,_,_,_,_,u], // 7
        [u,_,_,_,_,i,_,_,_,i,_,_,_,_,u], //CENTRO 
        [u,_,_,_,_,p,u,_,u,p,_,_,_,_,u], //7
        [u,_,_,_,f,p,p,i,p,p,_,_,_,_,u],
        [_,_,_,_,f,f,_,_,_,_,_,_,_,_,_],
        [_,f,_,_,_,_,_,_,_,_,_,_,_,f,_], //4
        [_,f,_,_,_,_,_,_,_,_,_,_,_,f,_], //3
        [_,f,f,f,_,_,_,_,_,_,_,f,f,f,_], //2
        [h,u,u,u,_,_,_,_,_,_,_,u,u,u,_]  //1
    ], 
    siguienteNivel = nivel2
) 

const nivel2 = new Nivel(
    initialGridMap = [
        [k,_,_,_,_,_,_,_,_,_,k,_,_,_,_], //1 
        [_,p,p,i,i,i,i,i,i,i,i,i,p,p,_], //2
        [_,p,_,_,_,_,f,f,f,_,_,_,_,p,_], //3
        [_,i,_,_,_,_,f,f,f,_,_,_,_,i,_], //4
        [_,i,_,_,_,_,_,_,_,_,_,_,_,i,_],
        [k,i,_,_,_,p,p,p,p,p,k,_,_,i,_],
        [_,i,_,_,_,p,_,_,_,p,_,_,_,i,_], // 7
        [k,i,_,_,_,_,_,h,_,_,k,_,_,i,_], //CENTRO 
        [_,i,_,_,_,p,_,_,_,p,_,_,_,i,_], //7
        [_,i,_,_,_,p,p,p,p,p,_,_,_,i,_],
        [k,i,_,_,_,_,_,_,_,_,k,_,_,i,_],
        [_,i,_,_,_,_,f,f,f,_,_,_,_,i,_], //4
        [_,p,_,_,_,_,f,f,f,_,_,_,_,p,_], //3
        [_,p,p,i,i,i,i,i,i,i,i,i,p,p,_], //2
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]  //1
    ], 
    siguienteNivel = nivel3
) 

const nivel3 = new Nivel(
    initialGridMap = [
        [_,u,u,u,_,_,_,_,_,_,_,u,u,u,_], //1 
        [_,f,f,f,_,_,_,_,_,_,_,f,f,f,_], //2
        [_,f,_,_,_,_,_,_,_,_,_,_,_,f,_], //3
        [_,f,_,_,_,_,_,_,_,_,_,_,_,f,_], //4
        [_,_,_,_,_,_,_,_,_,f,f,_,_,_,_],
        [u,_,_,_,_,_,_,_,_,_,f,_,_,_,u],
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u], // 7
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u], //CENTRO 
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u], //7
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u],
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_],
        [_,f,_,_,_,_,_,_,_,_,_,_,_,f,_], //4
        [_,f,_,_,_,_,_,_,_,_,_,_,_,f,_], //3
        [_,f,f,f,_,_,_,_,_,_,_,f,f,f,_], //2
        [h,u,u,u,_,_,_,_,_,_,_,u,u,u,_]  //1
    ], 
    siguienteNivel = finDelJuego
) 

object finDelJuego {
  method iniciar() {}
  method hayParedEn(posicion) = false
  method siguienteNivel() = self
  method totalFrutas() = 0
  method frutasComidas() = 0
  method moverFrutas() {}
  method moverEnemigos() {}
  method hayEnemigoEn(posicion) = false
}
