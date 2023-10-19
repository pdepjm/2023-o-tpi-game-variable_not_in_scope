import wollok.game.*
import logo.*
import Obstaculo.*
import niveles.*


const piso = 6 //308
const nivel1 = 10
const nivel2 = 13
const velRetroceso = 45
const alturaSalto = 3
const tiempoArriba = 30000
const frecuenciaPinchos = 1500
const tiempoPiso = 30000

const tiempoPorModo=30000

object juego {

	var property modoJuego = 1 
	//Generadores De Obstaculos
	var property cantidadPinchos = 0
	//var property eleccion = 0 Generador Antiguo
	
	
/*const opciones2 = [{new Obstaculo().aparecer()},{new ObstaculoDoble().aparecer()},{new ObstaculoTriple().aparecer()}]
	method generarInvasores() {
		game.onTick(3000,"aparece obstaculo",{opciones2.anyOne()})
	}
 */		
	
	method iniciar(){
		//game.cellSize(1)
		game.width(38.4)// 1920/50 = 38.4
		game.height(21.6)// 1080/50 = 21.6
		game.addVisualCharacter(logo)
		//game.addVisual(eliminador)
		
		
		//Si pongo tiempo en el piso primero no funciona, tengo que poner si o si cambio de nivel, tampoco funcionan los modos de juego auomaticos
		self.cambioNivel()
		game.schedule(35000,{self.tiempoEnElPiso()})
		game.schedule (70000,{self.cambioNivel()})
		
		
	}
	
	//ELegir Modo De Juego
	method modoDeJuego(){
		
		game.onTick(tiempoPorModo,"modo de juego",{self.seleccionar()})
	}
	
	method seleccionar(){
		
		modoJuego = new Range(start = 1, end = 2).anyOne()
		
		if(modoJuego==1){
			self.tiempoEnElPiso()
		}else if(modoJuego==2){
			self.cambioNivel()
		}
		
	}
	
	//Generadores 
	method generarInvasores(altura) {
		game.onTick(frecuenciaPinchos,"aparece obstaculo",{self.generador(altura)})
		
	}
	
	
	
	method generador(altura){
		
		cantidadPinchos = new Range(start = 1, end = 3).anyOne()
		cantidadPinchos.times({n=>game.schedule(velRetroceso*n,{new Obstaculo().aparecer(altura)})})
	}

//Modos De Juego
	
	method tiempoEnElPiso(){
		game.schedule(0,{self.generarInvasores(piso)})
		game.schedule(tiempoPiso-frecuenciaPinchos,{game.removeTickEvent("aparece obstaculo") })
	}
	
		method cambioNivel(){
		portal.aparecer(piso)
		game.onTick(velRetroceso,"crear piso",{new Plataforma().aparecer()})
		game.schedule(frecuenciaPinchos,{self.generarInvasores(nivel2+1)})
		game.schedule(tiempoArriba-frecuenciaPinchos,{game.removeTickEvent("aparece obstaculo") })
		game.schedule(tiempoArriba,{game.removeTickEvent("crear piso") })
		game.schedule(tiempoArriba,{portal.aparecer(nivel2+1)})
	}
		
	}
object perder{
	var property position = game.origin()
	var property image = "./assets/roto.png"
}


//Generador Antiguo
/*method generador(){
		
		
		//Obstaculo Simple
		self.eleccion(opciones.anyOne())
		if(eleccion==1){
			new Obstaculo().aparecer()
		
		}
		//Obstaculo Doble
		else if(eleccion==2){
			new Obstaculo().aparecer()
			game.schedule(velRetroceso*2,{new Obstaculo().aparecer()})
		}
		//Obstaculo Triple
		else if(eleccion==3){
		    new Obstaculo().aparecer()
			game.schedule(velRetroceso*2,{new Obstaculo().aparecer()})
			game.schedule(velRetroceso*2*2,{new Obstaculo().aparecer()})
		}
		
	}
*/
	


/*
object eliminador{
	var property position = game.at(0,piso)
	var property image = "./assets/eliminador.png"
}
 */
 
 
 
 object destello{
 	var property position = game.origin()
 	
 	var property image = "./assets/brillos/brillo1.png"
 	method aparecer(){
 		game.addVisual(self)
 		game.schedule(20,{image("./assets/brillos/brillo2.png")})
 		game.schedule(40,{image("./assets/brillos/brillo3.png")})
 		game.schedule(80,{image("./assets/brillos/brillo4.png")})
 		game.schedule(100,{image("./assets/brillos/brillo4.png")})
 		game.schedule(120,{image("./assets/brillos/brillo3.png")})	
 		game.schedule(140,{image("./assets/brillos/brillo2.png")})
 		game.schedule(160,{game.removeVisual(self)})
 		
 	}
 }
