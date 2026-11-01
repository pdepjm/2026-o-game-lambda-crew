import movimientoRectangular.*
import helado.*
import manejadores.*
import frutas.*
import powerUps.*
import extras.*
import direcciones.*

// Clase de enemigos con movimiento rectangular
class EnemigoRectangular inherits MovimientoRectangular{
  method recibirChoqueDe(unHelado) {
  unHelado.morir()
}
}


