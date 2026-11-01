import manejadores.*


class Hielo {
    var property position

    method image() {
        const frutaPuntual = configuracion.nivelActual().frutaEn(self.position())

        if (configuracion.nivelActual().hayFrutaEn(self.position())) {
            return frutaPuntual.imagenCongelada()
        } else {
            return "placeholders/hielo.png"
        }
    }
}