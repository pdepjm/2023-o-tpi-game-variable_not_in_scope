import wollok.game.*

object config {
	
	method x()=game.center().x()-3
	method alturaPiso() = 6 //308
	method alturaPlataforma() = 13
	method alturaNave() = 14
	
	method velRetroceso() = 45
	method alturaSalto() = 3
	
	method frecuenciaPinchos() = 1500
	method frecuenciaBloques() = 800
	method frecuenciaColumna() = 500
	
	method blockDistance() = 7
	
	method tiempoPiso() = 15000
	method tiempoPlataforma() = 10000  
	method tiempoNave() = 15000
	method tiempoArania() = 15000
	method loseDelay() = 3000
	method columnaAlta()=15
	method techo()=14
	
	method imgEspina() = "./assets/Espina.png"
	method imgPortal() = "./assets/portal.jpg"
	method imgPortalRotado() = "./assets/portal_rotado.png"
	method imgBloque() = "./assets/bloque.png"
	method imgColumna() = "./assets/columna.png"
}
