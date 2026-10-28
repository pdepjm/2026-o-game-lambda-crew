import velocidades.*

class ModificadorDeVelocidad {

    const imagen
    const x
    const y
    const velocidad
    
    method image () = imagen 

    var property position = game.at(x,y)

    method aplicarEfecto (unHelado) {
        unHelado.cambiarVelocidad(velocidad)
        game.schedule(10000, {unHelado.cambiarVelocidad(normal)})
    }

    method recibirChoqueDe(unHelado) {
        game.removeVisual(self)
        self.aplicarEfecto(unHelado)
    }
}

const acelerador = new ModificadorDeVelocidad (imagen = "placeholders/diesel.jpg", x=13, y=13, velocidad = veloz)
const relentizador = new ModificadorDeVelocidad (imagen = "placeholders/copito.jpg", x=6, y=6, velocidad = lento)