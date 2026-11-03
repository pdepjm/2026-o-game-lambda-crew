import manejadores.*
import extras.*

class Hielo inherits Ornamental {
    var property position
    var roto = false
    var imagenActual = "placeholders/hielo.png"

    method image() = imagenActual

    //si hay una fruta en su celda cambia su imagen a la congelada
    method actualizarImagen() {
        const fruta = configuracion.nivelActual().frutaEn(position)
        imagenActual = if (fruta == null) "placeholders/hielo.png" else fruta.imagenCongelada()
    }
    // el hielo común se rompe con un solo golpe
    method recibirGolpe() {
        roto = true
    }

    method estaRoto() = roto
}

// se rompe recién al segundo golpe
class HieloResistente inherits Hielo {
    var golpesRestantes = 2

    override method image() = "placeholders/ice.jpg"

    override method recibirGolpe() {
        golpesRestantes -= 1
    }

    override method estaRoto() = golpesRestantes <= 0
}