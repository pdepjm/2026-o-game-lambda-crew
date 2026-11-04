import wollok.game.*
import helado.*
import extras.*
import frutas.*
import manejadores.*
import movimientoRectangular.*
import enemigos.*
import velocidades.*
import powerUps.*

class Nivel {
    const initialGridMap

    const property siguienteNivel
    const property nivelInicial

    const paredes = []
    var posicionInicialHelado = game.origin()

    //Para generar una y dsp la otra generamos todo junto pero solo mostramos las activas
    const frutasActivas = []    // las que están visibles ahora
    const frutasEnEspera = []   // las que van a aparecer al comer todas las otras
    const todasLasFrutas = []
    var totalXFase = 0

    //Logica similar al reiniciar 
    //Borramos paredes, dibujamos y metemos al heladito en el origen
    method iniciar (){
        paredes.clear() //de momento solo pares, si queremos borrar todo, abstraemos (self.clearpositions())
        frutasActivas.clear()
        frutasEnEspera.clear()
        todasLasFrutas.clear()
        totalXFase = 0    
        self.dibujarMapa() // Si queremos poner menu lo tenemos que poner aca abajo
        manejadorDeEnemigos.cargarEnemigos(self.crearEnemigos())
       
        helado.position(posicionInicialHelado) 
    }

    method crearEnemigos() = []

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
    const fruta = new Frambuesa(position = game.at(x, y))
    todasLasFrutas.add(fruta)
    self.mostrarFruta(fruta)
}

method agregarUva(x, y) {
    const fruta = new Uva(position = game.at(x, y))
    todasLasFrutas.add(fruta)
    frutasEnEspera.add(fruta)
}

method agregarKiwi(x, y) {
    const recorrido = new MovimientoRectangular(x = x, y = y, lix = x, lsx = x + 4, lsy = y, liy = y - 4)
        const fruta = new Kiwi(position = game.at(x, y), movimiento = recorrido)
        todasLasFrutas.add(fruta)
       self.mostrarFruta(fruta)
 }

    //El nivel le dice a las frutas que se muevan
    method moverFrutas() {
        frutasActivas.forEach({ fruta => fruta.movete() })
    }

    //le pide al nivel que busque la fruta de esa celda y la actualice
    method refrescarCongelamientoEn(posicion) {
        const fruta = self.frutaEn(posicion)
        if (fruta != null) {
            fruta.actualizarCongelamiento()
        }
    }
    //Muestra solo las acitvas
    method mostrarFruta(fruta) {
        game.addVisual(fruta)
        frutasActivas.add(fruta)
        totalXFase += 1
        manejadorDeHielo.refrescarEn(fruta.position())   // por si aparece sobre un hielo (fase 2)
    }

    //Como es por nivel, la implementacion depende del nivel, entonces va aca
    method totalFrutas() = totalXFase
    method frutasComidas() = totalXFase - frutasActivas.size()

    method hayFrutasDeTipo(tipo) =
    todasLasFrutas.any({ fruta => fruta.tipo() == tipo })

method completoTipo(tipo) =
    todasLasFrutas
        .filter({ fruta => fruta.tipo() == tipo })
        .all({ fruta => fruta.comida() })

