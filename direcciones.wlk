object derecha {
    method mover (objeto) {
        objeto.moverA(objeto.position().right(1))
    }
        method posicionSiguiente(posicion) {
        return posicion.right(1)
    }
    method opuesta() = izquierda
}

object izquierda {
    method mover (objeto) {
        objeto.moverA(objeto.position().left(1))
    }
    method posicionSiguiente(posicion) {      
    return posicion.left(1)
    }
    method opuesta() = derecha
}

object arriba {
    method mover (objeto) {
        objeto.moverA(objeto.position().up(1))
    }
    method posicionSiguiente(posicion) {
    return posicion.up(1)
    }
    method opuesta() = abajo
}

object abajo {
    method mover (objeto) {
        objeto.moverA(objeto.position().down(1))
    }
    method posicionSiguiente(posicion) {
    return posicion.down(1)
    }
    method opuesta() = arriba
}