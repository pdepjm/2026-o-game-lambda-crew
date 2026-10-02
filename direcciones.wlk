object derecha {
    method mover (objeto) {
        objeto.moverA(objeto.position().right(1))
    }
}

object izquierda {
    method mover (objeto) {
        objeto.moverA(objeto.position().left(1))
    }
}

object arriba {
    method mover (objeto) {
        objeto.moverA(objeto.position().up(1))
    }
}

object abajo {
    method mover (objeto) {
        objeto.moverA(objeto.position().down(1))
    }
}