method mostrarIndicadores() {
    const presentes = [indicadorFrambuesa, indicadorUva, indicadorKiwi]
        .filter({ indicador => self.hayFrutasDeTipo(indicador.tipo()) })

    var x = 0

    presentes.forEach({ indicador =>
        indicador.position(game.at(x, 14))
        game.addVisual(indicador)
        x += 1
    })
}

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
    
    // misma lógica que hayHieloEn --> Lo sacamos de helado y lo ponemos aca 
    method hayParedEn(destino) = paredes.any({ pared => pared.position() == destino })

    method hayFrutaEn(destino) = frutasActivas.any({ fruta => fruta.position() == destino })
  
    // Este lo usamos para pedirle la fruta exacta y robarle la imagen
    method frutaEn(destino) = frutasActivas.findOrDefault({ fruta => fruta.position() == destino }, null)
    
    method posicionInicialHelado(posicion) {
        posicionInicialHelado = posicion
     }

     method agregarHielo(x, y) {
        manejadorDeHielo.crearHieloEn(game.at(x, y))
    }

    method agregarHieloResistente(x, y) {
        manejadorDeHielo.crearHieloResistenteEn(game.at(x, y))
    }

    method agregarAcelerador(x, y) {
    game.addVisual(new ModificadorDeVelocidad(imagen = "placeholders/diesel.jpg", x = x, y = y, velocidad = veloz))
}

    method agregarRelentizador(x, y) {
    game.addVisual(new ModificadorDeVelocidad(imagen = "placeholders/copito.jpg", x = x, y = y, velocidad = lento))
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

object r { //hielo resistente
    method decode(x, y, nivel) {
        nivel.agregarHieloResistente(x, y)
    }
}

object a { //acelerador
  method decode(x, y, nivel) {
    nivel.agregarAcelerador(x, y)
  }
}

object l { //relentizador
  method decode(x, y, nivel) {
    nivel.agregarRelentizador(x, y)
  }
}


//================== NIVELEEEEES =========================

object nivel1 inherits Nivel(
    initialGridMap = [
        [_,u,u,u,_,_,_,i,_,_,_,u,u,u,_], //1 
        [_,f,f,f,_,_,_,i,_,_,_,f,f,f,_], //2
        [_,f,_,_,a,_,_,i,_,_,l,_,_,f,_], //3
        [_,f,_,_,_,_,_,i,_,_,_,_,_,f,_], //4
        [_,_,_,_,_,_,_,i,_,f,f,_,_,_,_],
        [u,_,_,_,_,p,p,i,p,p,f,_,_,_,u],
        [u,_,_,_,_,p,u,_,u,p,_,_,_,_,u], // 7
        [i,i,i,i,i,i,_,_,_,i,i,i,i,i,i], //CENTRO 
        [u,_,_,_,_,p,u,_,u,p,_,_,_,_,u], //7
        [u,_,_,_,f,p,p,i,p,p,_,_,_,_,u],
        [_,_,_,_,f,f,_,i,_,_,_,_,_,_,_],
        [_,f,_,_,l,_,_,i,_,_,a,_,_,f,_], //4
        [_,f,_,_,_,_,_,i,_,_,_,_,_,f,_], //3
        [_,f,f,f,_,_,_,i,_,_,_,f,f,f,_], //2
        [h,u,u,u,_,_,_,i,_,_,_,u,u,u,_]  //1
    ],
    siguienteNivel = nivel2,
    nivelInicial = self
){
    override method crearEnemigos() {
        return [
            new EnemigoRectangular(x=0, lix=0, lsx=14, y=14, liy=0, lsy=14),
            new EnemigoRectangular(x=14, lix=0, lsx=14, y=0, liy=0, lsy=14),
            new EnemigoRectangular(x=4, lix=4, lsx=10, y=10, liy=4, lsy=10),
            new EnemigoRectangular(x=10, lix=4, lsx=10, y=4, liy=4, lsy=10)
        ]
    }
}

object nivel2 inherits Nivel(
    initialGridMap = [
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_], //1 
        [_,p,p,i,i,i,i,i,i,i,i,i,p,p,_], //2
        [_,p,a,_,_,_,f,f,f,_,_,_,_,p,_], //3
        [_,i,_,_,_,_,f,f,f,_,_,_,_,i,_], //4
        [_,i,_,_,_,_,_,_,_,_,_,_,_,i,_],
        [k,i,_,_,_,p,p,p,p,p,k,l,_,i,_],
        [_,i,_,_,_,p,_,_,_,p,_,_,_,i,_], // 7
        [_,i,_,_,_,_,_,h,_,_,_,_,_,i,_], //CENTRO 
        [_,i,_,_,_,p,_,_,_,p,a,_,_,i,_], //7
        [_,i,_,_,_,p,p,p,p,p,_,_,_,i,_],
        [k,i,_,_,_,_,_,_,_,_,k,_,_,i,_],
        [_,i,_,_,_,_,f,f,f,_,_,_,_,i,_], //4
        [_,p,_,_,_,_,f,f,f,_,_,_,l,p,_], //3
        [_,p,p,i,i,i,i,i,i,i,i,i,p,p,_], //2
        [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_]  //1
    ], 
    siguienteNivel = nivel3,
    nivelInicial = nivel1
){
    override method crearEnemigos() {
        return [
            new EnemigoRompeHielo(x=0, lix=0, lsx=14, y=14, liy=0, lsy=14),
            new EnemigoRompeHielo(x=14, lix=0, lsx=14, y=0, liy=0, lsy=14)
        ]
    }
}

