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
