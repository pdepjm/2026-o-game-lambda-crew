import direcciones.*
import helado.*

class MovimientoRectangular {

    method image() = "placeholders/enemigo.jpg" 
    const x
    const y
    // ls = limite superior
    const lsy
    const lsx
    // li = limite inferior
    const liy
    const lix
    var property position = game.at(x,y)
    var sentido = derecha
    var horario = true

    method movete () {
        self.evaluarMovimiento()
        sentido.mover(self)
    }

    method moverA(destino) {                         
        // HAY QUE CAMBIAR QUE HELADO TENGA ESE METODO, ES RE GOD OBJECT 
        if (helado.hayHieloEn(destino)) {   // hay hielo: se da vuelta
            horario = !horario
            sentido = sentido.opuesta()
        } else {
            position = destino
        }
    }

    method evaluarMovimiento() {
        if (position == game.at(lsx,lsy)) {
            sentido = if (horario) abajo else izquierda
        } else if (position == game.at(lsx,liy)) {
            sentido = if (horario) izquierda else arriba
        } else if (position == game.at(lix,liy)) {
            sentido = if (horario) arriba else derecha
        } else if (position == game.at(lix,lsy)) {
            sentido = if (horario) derecha else abajo
        }
  }
}