object nivel3 inherits Nivel(
    initialGridMap = [
        [_,u,u,u,_,_,_,_,_,_,_,u,u,u,_], //1 
        [_,f,f,f,_,_,_,_,_,_,_,f,f,f,_], //2
        [_,f,_,_,_,_,_,_,_,_,_,_,p,f,_], //3
        [_,f,_,_,_,_,_,_,_,_,_,_,p,f,_], //4
        [r,r,p,p,p,p,p,p,p,_,_,p,p,r,r],
        [u,_,_,_,_,_,_,_,_,l,l,_,_,_,u],
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u], // 7
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u], //CENTRO 
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u], //7
        [u,_,_,_,_,_,_,_,_,_,_,_,_,_,u],
        [r,p,p,r,p,r,r,p,r,r,p,r,r,p,r],
        [_,f,p,_,_,_,_,_,_,_,_,_,_,f,_], //4
        [_,f,p,_,_,_,a,_,_,_,_,_,_,f,_], //3
        [_,f,f,f,_,_,_,_,_,_,_,f,f,f,_], //2
        [h,u,u,u,_,_,_,_,_,_,_,u,u,u,_]  //1
    ], 
    siguienteNivel = nivel4,
    nivelInicial = nivel1
){
    override method crearEnemigos() {
        return [
            new EnemigoRectangular(x=0, lix=0, lsx=14, y=14, liy=0, lsy=14),
            new EnemigoRectangular(x=14, lix=0, lsx=14, y=0, liy=0, lsy=14),
            new EnemigoPerseguidor(position = game.at(14, 14))
        ]
}
    
}

object nivel4 inherits Nivel(
    initialGridMap = [
        [u,u,a,_,_,_,_,l,_,_,_,_,_,u,u], //1 
        [u,p,f,p,_,_,_,_,_,_,_,p,f,p,u], //2
        [_,i,f,i,_,_,_,_,_,_,_,i,f,i,_], //3
        [_,p,f,p,_,_,_,l,_,_,_,p,f,p,_], //4
        [_,i,f,i,_,_,_,_,_,_,_,i,f,i,_],
        [_,p,f,p,_,_,_,r,_,_,_,p,f,p,_],
        [_,_,_,_,_,_,r,u,r,_,_,_,_,_,_], // 7
        [_,_,a,_,_,r,u,u,u,r,_,_,a,_,_], //CENTRO 
        [_,_,_,_,_,_,r,u,r,_,_,_,_,_,_], //7
        [_,p,f,p,_,_,_,r,_,_,_,p,f,p,_],
        [_,i,f,i,_,_,_,_,_,_,_,i,f,i,_],
        [_,p,f,p,_,_,_,l,_,_,_,p,f,p,_], //4
        [_,i,f,i,_,_,_,h,_,_,_,i,f,i,_], //3
        [u,p,f,p,_,_,_,_,_,_,_,p,f,p,u], //2
        [u,u,_,_,_,_,_,l,_,_,_,_,a,u,u]  //1
    ], 
    siguienteNivel = finDelJuego,
    nivelInicial = nivel1
){
    override method crearEnemigos() {
        return [
            new EnemigoRompeHielo(x=0, lix=0, lsx=14, y=14, liy=0, lsy=14),
            new EnemigoRompeHielo(x=14, lix=0, lsx=14, y=0, liy=0, lsy=14),
            new EnemigoRompeHielo(x=10, lix=4, lsx=10, y=4, liy=4, lsy=10),
            new EnemigoRompeHielo(x=4, lix=4, lsx=10, y=10, liy=4, lsy=10),
            new EnemigoPerseguidorRompeHielo(position = game.at(14, 14)),
            new EnemigoPerseguidorRompeHielo(position = game.at(0, 14))
        ]
}
    
}

object finDelJuego {
  method iniciar() {
    manejadorDeEnemigos.cargarEnemigos([])
    helado.detener()
    game.addVisual(cartelVictoria)
  }
  method hayParedEn(posicion) = false
  method siguienteNivel() = self
  method nivelInicial() = nivel1
  method totalFrutas() = 0
  method frutasComidas() = 0
  method moverFrutas() {}
  method refrescarCongelamientoEn() {}
  method completoTipo(tipo) = false
}
