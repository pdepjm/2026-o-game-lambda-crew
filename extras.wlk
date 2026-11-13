import enemigos.*
import manejadores.*
import frutas.*
import helado.*

class Ornamental {
  method recibirChoqueDe(unHelado) { }
}

object puntaje inherits Ornamental{
  var puntos = 0
  method position() = game.at(14,14)
  method text() = ("Puntos: "+ self.puntos())
  method puntos() = puntos
  method sumarPuntos(punt) {
    puntos += punt
  }
  method reiniciar() {
  puntos = 0
  }
}


//Ahora esto solo es el cartel, no calcula nada 
object cantFrut inherits Ornamental {
  method position() = game.at(3, 14)
  method text() = "Frutas Comidas: " + configuracion.nivelActual().frutasComidas() + "/" + configuracion.nivelActual().totalFrutas()
}

// las paredes las pasamos a clases asi creamos muchas asl crear niveles (queda ifual solo ponemos class)
class Pared inherits Ornamental {
  const property position
  method image() = "placeholders/pared.jpg"
  
}
class IndicadorFruta inherits Ornamental {
    const property tipo
    const imagenGris
    const imagenColor
    var property position = game.origin()
    var completo = false

    method image() =if (completo) imagenColor else imagenGris

    method actualizar() {
      completo = configuracion.nivelActual().completoTipo(tipo)
    }
}

const indicadorFrambuesa = new IndicadorFruta(
    tipo = "frambuesa",
    imagenGris = "placeholders/frambuesaGris.png",
    imagenColor = "placeholders/frambuesaIndicador.png"
)

const indicadorUva = new IndicadorFruta(
    tipo = "uva",
    imagenGris = "placeholders/uvaGris.png",
    imagenColor = "placeholders/uvaIndicador.png"
)

const indicadorKiwi = new IndicadorFruta(
    tipo = "kiwi",
    imagenGris = "placeholders/kiwiGris.png",
    imagenColor = "placeholders/kiwiIndicador.png"
)
object cartelVictoria inherits Ornamental {
  method position() = game.at(3, 7)
  method text() = "¡GANASTE! Puntos: " + puntaje.puntos()
  method textColor() = "00FF00FF"
}
