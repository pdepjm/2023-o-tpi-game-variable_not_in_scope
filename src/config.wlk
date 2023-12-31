import wollok.game.*

object config {
	
	method x()=game.center().x()-3
	method alturaPiso() = 6 //308
	method alturaPlataforma() = 13
	method alturaNave() = 17
	
	method velRetroceso() = 45
	
	/*Configuracion del salto del jugador siendo cubo */
	method alturaSalto() = 3
	method jumpSteps() = 8	//resolucion de la animacion de salto del cubo, debe ser divisor de jumpTime()
	method jumpTime() = 320
	
	method frecuenciaPinchos() = 1500
	method frecuenciaBloques() = 800
	method frecuenciaColumna() = 500
	
	method blockDistance() = 8
	
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
