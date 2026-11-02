import manejadores.*

class Hielo {
    var property position
    var roto = false

    method image() {
        const frutaPuntual = configuracion.nivelActual().frutaEn(self.position())

        if (configuracion.nivelActual().hayFrutaEn(self.position())) {
            return frutaPuntual.imagenCongelada()
        } else {
            return "placeholders/hielo.png"
        }
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