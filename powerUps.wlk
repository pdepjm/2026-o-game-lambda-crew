import velocidades.*

class ModificadorDeVelocidad {

    const imagen
    const x
    const y
    const velocidad

    var property position = game.at(x, y)

    method image() = imagen

    method aplicarEfecto(unMovil) {
        unMovil.cambiarVelocidadTemporalmente(velocidad, 10000)
    }

    method recibirChoqueDe(unMovil) {
        game.removeVisual(self)
        self.aplicarEfecto(unMovil)
    }
}

const acelerador = new ModificadorDeVelocidad(imagen = "placeholders/diesel.jpg", x = 13, y = 13, velocidad = veloz)
const relentizador = new ModificadorDeVelocidad(imagen = "placeholders/copito.jpg", x = 6, y = 6, velocidad = lento)